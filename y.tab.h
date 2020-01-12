/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    BEGIN_PROGRAM = 258,
    END_PROGRAM = 259,
    BEGIN_BLOCK = 260,
    END_BLOCK = 261,
    INT = 262,
    REAL = 263,
    ARRAY_INT = 264,
    ARRAY_REAL = 265,
    READ = 266,
    WRITE = 267,
    IF = 268,
    ELSE = 269,
    WHILE = 270,
    NE = 271,
    GT = 272,
    LT = 273,
    EQ = 274,
    GE = 275,
    LE = 276,
    ASSUME = 277,
    PLUS = 278,
    MINUS = 279,
    MULTIPLY = 280,
    DIVIDE = 281,
    AND = 282,
    SEMICOLON = 283,
    COMMA = 284,
    LEFT_BRACKET = 285,
    RIGHT_BRACKET = 286,
    SQUARE_LEFT_BRACKET = 287,
    SQUARE_RIGHT_BRACKET = 288,
    MAIN = 289,
    LEFT_ACOL = 290,
    RIGHT_ACOL = 291,
    RETURN = 292,
    ID = 293,
    CONST = 294
  };
#endif
/* Tokens.  */
#define BEGIN_PROGRAM 258
#define END_PROGRAM 259
#define BEGIN_BLOCK 260
#define END_BLOCK 261
#define INT 262
#define REAL 263
#define ARRAY_INT 264
#define ARRAY_REAL 265
#define READ 266
#define WRITE 267
#define IF 268
#define ELSE 269
#define WHILE 270
#define NE 271
#define GT 272
#define LT 273
#define EQ 274
#define GE 275
#define LE 276
#define ASSUME 277
#define PLUS 278
#define MINUS 279
#define MULTIPLY 280
#define DIVIDE 281
#define AND 282
#define SEMICOLON 283
#define COMMA 284
#define LEFT_BRACKET 285
#define RIGHT_BRACKET 286
#define SQUARE_LEFT_BRACKET 287
#define SQUARE_RIGHT_BRACKET 288
#define MAIN 289
#define LEFT_ACOL 290
#define RIGHT_ACOL 291
#define RETURN 292
#define ID 293
#define CONST 294

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 46 "bison.y" /* yacc.c:1909  */

	char varname[10];
	attributes attrib;

#line 137 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
