%{
/****************************************************
expr2.y
YACC file
Date: xxxx/xx/xx
xxxxx <xxxxx@nbjl.nankai.edu.cn>
********************************************************/
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
char idStr [50];
char numStr[50];
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token ADD SUB MUL DIV
%token LB RB
%token NUMBER
%token ID


%left ADD SUB
%left MUL DIV
%right UMINUS

%%


lines   :   lines expr ';' { printf("%s\n", $2); }
        |   lines ';'
        |
        ;

expr    :   expr ADD expr   { $$ = (char *)malloc(50*sizeof (char)); strcpy($$,$1); strcat($$,$3); strcat($$,"+ "); }
        |   expr SUB expr   { $$ = (char *)malloc(50*sizeof (char)); strcpy($$,$1); strcat($$,$3); strcat($$,"- "); }
        |   expr MUL expr   { $$ = (char *)malloc(50*sizeof (char)); strcpy($$,$1); strcat($$,$3); strcat($$,"* "); }
        |   expr DIV expr   { $$ = (char *)malloc(50*sizeof (char)); strcpy($$,$1); strcat($$,$3); strcat($$,"/ "); }
        |   LB expr RB      { $$ = (char *)malloc(50*sizeof (char)); strcpy($$,$2); }
        |   SUB expr %prec UMINUS   { $$ = (char *)malloc(50*sizeof (char)); strcpy($$,$2); strcat($$,"- "); }
        |   NUMBER          {$$ = (char *)malloc(50*sizeof (char)); strcpy($$,$1); strcat($$," ");}
        |   ID              {$$ = (char *)malloc(50*sizeof (char)); strcpy($$,$1); strcat($$," ");}
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
        }else if ((t >= '0' && t <= '9')){
            int ti = 0;
            while((t >= '0' && t <= '9')){
                numStr[ti] = t;
                t = getchar();
                ti++;
            }
            numStr[ti] = '\0';
            yylval = numStr;
            ungetc(t,stdin);
            return NUMBER;
        }else if(( t >= 'a' && t <= 'z' )||( t >= 'A' && t<= 'Z' )||( t == '_' )){
            int ti = 0;
            while((t >= 'a' && t <= 'z' )||( t >= 'A' && t<= 'Z')||( t == '_' )||(t >= '0' && t <= '9')){
                idStr[ti] = t;
                ti++;
                t = getchar();
            }
            idStr[ti] = '\0';
            yylval = idStr;
            ungetc(t, stdin);
            return ID;
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