%{
	#include <stdio.h>                                                          
	#include <malloc.h>   
	#include <string.h>

	int add_from_file(char* file_name, int size, char** non_symbols)
	{
		FILE* file = fopen(file_name, "r");
		char line[256];

		while (fgets(line, 256, file)) 
		{   
			strtok(line, "\n");
			 
        	int line_len = strlen(line) + 1;
			
			non_symbols[size++] = strncpy( malloc( line_len ), line, line_len ); 
		}
		
		fclose(file);

		return size;
	}
	

	struct atom{
		char* value;
		int type;
	};

	int identifier_code = 1;
	int constant_code = 2;
	int non_symbol_code_base = 3;

	int line = 1; 
	int pos = 1;
	int atoms_size = 0;
	struct atom atoms[2000];
%} 

SEPARATOR		"["|"]"|"("|")"|"{"|"}"|","|";"|":"|"#"
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
					char* line;
					line = strncpy( malloc( yyleng + 1 ), yytext, yyleng +1 );
					struct atom at = {line, 0};
					atoms[atoms_size++] = at;

					// printf("Separator:\t\t%s\n", yytext);
				}
{KEYWORD}		{
					pos += yyleng;
					char* line;
					line = strncpy( malloc( yyleng + 1 ), yytext, yyleng +1 );
					struct atom at = {line, 1};
					atoms[atoms_size++] = at;
					// printf("Keyword:\t\t%s\n", yytext);
				}
{IDENTIFIER}	{
					pos += yyleng;
					char* line;
					line = strncpy( malloc( yyleng + 1 ), yytext, yyleng +1 );
					struct atom at = {line, 2};
					atoms[atoms_size++] = at;
					// printf("Identifier:\t\t%s\n", yytext);
				}
{CONSTANT}		{
					pos += yyleng;
					char* line;
					line = strncpy( malloc( yyleng + 1 ), yytext, yyleng +1 );
					struct atom at = {line, 3};
					atoms[atoms_size++] = at;
					// printf("Constant:\t\t%s\n", yytext);
				}
{OPERATOR}		{
					pos += yyleng;
					char* line;
					line = strncpy( malloc( yyleng + 1 ), yytext, yyleng +1 );
					struct atom at = {line, 4};
					atoms[atoms_size++] = at;
					// printf("Operator:\t\t%s\n", yytext);
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


	char* non_symbols[1000];
	int non_symbol_size = 0;
	non_symbol_size = add_from_file("resources/specification/keywords.txt", non_symbol_size, non_symbols);
	non_symbol_size = add_from_file("resources/specification/operators.txt", non_symbol_size, non_symbols);
	non_symbol_size = add_from_file("resources/specification/separators.txt", non_symbol_size, non_symbols);


	// PRINT PROGRAM INTERNAL FORM
	for(int i = 0; i < atoms_size; i++)
	{
		int code = non_symbol_code_base;

		for(int j = 0; j < non_symbol_size; j++)
			if(strcmp(atoms[i].value, non_symbols[j]) == 0)
				code += j;

		switch(atoms[i].type)
		{
			case 0: // SEPARATOR
				printf("code: %d \t index: -1 \t type:  SEPARATOR \t value: %s \n", code, atoms[i].value);
				break;
			case 1: // KEYWORD
				printf("code: %d \t index: -1 \t type:    KEYWORD \t value: %s \n", code, atoms[i].value);
				break;
			case 2: // IDENTIFIER
				break;
			case 3: // CONSTANT
				break;
			case 4: // OPERATOR
				printf("code: %d \t index: -1 \t type:   OPERATOR \t value: %s \n", code, atoms[i].value);
				break;
		}
	}
	return 0; 
}