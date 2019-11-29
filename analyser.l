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

	int return_code = 0;

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
					return_code = -1;
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

	if(return_code != 0)
		return return_code;

	char* non_symbols[1000];
	int non_symbol_size = 0;
	non_symbol_size = add_from_file("resources/specification/keywords.txt", non_symbol_size, non_symbols);
	non_symbol_size = add_from_file("resources/specification/operators.txt", non_symbol_size, non_symbols);
	non_symbol_size = add_from_file("resources/specification/separators.txt", non_symbol_size, non_symbols);


	// STORE IDENTIFIERS AND CONSTANTS

	char* symbols[1000];
	int symbols_size = 0;

	for(int i = 0; i < atoms_size; i++)
		if(atoms[i].type == 2 || atoms[i].type == 3)
		{
			int found = 0;
			for(int j = 0; j < symbols_size; j++)
				if(strcmp(atoms[i].value, symbols[j]) == 0)
					found = 1;
			if (found == 0)
				symbols[symbols_size++] = atoms[i].value;
		}

	printf("PROGRAM INTERNAL FORM: \n");
	for(int i = 0; i < atoms_size; i++)
	{
		int code;
		int index = -1;
		if(atoms[i].type == 2 || atoms[i].type == 3)
		{
			code = atoms[i].type - 1;

			for(int j = 0; j < symbols_size; j++)
				if(strcmp(atoms[i].value, symbols[j]) == 0)
					index = j;
		}
		else
		{
			code = non_symbol_code_base;
			for(int j = 0; j < non_symbol_size; j++)
				if(strcmp(atoms[i].value, non_symbols[j]) == 0)
					code += j;
		}
		switch(atoms[i].type)
		{
			case 0: // SEPARATOR
				printf("code: %d \t index: %d \t type:  SEPARATOR \t value: %s \n", code, index, atoms[i].value);
				break;
			case 1: // KEYWORD
				printf("code: %d \t index: %d \t type:    KEYWORD \t value: %s \n", code, index, atoms[i].value);
				break;
			case 2: // IDENTIFIER
				printf("code: %d \t index: %d \t type: IDENTIFIER \t value: %s \n", code, index, atoms[i].value);
				break;
			case 3: // CONSTANT
				printf("code: %d \t index: %d \t type:   CONSTANT \t value: %s \n", code, index, atoms[i].value);
				break;
			case 4: // OPERATOR
				printf("code: %d \t index: %d \t type:   OPERATOR \t value: %s \n", code, index, atoms[i].value);
				break;
		}
	}

	printf("SYMBOLS TABLE: \n");
	for(int i = 0; i < symbols_size; i++)
		printf("index: %d \t value: %s\n", i, symbols[i]);

	return 0; 
}