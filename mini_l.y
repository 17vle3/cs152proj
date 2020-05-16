%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);
 extern int currLine;
 extern int currPos;
 FILE * yyin;
%}

%union{
int val;
char* idval;
}

%start	Program
%token	FUNCTION BEGINPARAMS ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY
%token  INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP 
%token  CONTINUE READ WRITE TRUE FALSE RETURN 
%token  SEMICOLON COLON COMMA LPAREN RPAREN LSQUARE RSQUARE EQUAL
%token <val> NUMBER
%token <idval> IDENT
%left MULT DIV MOD ADD SUB 
%left LT LTE GT GTE EQ NEQ
%right NOT
%left AND OR
%right ASSIGN

%%
Program:         %empty
{printf("Program -> epsilon\n");}
                 | Function Program
		 {printf("Program -> Function Program\n");};

ident:      	 IDENT
{printf("ident -> IDENT %s \n", $1);}

Function:        FUNCTION ident SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY Statements ENDBODY
{printf("Function -> FUNCTION ident SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY Statements ENDBODY\n");};

declaration:     identifiers COLON INTEGER
{printf("declaration -> identifiers COLON INTEGER\n");}
                 | identifiers COLON ARRAY LSQUARE NUMBER RSQUARE OF INTEGER
		 {printf("declaration -> identifiers COLON ARRAY LSQUARE NUMBER %d RSQUARE OF INTEGER;\n", $5);}
;
declarations:    %empty
{printf("declarations -> epsilon\n");}
                 | declaration SEMICOLON declarations
		 {printf("declarations -> declaration SEMICOLON declarations\n");}
;

identifiers:     ident
{printf("identifiers -> ident \n");}
                 | ident COMMA identifiers
		 {printf("identifiers -> ident COMMA identifiers\n");}

Statements:      Statement SEMICOLON Statements
{printf("Statements -> Statement SEMICOLON Statements\n");}
                 | Statement SEMICOLON
		 {printf("Statements -> Statement SEMICOLON\n");}
;

Statement:      Var = Expression
{printf("Syntax error at line %d: ":=" expected\n", currLine);}

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

Var:             ident LSQUARE Expression RSQUARE
{printf("Var -> ident  LSQUARE Expression RSQUARE\n");}
                 | ident
		 {printf("Var -> ident \n");}
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
                 | NUMBER
		 {printf("Term -> NUMBER %d\n", $1);}
                 | SUB NUMBER
		 {printf("Term -> SUB NUMBER %d\n", $2);}
                 | LPAREN Expression RPAREN
		 {printf("Term -> LPAREN Expression RPAREN\n");}
                 | SUB LPAREN Expression RPAREN
		 {printf("Term -> SUB LPAREN Expression RPAREN\n");}
                 | ident LPAREN Expressions RPAREN
		 {printf("Term -> ident LPAREN Expressions RPAREN\n");}
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


%%

void yyerror(const char *s) {
   printf("** Line %d, position %d: %s\n", currLine, currPos, s);
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

