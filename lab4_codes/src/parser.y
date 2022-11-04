%code top{
    #include <iostream>
    #include <assert.h>
    #include "parser.h"
    extern Ast ast;
    int yylex();
    int yyerror( char const * );
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

%nterm <stmttype> Stmts Stmt AssignStmt ExprStmt BlockStmt IfStmt WhileStmt BreakStmt ContinueStmt ReturnStmt DeclStmt FuncDef ConstDeclStmt ConstDef ConstDefList VarDeclStmt VarDef VarDefList 
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
    | BreakStmt {$$=$1;}
    | ContinueStmt {$$=$1;}
    | ReturnStmt {$$=$1;}
    | DeclStmt {$$=$1;}
    | FuncDef {$$=$1;}
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
    // | ID ArrayIndex {
    //     SymbolEntry *se;
    //     se = identifiers->lookup($1);
    //     if(se == nullptr)
    //     {
    //         fprintf(stderr, "identifier \"%s\" is undefined\n", (char*)$1);
    //         delete [](char*)$1;
    //         assert(se != nullptr);
    //     }
    //     $$ = new IdArrayIndex(se, $2);// TODO
    //     delete []$1;    
    // }
    ;
AssignStmt
    :
    LVal ASSIGN Exp SEMICOLON {
        $$ = new AssignStmt($1, $3);
    }
    ;
ExprStmt
    : Exp SEMICOLON {
        $$ = new ExprStmt($1);
    }
    |
    SEMICOLON {}
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
IfStmt
    : IF LPAREN Cond RPAREN Stmt %prec THEN {
        $$ = new IfStmt($3, $5);
    }
    | IF LPAREN Cond RPAREN Stmt ELSE Stmt {
        $$ = new IfElseStmt($3, $5, $7);
    }
    ;
WhileStmt
    : WHILE LPAREN Cond RPAREN Stmt {
        $$ = new WhileStmt($3, $5);
    }
    ;
BreakStmt
    : BREAK SEMICOLON {
        $$ = new BreakStmt();
    }
    ;
ContinueStmt
    : CONTINUE SEMICOLON {
        $$ = new ContinueStmt();
    }
    ;
ReturnStmt
    :
    RETURN Exp SEMICOLON{
        $$ = new ReturnStmt($2);
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
    LVal {
        $$ = $1;
    }
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
        $$ = new UnaryExpr(nullptr, UnaryExpr::SUB, $2);
    }
    | 
    NOT UnaryExp {
        $$ = new UnaryExpr(nullptr, UnaryExpr::NOT, $2);
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
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESS, $1, $3);
    }
    | 
    RelExp LEQU AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LEQU, $1, $3);
    }
    | 
    RelExp GREAT AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::GREAT, $1, $3);
    }
    | 
    RelExp GEQU AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::GEQU, $1, $3);
    }
    ;
EqExp
    :
    RelExp {$$ = $1;}
    |
    EqExp EQUAL RelExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::EQUAL, $1, $3);
    }
    |
    EqExp NOTEQUAL RelExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::NOTEQUAL, $1, $3);
    }
    ;
LAndExp
    :
    EqExp {$$ = $1;}
    |
    LAndExp AND EqExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::AND, $1, $3);
    }
    ;
LOrExp
    :
    LAndExp {$$ = $1;}
    |
    LOrExp OR LAndExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::OR, $1, $3);
    }
    ;
FuncRParams 
    : 
    Exp {$$ = $1;}
    | 
    FuncRParams COMMA Exp {
        $$ = $1;
        Node *tmp;
        tmp = tmp;
        tmp = $1->getRightestBro()->brother();
        tmp = $3; // TODO
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
   
    /* Type ID SEMICOLON {
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($1, $2, identifiers->getLevel());
        identifiers->install($2, se);
        $$ = new DeclStmt(new Id(se));
        delete []$2;
    } */
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
        Node *tmp;
        tmp = tmp;
        tmp = $1->getRightestBro()->brother();
        tmp = $3;
    } 
    | 
    VarDef {$$ = $1;}
    ;
ConstDefList
    :
    ConstDefList COMMA ConstDef {
        $$ = $1;
        Node *tmp;
        tmp = tmp;
        tmp = ($1->getRightestBro()->brother());
        tmp = $3; // TODO
    }
    |
    ConstDef {$$ = $1;}
    ;
VarDef
    :
    ID {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers->getLevel());
        identifiers->install($1, se);
        $$ = new DeclStmt(new Id(se));
        delete []$1;
    }
    // |
    // ID ArrayIndex {

    // }
    |
    ID ASSIGN InitVal {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers->getLevel());
        identifiers->install($1, se);
        ((IdentifierSymbolEntry*)se)->setValue($3->intValue());
        $$ = new DeclStmt(new Id(se), $3);
        delete []$1;
    }
    // |
    // ID ArrayIndex ASSIGN {

    // }
    // InitVal {

    // }
    ;
// TODO:
ConstDef
    :
    ID ASSIGN ConstInitVal {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::constIntType, $1, identifiers->getLevel());
        identifiers->install($1, se);
        ((IdentifierSymbolEntry*)se)->setValue($3->intValue());
        $$ = new DeclStmt(new Id(se), $3);
        delete []$1; 
    }
    // |
    // ID ArrayIndex ASSIGN {

    // } 
    // ConstInitVal {

    // }TODO:
    ;
ConstInitVal
    :
    Exp {
        $$ = $1;
    }
     // |
     // LBRACE RBRACE {
     // }
     // | 
     // LBRACE {
     // }
     //     ConstInitValList RBRACE {
     // }
     ;
InitVal
    : Exp {$$ = $1;} 
    ;//TODO: array init
/* InitValList
    : InitVal {$$ = $1;}
    | InitValList COMMA InitVal {
         $$ = $1;
         $1->getRightestBro()->brother = $3;
    }
    ; */
/* ConstInitValList
    :
    ConstInitVal {
        $$ = $1;
    }
    |
    ConstInitValList COMMA ConstInitVal {
         $$ = $1;
         $1->getRightestBro()->brother = $3;
    } 
    ; */
// ArrayIndex
//     :
//     LBRACKET Exp RBRACKET {
//         $$ = $2;
//     }
//     | ArrayIndex LBRACKET ConstExp RBRACKET {
//         $$ = $1;
//         $1->getRightestBro()->brother = $3;
//     }
//     ;
FuncDef
    :
    Type ID {
        Type *funcType;
        funcType = new FunctionType($1,{});
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());
        identifiers->install($2, se);
        identifiers = new SymbolTable(identifiers);
    }
    LPAREN RPAREN
    BlockStmt
    {
        SymbolEntry *se;
        se = identifiers->lookup($2);
        assert(se != nullptr);
        $$ = new FunctionDef(se, $6);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
        delete []$2;
    }
    ;
%%

int yyerror(char const* message)
{
    std::cerr<<message<<std::endl;
    return -1;
}
