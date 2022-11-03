%option noyywrap
%{
    /*
    * You will need to comment this line in lab5.
    */
    #define ONLY_FOR_LEX 1
    
    #ifdef ONLY_FOR_LEX
    #else
    #define YYSTYPE void *
    #include "parser.h"
    #endif

    #define YY_NO_UNPUT
    #define YY_NO_INPUT
    #include <string.h>

    #ifdef ONLY_FOR_LEX
    #include <ostream>
    #include <fstream>
    using namespace std;
    extern FILE *yyin; 
    extern FILE *yyout;

    void DEBUG_FOR_LAB4(std::string s){
        std::string DEBUG_INFO = "[DEBUG LAB4]: \t" + s + "\n";
        fputs(DEBUG_INFO.c_str(), yyout);
    }

    int lbraces = 0, rbraces = 0;
    #endif
%}

FLOATDECIMIAL ((0|[1-9][0-9]*)\.[0-9][0-9]*)
OCTAL (0([1-7][0-7]*|0))
HEXADECIMAL (0[xX][0-9a-fA-f]+)
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

{LINECOMMENT}

"int" {
    /*
    * Questions: 
    *   Q1: Why we need to return INT in further labs?
    *   Q2: What is "INT" actually?
    */
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("INT\tint"+strdebug);
    #else
        return INT;
    #endif
}
"void" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("VOID\tvoid"+strdebug);
    #else
        return VOID;
    #endif 
}
"float" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("FLOAT\tfloat"+strdebug);
    #else
        return FLOAT;
    #endif 
}
"const" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("CONST\tconst"+strdebug);
    #else
        return CONST;
    #endif 
}
"if" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("IF\tif"+strdebug);
    #else
        return IF;
    #endif
};
"else" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("ELSE\telse"+strdebug);
    #else
        return ELSE;
    #endif
};
"while" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("WHILE\twhile"+strdebug);
    #else
        return WHILE;
    #endif
}
"break" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("BREAK\tbreak"+strdebug);
    #else
        return BREAK;
    #endif
}
"continue" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("CONTINUE\tcontinue"+strdebug);
    #else
        return CONTINUE;
    #endif
}
"return" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("RETURN\treturn"+strdebug);
    #else
        return RETURN;
    #endif
}

"=" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("ASSIGN\t="+strdebug);
    #else
        return ASSIGN;
    #endif
}
"<" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("LESS\t<"+strdebug);
    #else
        return LESS;
    #endif
}
">" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("GREAT\t>"+strdebug);
    #else
        return GREAT;
    #endif
}
"<=" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("LESSEQU\t<="+strdebug);
    #else
        return LESSEQU;
    #endif
}
">=" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("GREATEQU\t>="+strdebug);
    #else
        return GREATEQU;
    #endif
}
"!=" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("NOTEQU\t!="+strdebug);
    #else
        return NOTEQU;
    #endif
}
"==" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("EQU\t=="+strdebug);
    #else
        return EQU;
    #endif
}
"||" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("OR\t||"+strdebug);
    #else
        return ||;
    #endif
}
"&&" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("AND\t&&"+strdebug);
    #else
        return &&;
    #endif
}
"!" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("NOT\t!"+strdebug);
    #else
        return !;
    #endif
}
"+" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("ADD\t+"+strdebug);
    #else
        return ADD;
    #endif
}
"-" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("SUB\t-"+strdebug);
    #else
        return SUB;
    #endif
}
"*" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("MUL\t*"+strdebug);
    #else
        return MUL;
    #endif
}
"/" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("DIV\t/"+strdebug);
    #else
        return DIV;
    #endif
}
"%" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("MOD\t%"+strdebug);
    #else
        return MOD;
    #endif
}
"." {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("SPOT\t."+strdebug);
    #else
        return SPOT;
    #endif
}
"," {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("COMMA\t,"+strdebug);
    #else
        return COMMA;
    #endif
}
";" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("SEMICOLON\t;"+strdebug);
    #else
        return SEMICOLON;
    #endif
}
"(" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("LPAREN\t("+strdebug);
    #else
        return LPAREN;
    #endif
}
")" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("RPAREN\t)"+strdebug);
    #else
    return RPAREN;
    #endif
}
"{" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("LBRACE\t{"+strdebug);
        lbraces++;
    #else
        return LBRACE;
    #endif
}
"}" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("RBRACE\t}"+strdebug);
        rbraces++;
    #else
        return RBRACE;
    #endif
}
"[" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("LBRACKET\t["+strdebug);
    #else
        return LBRACE;
    #endif
}
"]" {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        DEBUG_FOR_LAB4("RBRACKET\t]"+strdebug);
    #else
        return RBRACE;
    #endif
}

{DECIMIAL} {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        std::string dec = yytext;
        DEBUG_FOR_LAB4("DECIMIAL\t" + dec + strdebug);
    #else
        return DEC;
    #endif
}
{FLOATDECIMIAL} {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);
        std::string fdec = yytext;
        DEBUG_FOR_LAB4("FLOATDECIMIAL\t"+fdec+strdebug);
    #else
        return FLOATDEC;
    #endif
}
{OCTAL} {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);

        char oct[20];
        char text[20];
        unsigned int a;
        strncpy(oct,yytext,strlen(yytext)+1);
        sscanf(oct,"%o",&a);
        sprintf(text,"%d",a);
        std::string stroct = text;
        DEBUG_FOR_LAB4("OCTAL\t"+stroct+strdebug);
    #else
        return FLOATDEC;
    #endif
}
{HEXADECIMAL} {
    #ifdef ONLY_FOR_LEX
        char lineno[20];
        sprintf(lineno,"%d",yylineno);
        std::string strdebug = "\tline:";
        strdebug.append(lineno);

        char hex[20];
        char text[20];
        unsigned int a;
        strncpy(hex,yytext,strlen(yytext)+1);
        sscanf(hex,"%x",&a);
        sprintf(text,"%d",a);
        std::string strhex = text;
        DEBUG_FOR_LAB4("HEXADECIMAL\t"+strhex+strdebug);
    #else
        return FLOATDEC;
    #endif
}
{ID} {
    #ifdef ONLY_FOR_LEX
        std::string text = yytext;
        char lineno[20];
        char scope[20];
        sprintf(lineno,"%d",yylineno);
        sprintf(scope,"%d",lbraces-rbraces);
        std::string strtex = text;
        strtex = strtex +"\tline:"+ lineno;
        if (lbraces-rbraces == 0){
            strtex = strtex +"\tGLOBAL";
        }
        else{
            strtex = strtex +"\tLOCAL"+ scope;  
        }
        DEBUG_FOR_LAB4("ID\t"+ strtex);
    #else
        return ID;
    #endif
}
{EOL} yylineno++;
{WHITE}

%%

#ifdef ONLY_FOR_LEX
int main(int argc, char **argv){
    if(argc != 5){
        fprintf(stderr, "Argument Not Enough");
        exit(EXIT_FAILURE);
    }

    if(!(yyin = fopen(argv[1], "r"))){
        fprintf(stderr, "No such file or directory: %s", argv[1]);
        exit(EXIT_FAILURE);
    }

    if(!(yyout = fopen(argv[3], "w"))){
        fprintf(stderr, "No such file or directory: %s", argv[3]);
        exit(EXIT_FAILURE);
    }

    yylex();
    return 0;
}
#endif