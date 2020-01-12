/*
 * Lexical analizer for the chosen language.
 * Reads symbols from an input file an processes them.
 */

%{
#ifdef YYDEBUG
  yydebug = 1;
#endif
#include<string.h>
#include<stdio.h>
#include<stdlib.h>
#include "attrib.h"

int  lineno = 1; /* number of current source line */

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
void writeAssemblyToFile();

//counter for the temp variables
int tempnr = 1;
//create a new temp variable and add it to DS
void newTempName(char *s);

%}

%union {
	char varname[10];
	attributes attrib;
}


%token BEGIN_PROGRAM
%token END_PROGRAM
%token BEGIN_BLOCK
%token END_BLOCK
%token INT
%token REAL
%token ARRAY_INT
%token ARRAY_REAL
%token READ
%token WRITE
%token IF
%token ELSE
%token WHILE
%token NE
%token GT
%token LT
%token EQ
%token GE
%token LE
%token ASSUME
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token AND
%token SEMICOLON
%token COMMA
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token SQUARE_LEFT_BRACKET
%token SQUARE_RIGHT_BRACKET
%token MAIN
%token LEFT_ACOL
%token RIGHT_ACOL
%token RETURN

%token <varname> ID
%token <varname> CONST 
%type <attrib> expresie
%type <attrib> termen


%%
	
program: begin_prog LEFT_ACOL lista_declaratii  lista_instr  end_prog RIGHT_ACOL
			;

begin_prog:	INT MAIN LEFT_BRACKET RIGHT_BRACKET 
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
	| REAL 
	;
	
lista_instr: instr 
		| instr lista_instr 
		;
				
instr: instr_atribuire
	| instr_io
	;

instr_atribuire: ID ASSUME expresie SEMICOLON		
						{
							char *tmp = (char *)malloc(sizeof(char)*100);
							//expression result is in temp, so we move it into ID
							sprintf(tmp, "mov eax, [%s]\n", $3.varn);
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
					strcpy($$.varn, temp); 
					
					//add code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov ebx, dword [%s]\n", $1.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mov ecx, dword [%s]\n", $3.varn);
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
					strcpy($$.varn, temp); 
								
					//sub code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov ebx, dword [%s]\n", $1.varn);
					addTempToCS(tmp);
					sprintf(tmp, "mov ecx, dword [%s]\n", $3.varn);
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
					strcpy($$.varn, temp); 
					
					//multiply code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov edx, 0\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov eax, dword [%s]\n", $1.varn);
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
					strcpy($$.varn, temp); 
					
					//multiply code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov edx, 0\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov eax, dword [%s]\n", $1.varn);
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
					strcpy($$.varn, temp); 
							
					//divide code instructions
					char *tmp = (char *)malloc(sizeof(char)*100);
					sprintf(tmp, "mov edx, 0\n");
					addTempToCS(tmp);
					sprintf(tmp, "mov eax, dword [%s]\n", $1.varn);
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
				strcpy($$.varn, temp); 
						
				//divide code instructions
				char *tmp = (char *)malloc(sizeof(char)*100);
				sprintf(tmp, "mov edx, 0\n");
				addTempToCS(tmp);
				sprintf(tmp, "mov eax, dword [%s]\n", $1.varn);
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
		sprintf(tmp, "push %s\npush formatin\ncall scanf\nadd esp, 8\n", $3.varn);
		addTempToCS(tmp);
	}
	;

 
termen: ID			
				{
					strcpy($$.cod, "");
					strcpy($$.varn, $1);
				}
		| CONST	
			{
				strcpy($$.cod, "");
				strcpy($$.varn, $1); 
			}
		;
			
%%

int main(int argc, char *argv[]) {	
	memset(DS, 0, 1000);
	memset(CS, 0, 1000);

	//open the file in read mode
	FILE *f = fopen("in.in", "r");
	if(!f) {
		perror("Could not open file!");
		exit(1);
	}
	//set the input for the flex file
	yyin = f;
	//read each line from the input file and process it
	while(!feof(yyin)) {
		yyparse();
	}

	writeAssemblyToFile();
	
	return 0;
}


void addTempToDS(char *s) {
	strcat(DS, s);		
}


void addTempToCS(char *s) {
	strcat(CS, s);
}

void writeAssemblyToFile() {
	char* dataSectionHeader = (char*) malloc(sizeof(char)*100);
	char* codeSectionHeader = (char*) malloc(sizeof(char)*100);
	char* exitCall = (char*) malloc(sizeof(char)*100);


	sprintf(dataSectionHeader, "section .data\nformatin: db \"%%d\", 0\nformatout: db \"%%d\", 10, 0\n");
	sprintf(codeSectionHeader, "\nsection .text\nglobal main\nextern scanf\nextern printf\nmain:\n");
	sprintf(exitCall, "\nmov eax, 0\nret\n");

	FILE *f = fopen("out.asm", "w");
	if(f == NULL) {
		perror("Failed to open file \"out.asm\".");
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


void yyerror(char *s) {
	printf( "Syntax error on line #%d: %s\n", lineno, s);
	printf( "Last token was \"%s\"\n", yytext);
	exit(1);
}