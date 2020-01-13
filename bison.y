%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int CURRENT_LINE 	= 1;
int TEMPORARY_INDEX = 0;

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern char *yytext;

void yyerror(char *s);


char data_section_buffer[1000];

char code_section_buffer[1000];

void write_line_to_data_section(char *s);

void write_line_to_code_section(char *s);

void write_assembly_to_file(char *file);


void declare_temporary_variable(char *s);

%}

%union 
{
	char var_name[10];
}

%token MAIN


%token LEFT_BRACKET
%token RIGHT_BRACKET
%token LEFT_BRACE
%token RIGHT_BRACE
%token RETURN
%token SEMICOLON

%token INT

%token ASSIGN
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE

%token READ
%token WRITE


%token <var_name> ID
%token <var_name> CONST

%type <var_name> expression
%type <var_name> term


%%
	
program: 	program_start LEFT_BRACE declarations  instructions  program_end RIGHT_BRACE
			;

program_start:	MAIN LEFT_BRACKET RIGHT_BRACKET 
				;
			
program_end: 	RETURN CONST SEMICOLON
				;

declarations: 	declaration
				| declaration declarations 
				;


declaration: 	type ID SEMICOLON
					{
						char *tmp = (char *)malloc(sizeof(char)*100);
						sprintf(tmp, "%s: times 4 db 0\n", $2);
						write_line_to_data_section(tmp);
						free(tmp);
					}
				;

type: 	INT
		;
	
instructions:	instruction 
				| instruction instructions 
				;
				
instruction:	assign_instruction
				| io_instruction
				;

assign_instruction: ID ASSIGN CONST SEMICOLON 
						{
							char *tmp = (char *)malloc(sizeof(char)*100);
							
							sprintf(tmp, "mov eax, %s\n", $3);
							write_line_to_code_section(tmp);
							sprintf(tmp, "mov [%s], eax\n", $1);
							write_line_to_code_section(tmp);
							free(tmp);
						}
					| ID ASSIGN expression SEMICOLON		
						{
							char *tmp = (char *)malloc(sizeof(char)*100);
							
							sprintf(tmp, "mov eax, [%s]\n", $3);
							write_line_to_code_section(tmp);
							sprintf(tmp, "mov [%s], eax\n", $1);
							write_line_to_code_section(tmp);
							free(tmp);
						}
					;

expression: term
			| ID PLUS ID
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);

					sprintf(tmp, "mov ebx, dword [%s]\n", $1);
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					write_line_to_code_section(tmp);

					sprintf(tmp, "add ebx, ecx\n");
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov [%s], ebx\n", temp);
					write_line_to_code_section(tmp);
				}
			| ID PLUS CONST
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);

					sprintf(tmp, "mov ebx, dword [%s]\n", $1);
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov ecx, %s\n", $3);
					write_line_to_code_section(tmp);

					sprintf(tmp, "add ebx, ecx\n");
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov [%s], ebx\n", temp);
					write_line_to_code_section(tmp);
				}
			| CONST PLUS ID
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);

					sprintf(tmp, "mov ebx, %s\n", $1);
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					write_line_to_code_section(tmp);

					sprintf(tmp, "add ebx, ecx\n");
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mov [%s], ebx\n", temp);
					write_line_to_code_section(tmp);
				}
			| CONST PLUS CONST
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);

					sprintf(tmp, "mov ebx, %s\n", $1);
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov ecx, %s\n", $3);
					write_line_to_code_section(tmp);

					sprintf(tmp, "add ebx, ecx\n");
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mov [%s], ebx\n", temp);
					write_line_to_code_section(tmp);
				}
			| ID MINUS ID
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);

					sprintf(tmp, "mov ebx, dword [%s]\n", $1);
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					write_line_to_code_section(tmp);

					sprintf(tmp, "sub ebx, ecx\n");
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov [%s], ebx\n", temp);
					write_line_to_code_section(tmp);
				}
			| ID MINUS CONST
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);

					sprintf(tmp, "mov ebx, dword [%s]\n", $1);
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov ecx, %s\n", $3);
					write_line_to_code_section(tmp);

					sprintf(tmp, "sub ebx, ecx\n");
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov [%s], ebx\n", temp);
					write_line_to_code_section(tmp);
				}
			| CONST MINUS ID
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);

					sprintf(tmp, "mov ebx, %s\n", $1);
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					write_line_to_code_section(tmp);

					sprintf(tmp, "sub ebx, ecx\n");
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mov [%s], ebx\n", temp);
					write_line_to_code_section(tmp);
				}
			| CONST MINUS CONST
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);

					sprintf(tmp, "mov ebx, %s\n", $1);
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov ecx, %s\n", $3);
					write_line_to_code_section(tmp);

					sprintf(tmp, "sub ebx, ecx\n");
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mov [%s], ebx\n", temp);
					write_line_to_code_section(tmp);
				}
			| ID MULTIPLY ID
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov edx, 0\n");
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov eax, dword [%s]\n", $1);
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					write_line_to_code_section(tmp);

					sprintf(tmp, "mul ecx\n");
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov [%s], eax\n", temp);
					write_line_to_code_section(tmp);
				}
			| ID MULTIPLY CONST
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);
					
					sprintf(tmp, "mov edx, 0\n");
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov eax, dword [%s]\n", $1);
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mov ecx, %s\n", $3);
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mul ecx\n");
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mov [%s], eax\n", temp);
					write_line_to_code_section(tmp);
				}
			| CONST MULTIPLY ID
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);
					
					sprintf(tmp, "mov edx, 0\n");
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov eax, %s\n", $1);
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mul ecx\n");
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mov [%s], eax\n", temp);
					write_line_to_code_section(tmp);
				}
			| CONST MULTIPLY CONST
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
					
					
					char *tmp = (char *)malloc(sizeof(char)*100);
					
					sprintf(tmp, "mov edx, 0\n");
					write_line_to_code_section(tmp);

					sprintf(tmp, "mov eax, %s\n", $1);
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mov ecx, %s\n", $3);
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mul ecx\n");
					write_line_to_code_section(tmp);
					
					sprintf(tmp, "mov [%s], eax\n", temp);
					write_line_to_code_section(tmp);
				}
			| ID DIVIDE ID
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
							
					
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov edx, 0\n");
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov eax, dword [%s]\n", $1);
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					write_line_to_code_section(tmp);
					sprintf(tmp, "div ecx\n");
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov [%s], eax\n", temp);
					write_line_to_code_section(tmp);
				}
			| ID DIVIDE CONST
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
							
					
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov edx, 0\n");
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov eax, dword [%s]\n", $1);
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov ecx, %s\n", $3);
					write_line_to_code_section(tmp);
					sprintf(tmp, "div ecx\n");
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov [%s], eax\n", temp);
					write_line_to_code_section(tmp);
				}
			| CONST DIVIDE ID
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
							
					
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov edx, 0\n");
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov eax, %s\n", $1);
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					write_line_to_code_section(tmp);
					sprintf(tmp, "div ecx\n");
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov [%s], eax\n", temp);
					write_line_to_code_section(tmp);
				}
			| CONST DIVIDE CONST
				{
					
					char *temp = (char *)malloc(sizeof(char)*100);
					declare_temporary_variable(temp);
					strcpy($$, temp); 
							
					
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov edx, 0\n");
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov eax, %s\n", $1);
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov ecx, %s\n", $3);
					write_line_to_code_section(tmp);
					sprintf(tmp, "div ecx\n");
					write_line_to_code_section(tmp);
					sprintf(tmp, "mov [%s], eax\n", temp);
					write_line_to_code_section(tmp);
				}
				;
			  
io_instruction: WRITE LEFT_BRACKET ID RIGHT_BRACKET SEMICOLON
				{
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "push dword [%s]\npush formatout\ncall printf\nadd esp, 8\n", $3);
					write_line_to_code_section(tmp);
				}	
				| READ LEFT_BRACKET ID RIGHT_BRACKET SEMICOLON	
				{
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "push %s\npush formatin\ncall scanf\nadd esp, 8\n", $3);
					write_line_to_code_section(tmp);
				}
				;

 
term: ID		
		| CONST	
		;
			
%%

int main(int argc, char *argv[]) 
{	
	memset(data_section_buffer, 0, 1000);
	memset(code_section_buffer, 0, 1000);

	FILE *f = fopen(argv[1], "r");

	if(!f) 
	{
		perror("Could not open file!");
		exit(1);
	}

	yyin = f;
	
	while(!feof(yyin)) { yyparse(); }

	char *file = strtok(argv[1], ".");
	strcat(file, ".asm");

	write_assembly_to_file(file);
	
	return 0;
}


void write_line_to_data_section(char *s) 
{
	strcat(data_section_buffer, s);		
}


void write_line_to_code_section(char *s) 
{
	strcat(code_section_buffer, s);
}

void write_assembly_to_file(char *file) 
{
	char* data_section_boilerplate = (char*) malloc(sizeof(char)*100);
	char* code_section_boilerplate = (char*) malloc(sizeof(char)*100);
	char* code_section_end = (char*) malloc(sizeof(char)*100);


	sprintf(data_section_boilerplate, "section .data\nformatin: db \"%%d\", 0\nformatout: db \"%%d\", 10, 0\n");
	sprintf(code_section_boilerplate, "\nsection .text\nglobal main\nextern scanf\nextern printf\nmain:\n");
	sprintf(code_section_end, "\nmov eax, 0\nret\n");

	FILE *f = fopen(file, "w");
	if(f == NULL) 
	{
		perror("Failed to open asm file.");
		exit(1);
	}
	fwrite(data_section_boilerplate, strlen(data_section_boilerplate), 1, f);
	fwrite(data_section_buffer, strlen(data_section_buffer), 1, f);
	fwrite(code_section_boilerplate, strlen(code_section_boilerplate), 1, f);
	fwrite(code_section_buffer, strlen(code_section_buffer), 1, f);
	fwrite(code_section_end, strlen(code_section_end), 1, f);

	fclose(f);
	free(data_section_boilerplate);
	free(code_section_boilerplate);
	free(code_section_end);
}


void declare_temporary_variable(char *s) 
{
	sprintf(s, "_temp%d: times 4 db 0\n", TEMPORARY_INDEX);
	write_line_to_data_section(s);
	sprintf(s, "_temp%d", TEMPORARY_INDEX);
	TEMPORARY_INDEX++;
}


void yyerror(char *err) 
{
	printf( "Unexpected token \"%s\" on line #%d: %s \n", yytext, CURRENT_LINE, err);
	exit(1);
}
