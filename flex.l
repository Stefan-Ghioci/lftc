%{
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"

extern int CURRENT_LINE;

%}

%option noyywrap

%%

main			        		{ return MAIN; }


"("				            	{ return LEFT_BRACKET; }
")"				            	{ return RIGHT_BRACKET; }
"{"				            	{ return LEFT_ACOL; }
"}"				        	    { return RIGHT_ACOL; }
"return"		    			{ return RETURN; }
";"					            { return SEMICOLON; }


int				              	{ return INT; }


"="				            	{ return ASSIGN; }
"+"				            	{ return PLUS; }
"-"				            	{ return MINUS; }
"*"				            	{ return MULTIPLY; }
"/"				            	{ return DIVIDE; }
"%"                             { return MODULO; }

read				        	{ return READ; }
write				        	{ return WRITE; }


[ \t\r]*				        { /* IGNORE */ }
[\n]            		        { CURRENT_LINE++; }

([a-zA-Z]+[0-9]*)			    { 
                                    strcpy(yylval.varname, yytext); 
                                    return ID;
                                }
([0-9]|[1-9][0-9]+)			    { 
                                    strcpy(yylval.varname, yytext); 
                                    return CONST; 
                                }


%%
