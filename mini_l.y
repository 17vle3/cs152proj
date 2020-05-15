%{
#include <stdio.h>
#include <stdlib.h>
int yyerror (char* s);
 extern int currLine;
 extern int currPos;
 FILE * yyin;
%}

%union{
int val;
char* idval;
}

%start	prog_start
%token	FUNCTION BEGINPARAMS ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY
%token  INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP 
%token  CONTINUE READ WRITE TRUE FALSE RETURN 
%token  SEMICOLON COLON COMMA LPAREN RPAREN LSQUARE RSQUARE 
%token <val> NUMBERS
%token <idval> IDENTIFIERS
%left MULT DIV MOD ADD SUB 
%left LT LTE GT GTE EQ NEQ
%right NOT
%left AND OR
%right ASSIGN

%%
Program:         %empty
{printf("Program -> epsilon\n");}
                 | Function prog_start
		 {printf("Program -> Function Program\n");}
;

Function:        FUNCTION Ident SEMICOLON BEGINPARAMS Declarations ENDPARAMS BEGINLOCALS Declarations ENDLOCALS BEGINBODY Statements ENDBODY
{printf("Function -> FUNCTION Ident SEMICOLON BEGINPARAMS Declarations ENDPARAMS BEGINLOCALS Declarations ENDLOCALS BEGINBODY Statements ENDBODY\n");}
;

Declaration:     Identifiers COLON INTEGER
{printf("Declaration -> Identifiers COLON INTEGER\n");}
                 | Identifiers COLON ARRAY LSQUARE NUMBERS RSQUARE OF INTEGER
		 {printf("Declaration -> Identifiers COLON ARRAY LSQUARE NUMBERS %d RSQUARE  OF INTEGER;\n", $5);}
;
Declarations:    %empty
{printf("Declarations -> epsilon\n");}
                 | Declaration SEMICOLON Declarations
		 {printf("Declarations -> Declaration SEMICOLON Declarations\n");}
;

Identifiers:     Ident
{printf("Identifiers -> Ident \n");}
                 | Ident COMMA Identifiers
		 {printf("Identifiers -> Ident COMMA Identifiers\n");}

Statements:      Statement SEMICOLON Statements
{printf("Statements -> Statement SEMICOLON Statements\n");}
                 | Statement SEMICOLON
		 {printf("Statements -> Statement SEMICOLON\n");}
;
Statement:      Var ASSIGN Expression
{printf("Statement -> Var ASSIGN Expression\n");}
                 | IF BoolExp THEN Statements ElseStatement ENDIF
		 {printf("Statement -> IF BoolExp THEN Statements ElseStatement ENDIF\n");}		 
                 | WHILE BoolExp BEGINLOOP Statements ENDLOOP
		 {printf("Statement -> WHILE BoolExp BEGINLOOP Statements ENDLOOP\n");}
                 | DO BEGINLOOP Statements ENDLOOP WHILE BoolExp
		 {printf("Statement -> DO BEGINLOOP Statements ENDLOOP WHILE BoolExp\n");}
                 | READ Vars
		 {printf("Statement -> READ Vars\n");}
                 | WRITE Vars
		 {printf("Statement -> WRITE Vars\n");}
                 | CONTINUE
		 {printf("Statement -> CONTINUE\n");}
                 | RETURN Expression
		 {printf("Statement -> RETURN Expression\n");}
;
ElseStatement:   %empty
{printf("ElseStatement -> epsilon\n");}
                 | ELSE Statements
		 {printf("ElseStatement -> ELSE Statements\n");}
;

Var:             Ident LSQUARE Expression RSQUARE
{printf("Var -> Ident  LSQUARE Expression RSQUARE\n");}
                 | Ident
		 {printf("Var -> Ident \n");}
;
Vars:            Var
{printf("Vars -> Var\n");}
                 | Var COMMA Vars
		 {printf("Vars -> Var COMMA Vars\n");}
;

Expression:      MultExp
{printf("Expression -> MultExp\n");}
                 | MultExp ADD Expression
		 {printf("Expression -> MultExp ADD Expression\n");}
                 | MultExp SUB Expression
		 {printf("Expression -> MultExp SUB Expression\n");}
;
Expressions:     %empty
{printf("Expressions -> epsilon\n");}
                 | Expression COMMA Expressions
		 {printf("Expressions -> Expression COMMA Expressions\n");}
                 | Expression
		 {printf("Expressions -> Expression\n");}
;

MultExp:         Term
{printf("MultExp -> Term\n");}
                 | Term MULT MultExp
		 {printf("MultExp -> Term MULT MultExp\n");}
                 | Term DIV MultExp
		 {printf("MultExp -> Term DIV MultExp\n");}
                 | Term MOD MultExp
		 {printf("MultExp -> Term MOD MultExp\n");}
;

Term:            Var
{printf("Term -> Var\n");}
                 | SUB Var
		 {printf("Term -> SUB Var\n");}
                 | NUMBERS
		 {printf("Term -> NUMBERS %d\n", $1);}
                 | SUB NUMBERS
		 {printf("Term -> SUB NUMBERS %d\n", $2);}
                 | LPAREN Expression RPAREN
		 {printf("Term -> LPAREN Expression RPAREN\n");}
                 | SUB LPAREN Expression RPAREN
		 {printf("Term -> SUB LPAREN Expression RPAREN\n");}
                 | Ident LPAREN Expressions RPAREN
		 {printf("Term -> Ident LPAREN Expressions RPAREN\n");}
;

BoolExp:         RAExp 
{printf("bool_exp -> relation_exp\n");}
                 | RAExp OR BoolExp
                 {printf("bool_exp -> relation_and_exp OR bool_exp\n");}
;

RAExp:           RExp
{printf("relation_and_exp -> relation_exp\n");}
                 | RExp AND RAExp
                 {printf("relation_and_exp -> relation_exp AND relation_and_exp\n");}
;

RExp:            NOT RExp1 
{printf("relation_exp -> NOT relation_exp1\n");}
                 | RExp1
                 {printf("relation_exp -> relation_exp1\n");}

;
RExp1:           Expression Comp Expression
{printf("relation_exp -> Expression Comp Expression\n");}
                 | TRUE
		     {printf("relation_exp -> TRUE\n");}
                 | FALSE
		     {printf("relation_exp -> FALSE\n");}
                 | LPAREN BoolExp RPAREN
		   {printf("relation_exp -> LPAREN BoolExp RPAREN\n");}
;

Comp:            EQ
{printf("comp -> EQ\n");}
                 | NEQ
                 {printf("comp -> NEQ\n");}
                 | LT
                 {printf("comp -> LT\n");}
                 | GT
                 {printf("comp -> GT\n");}
                 | LTE
                 {printf("comp -> LTE\n");}
                 | GTE
                 {printf("comp -> GTE\n");}
;

Ident:      IDENTIFIERS
{printf("Ident -> IDENTIFIERS %s \n", $1);}
%%

int yyerror(char *s)
{
  return yyerror(string(s));
}

int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}

