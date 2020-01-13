%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int  CURRENT_LINE = 1;

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern char *yytext;

void yyerror(char *s);

//the variable containing the DataSegment for the assembly program
char DS[1000];

//the variable containing the CodeSegment for the assembly program
char CS[1000];

//add variables to DataSegment
void addTempToDS(char *s);

//add assembly code to CodeSegment
void addTempToCS(char *s);

//write the assembly code to file
void writeAssemblyToFile(char *file);

//counter for the temp variables
int tempnr = 1;
//create a new temp variable and add it to DS
void newTempName(char *s);

%}

%union 
{
	char varname[10];
}

%token MAIN


%token LEFT_BRACKET
%token RIGHT_BRACKET
%token LEFT_ACOL
%token RIGHT_ACOL
%token RETURN
%token SEMICOLON

%token INT

%token ASSIGN
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token MODULO

%token READ
%token WRITE


%token <varname> ID
%token <varname> CONST

%type <varname> expresie
%type <varname> termen


%%
	
program: begin_prog LEFT_ACOL lista_declaratii  lista_instr  end_prog RIGHT_ACOL
			;

begin_prog:	MAIN LEFT_BRACKET RIGHT_BRACKET 
				;
			
end_prog: RETURN CONST SEMICOLON
			;

lista_declaratii: decl 
	| decl lista_declaratii 
	;


decl: tip ID SEMICOLON
		{
			char *tmp = (char *)malloc(sizeof(char)*100);
			sprintf(tmp, "%s: times 4 db 0\n", $2);
			addTempToDS(tmp);
			free(tmp);
		}
	;

tip: INT
	;
	
lista_instr: instr 
		| instr lista_instr 
		;
				
instr: instr_atribuire
	| instr_io
	;

instr_atribuire: ID ASSIGN expresie SEMICOLON		
						{
							char *tmp = (char *)malloc(sizeof(char)*100);
							//expression result is in temp, so we move it into ID
							sprintf(tmp, "mov eax, [%s]\n", $3);
							addTempToCS(tmp);
							sprintf(tmp, "mov [%s], eax\n", $1);
							addTempToCS(tmp);
							free(tmp);
						}
					;

expresie: termen
			| termen PLUS termen
				{
					//make new temp
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
					strcpy($$, temp); 
					
					//add code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov ebx, dword [%s]\n", $1);
					addTempToCS(tmp);
					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					addTempToCS(tmp);
					sprintf(tmp, "add ebx, ecx\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov [%s], ebx\n", temp);
					addTempToCS(tmp);
				}
			| termen MINUS termen
				{
					//make new temp
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
					strcpy($$, temp); 
								
					//sub code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov ebx, dword [%s]\n", $1);
					addTempToCS(tmp);
					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					addTempToCS(tmp);
					sprintf(tmp, "sub ebx, ecx\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov [%s], ebx\n", temp);
					addTempToCS(tmp);
				}
			| termen MULTIPLY ID
				{
					//make new temp
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
					strcpy($$, temp); 
					
					//multiply code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov edx, 0\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov eax, dword [%s]\n", $1);
					addTempToCS(tmp);
					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					addTempToCS(tmp);
					sprintf(tmp, "mul ecx\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov [%s], eax\n", temp);
					addTempToCS(tmp);
				}
			| termen MULTIPLY CONST
				{
					//make new temp
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
					strcpy($$, temp); 
					
					//multiply code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov edx, 0\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov eax, dword [%s]\n", $1);
					addTempToCS(tmp);
					sprintf(tmp, "mov ecx, %s\n", $3);
					addTempToCS(tmp);
					sprintf(tmp, "mul ecx\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov [%s], eax\n", temp);
					addTempToCS(tmp);
				}
			| termen DIVIDE ID
				{
					//make new temp
					char *temp = (char *)malloc(sizeof(char)*100);
					newTempName(temp);
					strcpy($$, temp); 
							
					//divide code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov edx, 0\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov eax, dword [%s]\n", $1);
					addTempToCS(tmp);
					sprintf(tmp, "mov ecx, dword [%s]\n", $3);
					addTempToCS(tmp);
					sprintf(tmp, "div ecx\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov [%s], eax\n", temp);
					addTempToCS(tmp);
				}
			| termen DIVIDE CONST
			{
				//make new temp
				char *temp = (char *)malloc(sizeof(char)*100);
				newTempName(temp);
				strcpy($$, temp); 
						
				//divide code instructions
				char *tmp = (char *)malloc(sizeof(char)*100);
				sprintf(tmp, "mov edx, 0\n");
				addTempToCS(tmp);
				sprintf(tmp, "mov eax, dword [%s]\n", $1);
				addTempToCS(tmp);
				sprintf(tmp, "mov ecx, %s\n", $3);
				addTempToCS(tmp);
				sprintf(tmp, "div ecx\n");
				addTempToCS(tmp);
				sprintf(tmp, "mov [%s], eax\n", temp);
				addTempToCS(tmp);
			}
			;
			  
instr_io: WRITE LEFT_BRACKET ID RIGHT_BRACKET SEMICOLON
	{
		char *tmp = (char *)malloc(sizeof(char)*100);
		sprintf(tmp, "push dword [%s]\npush formatout\ncall printf\nadd esp, 8\n", $3);
		addTempToCS(tmp);
	}	
	| READ LEFT_BRACKET termen RIGHT_BRACKET SEMICOLON	
	{
		char *tmp = (char *)malloc(sizeof(char)*100);
		sprintf(tmp, "push %s\npush formatin\ncall scanf\nadd esp, 8\n", $3);
		addTempToCS(tmp);
	}
	;

 
termen: ID		
		| CONST	
		;
			
%%

int main(int argc, char *argv[]) 
{	
	memset(DS, 0, 1000);
	memset(CS, 0, 1000);

	FILE *f = fopen(argv[1], "r");

	if(!f) 
	{
		perror("Could not open file!");
		exit(1);
	}

	yyin = f;
	
	while(!feof(yyin)) { yyparse(); }

	char *file = strtok(argv[1], ".");

	writeAssemblyToFile(file);
	
	return 0;
}


void addTempToDS(char *s) {
	strcat(DS, s);		
}


void addTempToCS(char *s) {
	strcat(CS, s);
}

void writeAssemblyToFile(char *file) {
	char* dataSectionHeader = (char*) malloc(sizeof(char)*100);
	char* codeSectionHeader = (char*) malloc(sizeof(char)*100);
	char* exitCall = (char*) malloc(sizeof(char)*100);


	sprintf(dataSectionHeader, "section .data\nformatin: db \"%%d\", 0\nformatout: db \"%%d\", 10, 0\n");
	sprintf(codeSectionHeader, "\nsection .text\nglobal main\nextern scanf\nextern printf\nmain:\n");
	sprintf(exitCall, "\nmov eax, 0\nret\n");

	strcat(file, ".asm");

	FILE *f = fopen(file, "w");
	if(f == NULL) {
		perror("Failed to open asm file.");
		exit(1);
	}
	fwrite(dataSectionHeader, strlen(dataSectionHeader), 1, f);
	fwrite(DS, strlen(DS), 1, f);
	fwrite(codeSectionHeader, strlen(codeSectionHeader), 1, f);
	fwrite(CS, strlen(CS), 1, f);
	fwrite(exitCall, strlen(exitCall), 1, f);

	fclose(f);
	free(dataSectionHeader);
	free(codeSectionHeader);
	free(exitCall);
}


void newTempName(char *s) {
	sprintf(s, "temp%d: times 4 db 0\n", tempnr);
	addTempToDS(s);
	sprintf(s, "temp%d", tempnr);
	tempnr++;
}


void yyerror(char *err) {
	printf( "Unexpected token \"%s\" on line #%d: %s \n", yytext, CURRENT_LINE, err);
	exit(1);
}
