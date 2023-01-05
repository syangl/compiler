%option noyywrap
%{
    #define YY_NO_UNPUT
    #define YY_NO_INPUT

    #include "parser.h"
    #include <ostream>
    #include <fstream>

    #include <iostream>
    #include <string>

    using namespace std;

    extern FILE *yyin; 
    extern FILE *yyout;
    extern bool dump_tokens;

    void DEBUG_FOR_LAB4(std::string s){
        std::string DEBUG_INFO = "[DEBUG LAB4]: \t" + s + "\n";
        fputs(DEBUG_INFO.c_str(), yyout);
    }
%}

FLOATDEC ((0|[1-9][0-9]*)\.[0-9][0-9]*[eE][+-]([1-9][0-9]*|0))
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
    /*
    * Questions: 
    *   Q1: Why we need to return INT in further labs?
    *   Q2: What is "INT" actually?
    */
    if(dump_tokens)
        DEBUG_FOR_LAB4("INT\tint");
    return INT;
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

"getint" {
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
    SymbolEntry *se = new IdentifierSymbolEntry(func, yytext, symt->getLevel(), true, -1); 
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
    SymbolEntry *se = new IdentifierSymbolEntry(func, yytext, symt->getLevel(), true, -1); 
    symt->install(yytext, se);
    return ID;
}

"getfloat" {
    // TODO:
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    // create FunctionType
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec_se;
    Type *func = new FunctionType(TypeSystem::floatType, vec, vec_se);
    // create SymbolEntry
    SymbolTable *symt = identifiers;
    while(symt->getPrev()){
        symt = symt->getPrev();
    }
    SymbolEntry *se = new IdentifierSymbolEntry(func, yytext, symt->getLevel(), true, -1); 
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
    SymbolEntry *se = new IdentifierSymbolEntry(func, yytext, symt->getLevel(), true, -1); 
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
    SymbolEntry *se = new IdentifierSymbolEntry(func, yytext, symt->getLevel(), true, -1); 
    symt->install(yytext, se);
    return ID;
}

"putfloat" {
    // TODO:
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    // create FunctionType
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec_se;
    vec.push_back(TypeSystem::floatType);
    Type *func = new FunctionType(TypeSystem::voidType, vec, vec_se);
    // create SymbolEntry
    SymbolTable *symt = identifiers;
    while(symt->getPrev()){
        symt = symt->getPrev();
    }
    SymbolEntry *se = new IdentifierSymbolEntry(func, yytext, symt->getLevel(), true, -1); 
    symt->install(yytext, se);
    return ID;
}

"putf" {
    // TODO:
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
    SymbolEntry *se = new IdentifierSymbolEntry(func, tmp, symt->getLevel(), true, -1); 
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
    SymbolEntry *se = new IdentifierSymbolEntry(func, tmp, symt->getLevel(), true, -1); 
    symt->install(tmp, se);
    return ID;   
}

{DECIMIAL} {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    yylval.itype = atoi(yytext);
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
{FLOATDEC} { //TODO: 先写十进制浮点数
    float float_dec;
    sscanf(yytext, "%f", &float_dec);
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    yylval.itype = float_dec;
    return FLOATDECIMAL; 
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
