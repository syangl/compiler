/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_INCLUDE_PARSER_H_INCLUDED
# define YY_YY_INCLUDE_PARSER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 15 "src/parser.y"

    #include "Ast.h"
    #include "SymbolTable.h"
    #include "Type.h"

#line 54 "include/parser.h"

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ID = 258,
    INTEGER = 259,
    FLOATDECIMAL = 260,
    IF = 261,
    ELSE = 262,
    WHILE = 263,
    INT = 264,
    VOID = 265,
    FLOAT = 266,
    LPAREN = 267,
    RPAREN = 268,
    LBRACE = 269,
    RBRACE = 270,
    LBRACKET = 271,
    RBRACKET = 272,
    SEMICOLON = 273,
    COMMA = 274,
    SPOT = 275,
    ADD = 276,
    SUB = 277,
    MUL = 278,
    DIV = 279,
    MOD = 280,
    OR = 281,
    AND = 282,
    LESS = 283,
    LEQU = 284,
    EQUAL = 285,
    NOTEQUAL = 286,
    GREAT = 287,
    GEQU = 288,
    NOT = 289,
    ASSIGN = 290,
    RETURN = 291,
    CONTINUE = 292,
    BREAK = 293,
    CONST = 294,
    THEN = 295
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 21 "src/parser.y"

    int itype;
    char* strtype;
    StmtNode* stmttype;
    ExprNode* exprtype;
    SymbolEntry* se;
    Type* type;

#line 115 "include/parser.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_INCLUDE_PARSER_H_INCLUDED  */
