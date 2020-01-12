%{

	#include <cstdio>
	#include <iostream>
	#include <string>
    #include <iomanip>
	using namespace std;
	void yyerror(char const *msg);
	extern int yylex();
	extern int yyparse();
	extern FILE *yyin;

%}

%define parse.error verbose
%start program
%token MAIN
%token ARITHMETIC_OPERATOR
%token BOOLEAN_OPERATOR
%token IDENTIFIER
%token IF
%token WHILE
%token FOR
%token COUT
%token OUT
%token CIN
%token IN
%token INCREMENT
%token NEW_LINE
%token INT
%token FLOAT
%token INT_CONSTANT
%token FLOAT_CONSTANT
%token STRING_CONSTANT
%token RETURN_STATEMENT

%%

program: MAIN '(' ')' '{' lista_instr '}' 
		 {cout << "Program corect.\n";}
		 ;

lista_instr: instructiune |
		     instructiune lista_instr 
		     {cout << "lista_instr.\n";}
		     ;

instructiune: declaratie ';' |
			  declaratie_vector ';' |
			  atribuire ';' | 
			  afisare ';' |
			  citire ';' | 
			  return_instr ';' | 
			  for_instr | 
			  if_instr | 
			  while_instr 
			  {cout << "instructiune.\n";}
			  ;

declaratie: INT IDENTIFIER | 
			FLOAT IDENTIFIER | 
			INT IDENTIFIER '=' INT_CONSTANT | 
			FLOAT IDENTIFIER '=' FLOAT_CONSTANT |
			INT IDENTIFIER '=' operatie_aritmetica |
			FLOAT IDENTIFIER '=' operatie_aritmetica
			{cout << "declaratie.\n";}
			;

declaratie_vector: INT IDENTIFIER '[' INT_CONSTANT ']' '=' '{' INT_CONSTANT '}' |
				   FLOAT IDENTIFIER '[' INT_CONSTANT ']' '=' '{' INT_CONSTANT '}' 
				   {cout << "declaratie_vector.\n";}
				   ;

atribuire: IDENTIFIER '=' INT_CONSTANT |
		   IDENTIFIER '=' FLOAT_CONSTANT | 
		   IDENTIFIER '=' IDENTIFIER |
		   IDENTIFIER '=' operatie_aritmetica | 
		   IDENTIFIER INCREMENT | 
		   IDENTIFIER '[' IDENTIFIER ']' '=' INT_CONSTANT | 
		   IDENTIFIER '[' IDENTIFIER ']' '=' FLOAT_CONSTANT | 
		   IDENTIFIER '[' IDENTIFIER ']' '=' IDENTIFIER | 
		   IDENTIFIER '[' INT_CONSTANT ']' '=' INT_CONSTANT |
		   IDENTIFIER '[' INT_CONSTANT ']' '=' FLOAT_CONSTANT |
		   IDENTIFIER '[' INT_CONSTANT ']' '=' IDENTIFIER
		   {cout << "atribuire.\n";}
		   ;

return_instr: RETURN_STATEMENT INT_CONSTANT 
			  {cout << "return_instr.\n";}
			  ;

operatie_aritmetica: termen ARITHMETIC_OPERATOR termen 
					 {cout << "operatie_aritmetica.\n";}
					 ;

termen: IDENTIFIER |
	    INT_CONSTANT | 
	    FLOAT_CONSTANT | 
	    IDENTIFIER '[' IDENTIFIER ']' | 
	    IDENTIFIER '[' INT_CONSTANT ']' 
	    {cout << "termen.\n";}
	    ;

if_instr: IF '(' conditie ')' '{' lista_instr '}' 
		  {cout << "if_instr.\n";}
		  ;

while_instr: WHILE '(' conditie ')' '{' lista_instr '}' 
			 {cout << "while_instr.\n";}
			 ;

for_instr: FOR '(' declaratie ';' conditie ';' atribuire ')' '{' lista_instr '}' 
		   {cout << "for_instr.\n";}
		   ;

conditie: INT_CONSTANT BOOLEAN_OPERATOR INT_CONSTANT | 
		  FLOAT_CONSTANT BOOLEAN_OPERATOR FLOAT_CONSTANT | 
		  STRING_CONSTANT BOOLEAN_OPERATOR STRING_CONSTANT |
		  IDENTIFIER BOOLEAN_OPERATOR IDENTIFIER |
		  IDENTIFIER BOOLEAN_OPERATOR INT_CONSTANT |
		  IDENTIFIER BOOLEAN_OPERATOR FLOAT_CONSTANT |
		  INT_CONSTANT BOOLEAN_OPERATOR IDENTIFIER |
		  FLOAT_CONSTANT BOOLEAN_OPERATOR IDENTIFIER
		  {cout << "conditie.\n";}
		  ;

afisare: COUT OUT INT_CONSTANT | 
		 COUT OUT FLOAT_CONSTANT | 
		 COUT OUT STRING_CONSTANT | 
		 COUT OUT IDENTIFIER | 
		 COUT OUT NEW_LINE 
		 {cout << "afisare.\n";}
		 ;

citire: CIN IN IDENTIFIER 
		{cout << "citire.\n";}
		;

%%

void yyerror(char const *msg){
	cout << "\033[3;;91mEroare[ " << msg << " ]\033[0m \n";
	exit(-1);
}

int main(int numberOfArgs, char** args){
    if(numberOfArgs > 2){
        cout << "Prea multe argumente!\n";
        return -1;
    }
    if(numberOfArgs < 2){
        cout << "Prea putine argumente!(lipseste numele fisierului)\n";
        return -1;
    }
	FILE *myFile = fopen(args[1], "r");
	if(!myFile){
		cout << "Nu s-a putut deschide fisierul \"" << args[1] << "\".\n";
		return -1;
	}
	yyin = myFile;
	yyparse();
    cout << "\n\033[3;;92mFisier parsat cu succes!\033[0m\n\n";
}

