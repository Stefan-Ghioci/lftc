%{ 
	int line = 1; 
	int pos = 1;
%} 

SEPARATOR		"["|"]"|"("|")"|"{"|"}"|","|";"|":"|"*"|"#"
KEYWORD			"if"|"else"|"function"|"int32"|"return"|"print"|"main"|"for"|"read"|"single"|"double"
IDENTIFIER		[_]*[_\-a-zA-Z][_\-a-zA-Z0-9]*
NUMERIC			[+-]?([1-9][0-9]*|0)(\.[0-9]*)?
STRING			\"[^\n"]+\"
CONSTANT		{NUMERIC}|{STRING}
OPERATOR 		"+"|"-"|"*"|"/"|"%"|"++"|"--"|"="|"+="|"-="|"*="|"/="|"%="|"&="|"|="|"^="|">>="|"<<="|"=="|"!="|">"|"<"|">="|"<="|"&&"|"|"|"~"|"&"|"|"|"^"|"<<"|">>"
WHITESPACE	 	[ \t]+

%% 
\n				{ 
					line++;
					pos = 1;
				}
{SEPARATOR}		{
					pos += yyleng;
					printf("Separator:\t\t%s\n", yytext);
				}
{KEYWORD}		{
					pos += yyleng;
					printf("Keyword:\t\t%s\n", yytext);
				}
{IDENTIFIER}	{
					pos += yyleng;
					printf("Identifier:\t\t%s\n", yytext);
				}
{CONSTANT}		{
					pos += yyleng;
					printf("Constant:\t\t%s\n", yytext);
				}
{OPERATOR}		{
					pos += yyleng;
					printf("Operator:\t\t%s\n", yytext);
				}
{WHITESPACE}	{	pos++;	}
.				{
					printf("Error - unrecognized character \"%s\" on line %d, position %d.", yytext, line, pos);
					yyterminate();
				}
%% 

int yywrap(){} 
int main()
{ 
	FILE *fp; 
	char filename[50]; 
	printf("Enter the filename: \n"); 
	scanf("%s", filename); 
	fp = fopen(filename, "r"); 
	yyin = fp; 
	yylex(); 

	return 0; 
}