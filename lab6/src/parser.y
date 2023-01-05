%code top{
    #include <iostream>
    #include <assert.h>
    #include <stack>
    #include "parser.h"
    extern Ast ast;
    int yylex();
    int yyerror( char const * );
    // break continue
    int count = 0;
    std::stack<StmtNode*> whileStack;
    int pNo = 0;
}

%code requires {
    #include "Ast.h"
    #include "SymbolTable.h"
    #include "Type.h"
}

%union {
    int itype;
    char* strtype;
    StmtNode* stmttype;
    ExprNode* exprtype;
    SymbolEntry* se;
    Type* type;
}

%start Program
%token <strtype> ID 
%token <itype> INTEGER FLOATDECIMAL
%token IF ELSE WHILE
%token INT VOID FLOAT
%token LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET SEMICOLON COMMA SPOT
%token ADD SUB MUL DIV MOD OR AND LESS LEQU EQUAL NOTEQUAL GREAT GEQU NOT ASSIGN
%token RETURN CONTINUE BREAK
%token CONST

%nterm <stmttype> Stmts Stmt AssignStmt ExprStmt BlockStmt IfStmt WhileStmt BreakStmt ContinueStmt ReturnStmt DeclStmt FuncDef ConstDeclStmt ConstDef ConstDefList VarDeclStmt VarDef VarDefList FuncFParam FuncFParams EmptyStmt
%nterm <exprtype> Exp AddExp Cond LOrExp PrimaryExp LVal RelExp LAndExp EqExp MulExp UnaryExp ConstInitVal InitVal FuncRParams
%nterm <type> Type

%precedence THEN
%precedence ELSE
%%
Program
    : Stmts {
        ast.setRoot($1);
    }
    ;
Stmts
    : Stmt {$$=$1;}
    | Stmts Stmt{
        $$ = new SeqNode($1, $2);
    }
    ;
Stmt
    : AssignStmt {$$=$1;}
    | ExprStmt {$$=$1;}
    | BlockStmt {$$=$1;}
    | IfStmt {$$=$1;}
    | WhileStmt {$$=$1;}
    | BreakStmt {
        if (count != 0){
            fprintf(stderr, "\"break\" is out of a while statement\n");
        }
        $$=$1;
    }
    | ContinueStmt {
        if (count != 0){
            fprintf(stderr, "\"continue\" is out of a while statement\n");
        }
        $$=$1;
    }
    | ReturnStmt {$$=$1;}
    | DeclStmt {$$=$1;}
    | FuncDef {$$=$1;}
    | EmptyStmt {$$=$1;}
    ;
LVal
    : ID {
        SymbolEntry *se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "identifier \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        $$ = new Id(se);
        delete []$1;
    }
    ;
AssignStmt
    :
    LVal ASSIGN Exp SEMICOLON {
        $$ = new AssignStmt($1, $3);
    }
    ;
ExprStmt
    : 
    Exp SEMICOLON {
        $$ = new ExprStmt($1);
    }
    ;
BlockStmt
    :   LBRACE 
        {identifiers = new SymbolTable(identifiers);} 
        Stmts RBRACE 
        {
            $$ = new CompoundStmt($3);
            SymbolTable *top = identifiers;
            identifiers = identifiers->getPrev();
            delete top;
        }
    ;
EmptyStmt
    :
    SEMICOLON {
        // 空语句情况1，只有;
        $$ = new EmptyStmt();
    }
    |
    LBRACE RBRACE {
        // 空语句情况2，{}，代替BlockStmt
        $$ = new EmptyStmt();
    }
    ;
IfStmt
    : IF LPAREN Cond RPAREN Stmt %prec THEN {
        $$ = new IfStmt($3, $5);
    }
    | IF LPAREN Cond RPAREN Stmt ELSE Stmt {
        $$ = new IfElseStmt($3, $5, $7);
    }
    ;
WhileStmt
    : WHILE LPAREN Cond RPAREN {
        //进入while要count+1
        ++count;
        WhileStmt *whileStmt = new WhileStmt($3);
        $<stmttype>$ = whileStmt;
        whileStack.push(whileStmt);
    }
    Stmt {
        //退出while要count-1
        StmtNode *whileStmtNode = $<stmttype>5;
        ((WhileStmt*)whileStmtNode)->setStmt($6);
        $$ = whileStmtNode;
        whileStack.pop();
        --count;
    }
    ;
BreakStmt
    : BREAK SEMICOLON {
        StmtNode *whileStmt = whileStack.top();
        $$ = new BreakStmt(whileStmt);
    }
    ;
ContinueStmt
    : CONTINUE SEMICOLON {
        StmtNode *whileStmt = whileStack.top();
        $$ = new ContinueStmt(whileStmt);
    }
    ;
ReturnStmt
    :
    RETURN Exp SEMICOLON{
        $$ = new ReturnStmt($2);
    }
    |
    RETURN SEMICOLON {
        $$ = new ReturnStmt();
    }
    ;
Exp
    :
    AddExp {$$ = $1;}
    ;
Cond
    :
    LOrExp {$$ = $1;}
    ;
PrimaryExp
    :
    LPAREN Exp RPAREN {
        $$ = $2;
    }
    | 
    LVal {$$ = $1;}
    | 
    INTEGER {
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, $1);
        $$ = new Constant(se);
    }
    ;
UnaryExp
    :
     PrimaryExp  {$$ = $1;}
    | 
    ID LPAREN FuncRParams RPAREN {
        SymbolEntry* se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "function \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        $$ = new FunctionCallExpr(se, $3);
    }
    | 
    ID LPAREN RPAREN {
        SymbolEntry* se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "function \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        $$ = new FunctionCallExpr(se);
    }
    | 
    ADD UnaryExp {$$ = $2;}
    | 
    SUB UnaryExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new UnaryExpr(se, UnaryExpr::SUB, $2);
    }
    | 
    NOT UnaryExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new UnaryExpr(se, UnaryExpr::NOT, $2);
    }
    ;
MulExp
    :
    UnaryExp {$$ = $1;}
    | 
    MulExp MUL UnaryExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MUL, $1, $3);
    }
    | 
    MulExp DIV UnaryExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::DIV, $1, $3);
    }
    | 
    MulExp MOD UnaryExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MOD, $1, $3);
    }
    ;
AddExp
    :
    MulExp {$$ = $1;}
    |
    AddExp ADD MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
    }
    |
    AddExp SUB MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);
    }
    ;
RelExp
    :
    AddExp {$$ = $1;}
    |
    RelExp LESS AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESS, $1, $3);
    }
    | 
    RelExp LEQU AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LEQU, $1, $3);
    }
    | 
    RelExp GREAT AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::GREAT, $1, $3);
    }
    | 
    RelExp GEQU AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::GEQU, $1, $3);
    }
    ;
EqExp
    :
    RelExp {$$ = $1;}
    |
    EqExp EQUAL RelExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::EQUAL, $1, $3);
    }
    |
    EqExp NOTEQUAL RelExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::NOTEQUAL, $1, $3);
    }
    ;
LAndExp
    :
    EqExp {$$ = $1;}
    |
    LAndExp AND EqExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::AND, $1, $3);
    }
    ;
LOrExp
    :
    LAndExp {$$ = $1;}
    |
    LOrExp OR LAndExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::OR, $1, $3);
    }
    ;
FuncRParams 
    : 
    Exp {$$ = $1;}
    | 
    FuncRParams COMMA Exp {
        $$ = $1;
        // Node *tmp;
        // tmp = tmp;
        // tmp = $1->getRightestBro()->brother();
        // tmp = $3; 
        $$->getRightestBro($3);
    }
    ;
Type
    : INT {
        $$ = TypeSystem::intType;
    }
    | VOID {
        $$ = TypeSystem::voidType;
    }
    | FLOAT {
        $$ = TypeSystem::floatType;
    }
    ;
DeclStmt
    :
    VarDeclStmt {$$ = $1;}
    |
    ConstDeclStmt { $$ = $1;}
    ;
VarDeclStmt
    : 
    Type VarDefList SEMICOLON {$$ = $2;}
    ;
ConstDeclStmt
    :
    CONST Type ConstDefList SEMICOLON {
        $$ = $3;
    }
    ;
VarDefList
    :
    VarDefList COMMA VarDef {
        $$ = $1;
        // Node *tmp;
        // tmp = tmp;
        // tmp = $1->getRightestBro()->brother();
        // tmp = $3;
        $$->getRightestBro($3);
    } 
    | 
    VarDef {$$ = $1;}
    ;
ConstDefList
    :
    ConstDefList COMMA ConstDef {
        $$ = $1;
        // Node *tmp;
        // tmp = tmp;
        // tmp = ($1->getRightestBro()->brother());
        // tmp = $3; // TODO
        $$->getRightestBro($3);
    }
    |
    ConstDef {$$ = $1;}
    ;
VarDef
    :
    ID {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers->getLevel());
        //不实现函数重载
        bool success = identifiers->install($1, se);
        if(!success){
            fprintf(stderr, "identifier \"%s\" is already defined\n", (char*)$1);
        }
        $$ = new DeclStmt(new Id(se));
        delete []$1;
    }
    |
    ID ASSIGN InitVal {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers->getLevel());
        //不实现函数重载
        bool success = identifiers->install($1, se);
        if(!success){
            fprintf(stderr, "identifier \"%s\" is already defined\n", (char*)$1);
        }
        ((IdentifierSymbolEntry*)se)->setValue($3->intValue());
        $$ = new DeclStmt(new Id(se), $3);
        delete []$1;
    }
    ;
// TODO:
ConstDef
    :
    ID ASSIGN ConstInitVal {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::constIntType, $1, identifiers->getLevel());
        ((IdentifierSymbolEntry*)se)->setConstant();
        bool success = identifiers->install($1, se);
        if(!success){
            fprintf(stderr, "identifier \"%s\" is already defined\n", (char*)$1);
        }//...
        ((IdentifierSymbolEntry*)se)->setValue($3->intValue());
        $$ = new DeclStmt(new Id(se), $3);
        delete []$1; 
    }
    ;
ConstInitVal
    :
    Exp {
        $$ = $1;
    }
     ;
InitVal
    : Exp {
        if(!$1->getType()->isInt()){
            fprintf(stderr, "cannot initialize a variable of type \"int\" with a rvalue of type \'%s\'\n",
                $1->getType()->toStr().c_str());
        }
        $$ = $1;
    } 
    ;
FuncDef
    :
    Type ID {
        identifiers = new SymbolTable(identifiers);
        pNo = 0;
    }
    LPAREN FuncFParams RPAREN {
        Type *funcType;
        std::vector<Type*> vec;
        std::vector<SymbolEntry*> vec_se;
        DeclStmt* fparam = (DeclStmt*)$5;
        while (fparam) {
            vec.push_back(fparam->getId()->getSymbolEntry()->getType());
            vec_se.push_back(fparam->getId()->getSymbolEntry());
            fparam = (DeclStmt*)(fparam->brother());
        }
        funcType = new FunctionType($1, vec, vec_se);
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getPrev()->getLevel());
        bool success = identifiers->getPrev()->install($2, se);
        if(!success){
            fprintf(stderr, "redefinition of \'%s %s\'\n", $2, ((IdentifierSymbolEntry*)se)->getName().c_str()/*se->getType()->toStr().c_str()*/);
        }
        $<se>$ = se;
    }
    BlockStmt
    {
        // SymbolEntry *se;
        // se = identifiers->lookup($2);
        // assert(se != nullptr);
        $$ = new FunctionDef($<se>7, $8, (DeclStmt*)$5);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
        delete []$2;
    }
    ;
FuncFParams
    :
    %empty {$$=nullptr;} //empty的说明：https://www.gnu.org/software/bison/manual/html_node/Empty-Rules.html#:~:text=The%20%25empty%20directive%20allows%20to%20make%20explicit%20that,Bison%20extension%2C%20it%20does%20not%20work%20with%20Yacc.
    |
    FuncFParam {$$ = $1;}
    |
    FuncFParams COMMA FuncFParam {
        $$ = $1;
        // Node *tmp;
        // tmp = tmp;
        // tmp = ($1->getRightestBro()->brother());
        // tmp = $3;
        $$->getRightestBro($3);
    }
    ;
FuncFParam
    :
    Type ID {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry($1, $2, identifiers->getLevel(), pNo++);
        identifiers->install($2, se);
        ((IdentifierSymbolEntry*)se)->setLabel();
        ((IdentifierSymbolEntry*)se)->setAddr(new Operand(se));
        $$ = new DeclStmt(new Id(se));
        delete []$2;
    }
    ;
%%

int yyerror(char const* message)
{
    std::cerr<<message<<std::endl;
    return -1;
}
