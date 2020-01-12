/*
 * Lexical analizer for the chosen language.
 * Matches each word to a regex.
 */

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "attrib.h"
#include "y.tab.h"

extern int lineno;  /* defined in bison */



%}

%option noyywrap

%%

begin_program	{  return BEGIN_PROGRAM; }
end_program		{  return END_PROGRAM; }
begin_block		{  return BEGIN_BLOCK; }
end_block			{  return END_BLOCK; }
int					{  return  INT; }
main					{  return  MAIN; }
real					{  return REAL; }
array_int			{  return ARRAY_INT; }
array_real			{  return ARRAY_REAL; }
"="					{  return ASSUME; }
"("					{  return LEFT_BRACKET; }
")"					{  return RIGHT_BRACKET; }
"{"					{ return LEFT_ACOL; }
"}"					{ return RIGHT_ACOL; }
"return"					{  return RETURN; }

"+"					{  return PLUS; }
"-"					{  return MINUS; }
"*"					{  return  MULTIPLY; }
"/"					{  return DIVIDE; }
read					{  return READ; }
write					{  return WRITE; }
if						{  return IF; }
else					{  return ELSE; }
"!="					{  return NE; }
">"					{  return GT; }
"<"					{  return LT; }
"=="					{  return EQ; }
">="					{  return GE;}
"<="					{  return LE;}
while					{  return WHILE; }
"&"					{  return AND; }
"["					{  return SQUARE_LEFT_BRACKET; }
"]"					{  return SQUARE_RIGHT_BRACKET; }
";"					{ return SEMICOLON; }
","					{  return COMMA; }

[ \t\r]*				{/*Do nothing for whitespaces*/}
[\n]            		{ lineno++; }

([a-zA-Z]+[0-9]*)					{  strcpy(yylval.varname,yytext); return ID;}
([0-9]|[1-9][0-9]+)			 {  strcpy(yylval.varname,yytext); return CONST;}




%	
