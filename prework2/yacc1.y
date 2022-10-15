%{
/****************************************************
expr1.y
YACC file
Date: xxxx/xx/xx
xxxxx <xxxxx@nbjl.nankai.edu.cn>
********************************************************/
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token ADD SUB MUL DIV
%token LB RB
%token NUMBER


%left ADD SUB
%left MUL DIV
%right UMINUS

%%


lines   :   lines expr ';' { printf("%f\n", $2); }
        |   lines ';'
        |
        ;

expr    :   expr ADD expr   { $$ = $1 + $3; }
        |   expr SUB expr   { $$ = $1 - $3; }
        |   expr MUL expr   { $$ = $1 * $3; }
        |   expr DIV expr   { $$ = $1 / $3; }
        |   LB expr RB   { $$ = $2; }
        |   SUB expr %prec UMINUS   { $$ = -$2; }
        |   NUMBER {$$ = $1;}
        ;


/* NUMBER  :       ZERO                 { $$ = 0.0; }
        |       ONE                 { $$ = 1.0; }
        |       TWO                 { $$ = 2.0; }
        |       THREE                 { $$ = 3.0; }
        |       FOUR                 { $$ = 4.0; }
        |       FIVE                 { $$ = 5.0; }
        |       SIX                 { $$ = 6.0; }
        |       SEVEN                { $$ = 7.0; }
        |       EIGHT                 { $$ = 8.0; }
        |       NINE                { $$ = 9.0; }
        ; */

%%

// programs section

int yylex()
{

    // place your token retrieving code here
    int t;
    while (1){
        t = getchar();
        if (t == ' ' || t == '\t' || t == '\n'){
            //do nothing
        }else if (isdigit(t)){
            yylval = 0;
            while(isdigit(t)){
                yylval = yylval * 10 + t - '0';
                t = getchar();
            }
            ungetc(t,stdin);
            return NUMBER;
        }else if(t == '+'){
            return ADD;
        }else if(t == '-'){
            return SUB;
        }else if (t == '*'){
            return MUL;
        }else if (t == '/'){
            return DIV;
        }else if (t == '('){
            return LB;
        }else if (t == ')'){
            return RB;
        }else{
            return t;
        }
    }
    return getchar();
}

int main(void)
{
    yyin = stdin;
    do {
        yyparse();
    } while (! feof (yyin));
    return 0;
}
void yyerror(const char* s) {
    fprintf (stderr , "Parse error : %s\n", s );
    exit (1);
}