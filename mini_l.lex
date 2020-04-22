%{
	int row = 1; 
	int column = 1;
%}



%%

		/*Reserved Keywords*/
function	printf("FUNCTION\n");  column += yyleng;
beginparams	printf("BEGIN_PARAMS\n"); column += yyleng;
endparams	printf("END_PARAMS\n"); column += yyleng;
beginlocals	printf("BEGIN_LOCALS\n"); column += yyleng;
endlocals	printf("END_LOCALS\n"); column += yyleng;
beginbody	printf("BEGIN_BODY\n"); column += yyleng;
endbody		printf("END_BODY\n"); column += yyleng;
integer		printf("INTEGER\n"); column += yyleng;
array		printf("ARRAY\n"); column += yyleng;
of		printf("OF\n"); column += yyleng;
if		printf("IF\n"); column += yyleng;
then		printf("THEN\n"); column += yyleng;
endif		printf("ENDIF\n"); column += yyleng;
else		printf("ELSE\n"); column += yyleng;
while		printf("WHILE\n"); column += yyleng;
do		printf("DO\n"); column += yyleng;
beginloop	printf("BEGINLOOP\n"); column += yyleng;
endloop		printf("ENDLOOP\n"); column += yyleng;
continue	printf("CONTINUE\n"); column += yyleng;
read		printf("READ\n"); column += yyleng;
write		printf("WRITE\n"); column += yyleng;
and		printf("AND\n"); column += yyleng;
or		printf("OR\n"); column += yyleng;
not		printf("NOT\n"); column += yyleng;
true		printf("TRUE\n"); column += yyleng;
false		printf("FALSE\n"); column += yyleng;


		/*Operands*/
"-"		printf("SUB\n"); column += yyleng;
"+"		printf("ADD\n");column += yyleng;
"*"		printf("MULT\n");column += yyleng;
"/"		printf("DIV\n");column += yyleng;
"%"		printf("MOD\n");column += yyleng;


"=="		printf("EQ\n");column += yyleng;
"<>"		printf("NEQ\n");column += yyleng;
"<"		printf("LT\n");column += yyleng;
">"		printf("GT\n");column += yyleng;
"<="		printf("LTE\n");column += yyleng;
">="		printf("GTE\n");column += yyleng;


		/*Comments*/
[##].*		row = row + 1; column=1;      
		

		
";"		printf("SEMICOLON\n"); column += yyleng;
":"		printf("COLON\n"); column += yyleng;
","		printf("COMMA\n"); column += yyleng;
"("		printf("L_PAREN\n"); column += yyleng;
")"		printf("R_PAREN\n"); column += yyleng;
"["		printf("L_SQUARE_BRACKET\n"); column += yyleng;
"]"		printf("R_SQUARE_BRACKET\n"); column += yyleng;
":="		printf("ASSIGN\n"); column += yyleng;


		/*Identifiers and Numbers*/
[0-9]+					printf("NUMBER %s\n",yytext);   column += yyleng;
[0-9|_][a-zA-Z0-9|_]*[a-zA-Z0-9|_]      printf("Error at line %d, column %d: Identifier \"%s\" must begin with a letter\n",row,column,yytext); column += yyleng; exit(0);
[a-zA-Z][a-zA-Z0-9|_]*[_]               printf("Error at line %d, column %d: Identifier \"%s\" cannot end with an underscore\n",row,column,yytext);column += yyleng;exit(0); 
[a-zA-Z][a-zA-Z0-9|_]*[a-zA-Z0-9]	printf("IDENT %s\n", yytext);column += yyleng;
[a-zA-Z][a-zA-Z0-9]*			printf("IDENT %s\n", yytext); column += yyleng;


		/*Spaces and Tabs*/
[ ]         	column++; 
[\t]		column++;
[\n]		row++;	column=1;

		/*Unidentified Characters*/
.		printf("Error at line %d, column %d :unrecognized symbol \"%s\"\n",row,column,yytext);	exit(0);
%%


int main(int argc, char* argv[])
{
    if(argc == 2)
    {
	yyin = fopen(argv[1],"r");
	yylex();
	fclose(yyin);
    }
    else
        yylex();
}
