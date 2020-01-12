%{
    #include <iostream>
    #include <string.h>
    #include "syntax-analyzer.tab.h"

    void yyerror(char const *msg);
%}

%%
[ \t\n] 						                        ;
(,|;|\(|\)|\[|\]|\{|\}|=)                               {
                                                            return yytext[0];
                                                        }
(<<)                                                    {
                                                            return OUT;
                                                        }
(>>)                                                    {
                                                            return IN;
                                                        }
(\+\+)                                                  {
                                                            return INCREMENT;
                                                        }
(main)                                                  { 
                                                            return MAIN;
                                                        }
(int)                                                   { 
                                                            return INT;
                                                        }
(float)                                                 { 
                                                            return FLOAT;
                                                        }
(if)                                                    { 
                                                            return IF;
                                                        }
(while)                                                 { 
                                                            return WHILE;
                                                        }
(for)                                                   { 
                                                            return FOR;
                                                        }
(return)                                                { 
                                                            return RETURN_STATEMENT;
                                                        }
(endl)                                                  { 
                                                            return NEW_LINE;
                                                        }
(cin)                                                   { 
                                                            return CIN;
                                                        }
(cout)                                                  { 
                                                            return COUT;
                                                        }
([a-zA-Z]+)                                             {
                                                            if(strlen(yytext) <= 8){
                                                                return IDENTIFIER;
                                                            }
                                                            else {
                                                                char msg[100] = "Identificatorii trebuie sa aiba maxim 8 caractere. Identificatorul gresit: ";
                                                                yyerror(strcat(msg, yytext)); 
                                                            }  
                                                        }
(([1-9][0-9]*|0)(\.[0-9]*){1,1})                        { 
                                                            return FLOAT_CONSTANT; 
                                                        }
([1-9][0-9]*|0)				                            { 
                                                            return INT_CONSTANT;
                                                        }
(\"[a-zA-Z=: ]*\")				                        { 
                                                            return STRING_CONSTANT; 
                                                        }
(\+|%|\*)			                                    { 
                                                            return ARITHMETIC_OPERATOR;
                                                        }
(<|>|==|!=|<=|>=)                                       {
                                                            return BOOLEAN_OPERATOR;
                                                        }
.                                                       { 
                                                            char msg[20] = "Caracter gresit: ";
                                                            yyerror(strcat(msg, yytext));
                                                        }
%%

