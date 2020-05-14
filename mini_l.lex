%{
#define YY_NO_UNPUT

using namespace std;

#include <iostream>
#include <stdio.h>
#include <string>
#include <stdlib.h>

	int currLine = 1, currPos = 1;
%}

%%
function	return FUNCTION; currPos += yyleng;
beginparams	return BEGINPARAMS; currPos += yyleng;
endparams	return ENDPARAMS; currPos += yyleng;
beginlocals	return BEGINLOCALS; currPos += yyleng;
endlocals	return ENDLOCALS; currPos += yyleng;
beginbody	return BEGINBODY; currPos += yyleng;
endbody		return ENDBODY; currPos += yyleng;
integer		return INTEGER; currPos += yyleng;
array		return ARRAY; currPos += yyleng;
of		return OF; currPos += yyleng;
if		return IF; currPos += yyleng;
then		return THEN; currPos += yyleng;
endif		return ENDIF; currPos += yyleng;
else		return ELSE; currPos += yyleng;
while		return WHILE; currPos += yyleng;
do		return DO; currPos += yyleng;
beginloop	return BEGINLOOP; currPos += yyleng;
endloop		return ENDLOOP; currPos += yyleng;
continue	return CONTINUE; currPos += yyleng;
read		return READ; currPos += yyleng;
write		return WRITE; currPos += yyleng;
and		return AND; currPos += yyleng;
or		return OR; currPos += yyleng;
not		return NOT; currPos += yyleng;
true		return TRUE; currPos += yyleng;
false		return FALSE; currPos += yyleng;
return		return RETURN; currPos += yyleng;

"-"		return SUB; currPos += yyleng;
"+"		return ADD;currPos += yyleng;
"*"		return MULT;currPos += yyleng;
"/"		return DIV;currPos += yyleng;
"%"		return MOD;currPos += yyleng;

"=="		return EQ;currPos += yyleng;
"<>"		return NEQ;currPos += yyleng;
"<"		return LT;currPos += yyleng;
">"		return GT;currPos += yyleng;
"<="		return LTE;currPos += yyleng;
">="		return GTE;currPos += yyleng;


[##].*		currLine++; currPos=1;      
		
";"		return SEMICOLON; currPos += yyleng;
":"		return COLON; currPos += yyleng;
","		return COMMA; currPos += yyleng;
"("		return LPAREN; currPos += yyleng;
")"		return RPAREN; currPos += yyleng;
"["		return LSQUARE; currPos += yyleng;
"]"		return R_SQUARE; currPos += yyleng;
":="		return ASSIGN; currPos += yyleng;

[0-9]+					return NUMBERS;   currPos += yyleng;
[0-9_][a-zA-Z0-9_]*[a-zA-Z0-9_]      printf("Error at line %d, column %d: Identifier \"%s\" must begin with a letter\n",currLine,currPos,yytext); currPos += yyleng; exit(0);
[a-zA-Z][a-zA-Z0-9_]*[_]               printf("Error at line %d, column %d: Identifier \"%s\" cannot end with an underscore\n",currLine,currPos,yytext);currPos += yyleng;exit(0); 
[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]	return IDENTIFIERS;currPos += yyleng;
[a-zA-Z][a-zA-Z0-9]*			return IDENTIFIERS; currPos += yyleng;

[ ]             currPos += yyleng;
[\t]+		currPos += yyleng;
"\n"		currLine+= yyleng;	currPos=1;

.		printf("Error at line %d, column %d :unrecognized symbol \"%s\"\n",currLine,currPos,yytext);	exit(0);
%%


int main(int argc, char* argv[])
{
    if(argc >= 2){
      yyin = fopen(argv[1], "r");
      if(yyin == NULL){
         yyin = stdin;
      }
   }
   else{
      yyin = stdin;
   }
   
   yylex();
}
