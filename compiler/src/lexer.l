%option noyywrap
%{
    /**
     * note：
     * 
     * 上下文无关文法CFG：
     *      终结符、非终结符、产生式（非终结符 -> 终结符/非终结符，如expr -> expr + digit |  expr - digit | digit）、开始符号
     * 
     * 词法分析：
     *      去除空白符和注释、常量、标识符和关键字识别，向语法分析器传递token和属性
     *      词法分析流程：
     *          源程序字符流 -> 词法分析器 -> token流 -> 语法制导翻译 -> 中间代码生成
     * 
     * 语法分析：
     *      自上而下（推导）和自下而上（移进规约）分析法
     *      推导：
     *          由开始符号作为推导起点；用产生式右部替换左部非终结符；反复替换，最终得到单词串（这个推导过程自然形成一棵语法分析树的结构）
     *      语法分析树：
     *          根节点标记为开始符号，父结点在推导过程中被孩子结点替换，叶节点从左至右构成树的输出（对应最左推导的结果）
     *      
     * 语义分析：
     *      执行规定的语义动作，如：表达式求值、符号表的查询/填写、中间代码生成等。
     *      
     *      语法制导定义：
     *          两个部分：设计文法符号属性值，表示翻译的结果；翻译方法转换为语义规则（语义动作）——属性的运算，将其附着于产生式
     *          如下（rule为表达式的后缀表示形式）：
     *          --------------------------------------------------------------------
     *          |           Production           |          Semantic Rule          |
     *          --------------------------------------------------------------------
     *          |     expr -> expr1 + term       |  expr.t = expr1.t||term.t||‘+’  |
     *          |     expr -> expr1 - term       |  expr.t = expr1.t||term.t||‘-’  |
     *          |     ...                        |  ...                            |    
     *          |     term -> 0                  |  term.t = ‘0’                   |
     *          --------------------------------------------------------------------   
     * 
     * 
     *      翻译模式（程序段，如何做，利用翻译模式完成语法树的创建，类型检查和中间代码生成）：
     *          在产生式右部添加了称为语义动作的程序段（从左DFS遍历分析树时对应下面产生式右部从左往右扫描，
     *          遇到语义动作就执行print，遇到其他叶节点返回，这样输出是后缀表达式）：
     *          --------------------------------------------------------------------
     *          |           Production                                             |
     *          --------------------------------------------------------------------
     *          |     expr -> expr1 + term {print('+')}                            |
     *          |     expr -> expr1 - term {print('-')}                            |
     *          |     ...                                                          |    
     *          |     term -> 0 {print('0')}                                       |
     *          --------------------------------------------------------------------  
     *            
     * 
     * 符号表：
     *      编译器在分析阶段收集信息存入符号表，在综合阶段使用符号表中的信息生成目标代码。
     *      符号表是一个栈，这样就可以区分作用域，栈顶是当前作用域，首先在当前符号表查找，找不到就到prev查找。
     * 
     * 类型系统：
     *      编译器的实现把类型系统也抽象封装成了对象；可以利用翻译模式的程序段实现类型检查。
     * 
     * 中间代码生成：
     *      编译程序可移植，便于代码优化。通过将不同源语言翻译成同一中间代码，再基于中间代码生成不同架构的目标代码，我们可以极大的简化编译器的构造。
     *      
     *      实现采用llvm IR中间代码，llvm的特点：
     *          模块（Module）：LLVM IR的最顶层结构是模块，表示整个程序或库。一个模块由一组全局变量和函数组成。
     *          
     *          全局变量（Global Variables）：LLVM IR允许声明全局变量，它们是在整个程序中可见的。全局变量由其类型、名称和可选的初始值组成。
     *          全局变量的声明以@符号开头，后面跟着变量名称和类型信息。例如，@myGlobal = global i32 0表示一个名为myGlobal的32位整数全局变量，初始值为0。
     *          
     *          函数（Functions）：LLVM IR中的函数由函数类型、名称、参数列表和函数体组成。函数类型包括返回类型和参数类型。
     *          函数的声明以define关键字开头，后面是返回类型、函数名称、参数列表和函数体。函数体由基本块（Basic Block）组成，每个基本块由一组指令组成。函数体的最后一条指令通常是返回指令。
     *          
     *          基本块（Basic Blocks）：基本块是LLVM IR中的基本执行单元。它由一系列按顺序执行的指令组成，没有分支或跳转指令。
     *          基本块以标签（Label）开头，后面是一组指令。基本块可以包含控制流指令，如条件分支和无条件跳转，以便实现程序的控制流程。
     *          
     *          指令（Instructions）：LLVM IR包括各种指令来表示程序的操作。指令由操作码和操作数组成，用于执行特定的操作。
     *          LLVM IR支持常见的指令类型，如赋值指令、算术运算指令、逻辑运算指令、条件分支指令、内存访问指令等。指令可以使用变量、常量和表达式作为操作数。
     * 
     *      builder： 
     *           是IRBuilder类对象，用于传递继承属性，辅助我们进行中间代码生成。首先通过builder得到后续生成的指令要插入的基本块bb，然后生成子表达式的中间代码，
     *           通过getOperand 函数得到子表达式的目的操作数，设置指令的操作码，最后生成相应的二元运算指令并插入到基本块bb中。
     * 
     *      翻译后的中间代码，体现了基本块的概念：
     *          define i32 @main() {
     *          B17:
     *              %t20 = alloca i32, align 4
     *              %t19 = alloca i32, align 4
     *              ...
     *              br i1 %t11, label %B21, label %B24
     *          B21: 
     *              %t13 = load i32, i32* %t18, align 4
     *              store i32 %t13, i32* %t20, align 4
     *              br label %B23
     *          B24: 
     *              br label %B22
     *          ...
     * 
     * 目标代码生成：
     *      Ast.cpp
     * 
     * 
     * 寄存器分配算法——线性扫描算法：
     *      线性扫描寄存器分配算法的基本思想是，通过一次线性扫描来分配寄存器，从而在程序的不同位置为变量分配寄存器。
     *      以下是线性扫描寄存器分配算法的主要步骤：
     *          集合list表示所有虚拟寄存器live interval的集合，以其开始点升序排列。
     *          集合active为当前活跃虚拟寄存器（已占用寄存器的那些）live interval的集合，以结束点升序排列。
     *          可用物理寄存器个数为R。
     *          S1：对集合list中的虚拟寄存器按顺序扫描，每次取出一个虚拟寄存器的interval；
     *          S2：根据新的虚拟寄存器的interval，以其开始点为“当前点”，若集合active中有虚拟寄存器的结束点小于"当前点"，则说明其在“当前点”不再活跃，将其从集合active删掉，并释放相应的物理寄存器;
     *          S3：若集合active中虚拟寄存器的个数小于R自然可以分配，若集合active中虚拟寄存器的个数等于R，则需要溢出一个虚拟寄存器到内存。溢出规则是选择结束点最大的将其溢出。因为集合active中的虚拟寄存器是按结束点升序排列的，
     *              所以溢出必然“集合active中的最后一个虚拟寄存器”或“新的虚拟寄存器”。若集合active中虚拟寄存器的个数小于R，则将这个新的虚拟寄存器加入集合active（list集合就少了一个），
     *              并为其分配一个物理寄存器。
     *          S4：返回S1，至到集合list中的虚拟寄存器扫描完。
     *      
     *      最后调用linearScan修改MachineOperand的寄存器号
    */

    /**
     * lex程序定义：
     *      定义段：
     *      %{
     *        C语言代码
     *      %}
     *      定义
     *      %%
     *      规则段（正则表达式+语义动作，得到的词法分析程序即识别这些正则表达式对应的单词，识别出一个单词就执行对应语义动作）
     *      %%
     *      用户子程序段
     * 
     * 全局变量yylineno：了解当前处理到文件的第几行
     * yytext：总是指向当前匹配的字符串
     * yylval：全局变量用于将与token关联的语义值从词法分析器传递到parser。 符号的语义值在yacc操作中作为 $1、$2 等进行访问，并通过分配给 $$ 来设置非终结符
    */

    #define YY_NO_UNPUT
    #define YY_NO_INPUT

    #include "parser.h"
    #include <ostream>
    #include <fstream>

    #include <iostream>
    #include <string>

    using namespace std;

    extern FILE *yyin; // yyin 和yyout 分别由命令行传递的参数(argv) 捕获输入文件和输出文件名称
    extern FILE *yyout;
    extern bool dump_tokens;

    void DEBUG_FOR_LAB4(std::string s){
        std::string DEBUG_INFO = "[DEBUG LAB4]: \t" + s + "\n";
        fputs(DEBUG_INFO.c_str(), yyout);
    }
%}

OCTAL (0([1-7][0-7]*|0))
HEXADECIMAL (0[xX][0-9A-Fa-f]+)
DECIMIAL ([1-9][0-9]*|0)
ID [[:alpha:]_][[:alpha:][:digit:]_]*
EOL (\r\n|\n|\r)
WHITE [\t ]
LINECOMMENT \/\/[^\n]*
COMMENTBEGIN "/*"
COMMENTELEMENT .|\n
COMMENTEND "*/"
%x BLOCKCOMMENT

%%
{COMMENTBEGIN} {BEGIN BLOCKCOMMENT;}
<BLOCKCOMMENT>{COMMENTELEMENT} {}
<BLOCKCOMMENT>{COMMENTEND} {BEGIN INITIAL;}

{LINECOMMENT} {}

"int" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("INT\tint");
    return INT; // 返回传送给了YACC
}
"void" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("VOID\tvoid");
    return VOID;
}
"float" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("FLOAT\tfloat");
    return FLOAT;
}
"const" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("CONST\tconst");
    return CONST;
}

"if" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("IF\tif");
    return IF;
};
"else" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ELSE\telse");
    return ELSE;
};

"while" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("WHILE\twhile");
    return WHILE;
}
"break" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("BREAK\tbreak");
    return BREAK;
}
"continue" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("CONTINUE\tcontinue");
    return CONTINUE;
}

"return" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RETURN\treturn");
    return RETURN;
}

"=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ASSIGN\t=");
    return ASSIGN;
}
"<" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LESS\t<");
    return LESS;
}
"<=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LEQU\t<=");
    return LEQU;
}
"==" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("EQUAL\t==");
    return EQUAL;
}
"!=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("NOTEQUAL\t!=");
    return NOTEQUAL;
}
">" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("GREATER\t>");
    return GREAT;
}
">=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("GEQ\t>=");
    return GEQU;
}

"+" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ADD\t+");
    return ADD;
}
"-" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("SUB\t-");
    return SUB;
}
"*" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("MUL\t*");
    return MUL;
}
"/" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("DIV\t/");
    return DIV;
}
"%" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("MOD\t%");
    return MOD;
}

"&&" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("AND\t&&");
    return AND;
}
"||" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("OR\t||");
    return OR;
}
"!" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("NOT\t!");
    return NOT;
}

";" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("SEMICOLON\t;");
    return SEMICOLON;
}
"," {
    if(dump_tokens)
        DEBUG_FOR_LAB4("COMMA\t,");
    return COMMA;
}
"." {
    if(dump_tokens)
        DEBUG_FOR_LAB4("SPOT\t.");
    return SPOT;
}
"(" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LPAREN\t(");
    return LPAREN;
}
")" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RPAREN\t)");
    return RPAREN;
}
"{" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LBRACE\t{");
    return LBRACE;
}
"}" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RBRACE\t}");
    return RBRACE;
}
"[" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LBRACKET\t[");
    return LBRACKET;
}
"]" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RBRACKET\t]");
    return RBRACKET;
}

"getint" { // 读到getint函数
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme; 
    // create FunctionType
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec_se;
    Type *func = new FunctionType(TypeSystem::intType, vec, vec_se);
    // create SymbolEntry
    SymbolTable *symt = identifiers;
    while(symt->getPrev()){ // 回到调用getint的作用域，加入表项
        symt = symt->getPrev();
    }
    SymbolEntry *se = new IdentifierSymbolEntry(func, yytext, symt->getLevel(), -1, true); 
    symt->install(yytext, se);
    return ID;
}

"getch" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    // create FunctionType
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec_se;
    Type *func = new FunctionType(TypeSystem::intType, vec, vec_se);
    // create SymbolEntry
    SymbolTable *symt = identifiers;
    while(symt->getPrev()){
        symt = symt->getPrev();
    }
    SymbolEntry *se = new IdentifierSymbolEntry(func, yytext, symt->getLevel(), -1, true); 
    symt->install(yytext, se);
    return ID;
}

"putint" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    // create FunctionType
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec_se;
    vec.push_back(TypeSystem::intType);
    Type *func = new FunctionType(TypeSystem::voidType, vec, vec_se);
    // create SymbolEntry
    SymbolTable *symt = identifiers;
    while(symt->getPrev()){
        symt = symt->getPrev();
    }
    SymbolEntry *se = new IdentifierSymbolEntry(func, yytext, symt->getLevel(), -1, true); 
    symt->install(yytext, se);
    return ID;
}

"putch" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    // create FunctionType
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec_se;
    vec.push_back(TypeSystem::intType);
    Type *func = new FunctionType(TypeSystem::voidType, vec, vec_se);
    // create SymbolEntry
    SymbolTable *symt = identifiers;
    while(symt->getPrev()){
        symt = symt->getPrev();
    }
    SymbolEntry *se = new IdentifierSymbolEntry(func, yytext, symt->getLevel(), -1, true); 
    symt->install(yytext, se);
    return ID;
}

"starttime" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
	char *lexeme;
    lexeme = new char[6 + strlen(yytext) + 1];
	char* sysy = (char *)"_sysy_";
	strcpy(lexeme, sysy);
	strcpy(lexeme + 6, yytext);
    yylval.strtype = lexeme;
    // create FunctionType
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec_se;
    Type *func = new FunctionType(TypeSystem::voidType, vec, vec_se);
    // create SymbolEntry
    SymbolTable *symt = identifiers;
    while(symt->getPrev()){
        symt = symt->getPrev();
    }
    char *tmp = new char[6+strlen(yytext)];
    memcpy(tmp, lexeme, 6+strlen(yytext));
    SymbolEntry *se = new IdentifierSymbolEntry(func, tmp, symt->getLevel(), -1, true); 
    symt->install(tmp, se);
    return ID;    
}

"stoptime" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
	char *lexeme;
    lexeme = new char[6 + strlen(yytext) + 1];
	char* sysy = (char *)"_sysy_";
	strcpy(lexeme, sysy);
	strcpy(lexeme + 6, yytext);
    yylval.strtype = lexeme;
    // create FunctionType
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec_se;
    Type *func = new FunctionType(TypeSystem::voidType, vec, vec_se);
    // create SymbolEntry
    SymbolTable *symt = identifiers;
    while(symt->getPrev()){
        symt = symt->getPrev();
    }
    char *tmp = new char[6+strlen(yytext)];
    memcpy(tmp, lexeme, 14);
    SymbolEntry *se = new IdentifierSymbolEntry(func, tmp, symt->getLevel(), -1, true); 
    symt->install(tmp, se);
    return ID;   
}

{DECIMIAL} {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    yylval.itype = atoi(yytext); // 字符串转整型
    return INTEGER;
}
{OCTAL} {
    int octal;
    sscanf(yytext, "%o", &octal);
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    yylval.itype = octal;
    return INTEGER;
}
{HEXADECIMAL} {
    int hex;
    sscanf(yytext, "%x", &hex);
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    yylval.itype = hex;
    return INTEGER;
}

{ID} {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    return ID;
}
{EOL} yylineno++;
{WHITE}
%%
