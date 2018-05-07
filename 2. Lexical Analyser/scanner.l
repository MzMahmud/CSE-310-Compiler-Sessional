%option noyywrap

%{
#include "Includes.cpp"
%}
W [ \t\f\r\v]+
L [a-zA-Z]
D [0-9]
N \n
A .
%%
{N} 			{line++;}
{W} 			{}
"if" 			{
				fprintf(logOut,"\nLine No. %d : Token <IF> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<IF> ");
			}
"else" 			{
				fprintf(logOut,"\nLine No. %d : Token <ELSE> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<ELSE> ");

			}
"for" 			{
				fprintf(logOut,"\nLine No. %d : Token <FOR> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<FOR> ");
			}
"while" 		{
				fprintf(logOut,"\nLine No. %d : Token <WHILE> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<WHILE> ");
			}
"do" 			{
				fprintf(logOut,"\nLine No. %d : Token <DO> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<DO> ");
			}
"break" 		{
				fprintf(logOut,"\nLine No. %d : Token <BREAK> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<BREAK> ");
			}
"int" 			{
				fprintf(logOut,"\nLine No. %d : Token <INT> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<INT> ");
			}
"char" 			{
				fprintf(logOut,"\nLine No. %d : Token <CHAR> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<CHAR> ");
			}
"float" 		{
				fprintf(logOut,"\nLine No. %d : Token <FLOAT> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<FLOAT> ");
			}
"double" 		{
				fprintf(logOut,"\nLine No. %d : Token <DOUBLE> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<DOUBLE> ");
			}
"void" 			{
				fprintf(logOut,"\nLine No. %d : Token <VOID> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<VOID> ");
			}
"return" 		{
				fprintf(logOut,"\nLine No. %d : Token <RETURN> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<RETURN> ");
			}
"switch" 		{
				fprintf(logOut,"\nLine No. %d : Token <SWITCH> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<SWITCH> ");
			}
"case" 			{
				fprintf(logOut,"\nLine No. %d : Token <CASE> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<CASE> ");
			}
"default" 		{
				fprintf(logOut,"\nLine No. %d : Token <DEFAULT> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<DEFAULT> ");
			}
"continue" 		{
				fprintf(logOut,"\nLine No. %d : Token <CONTINUE> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<CONTINUE> ");
			}
(_|{L})+(_|{L}|{D})*	{
				fprintf(logOut,"\nLine No. %d : Token <ID> Lexeme %s Found\n",line,yytext);
				fprintf(tokenOut,"<ID , %s > ",yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("ID",yytext);
			}
{D}+			{
				fprintf(logOut,"\nLine No. %d : Token <CONST_INT> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_INT",yytext);

				fprintf(tokenOut,"<CONST_INT , %s > ",yytext);
				insertPrint("CONST_INT",yytext);
			}
{D}*(\.)?{D}+([eE][+-]?{D}+)? {
				fprintf(logOut,"\nLine No. %d : Token <CONST_FLOAT> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_FLOAT",yytext);

				fprintf(tokenOut,"<CONST_FLOAT , %s > ",yytext);
			}
('.')			{
				//convert into ASCII
				char ch = yytext[1];
				if(ch == '\\'){
					errors++;
					fprintf(logOut,"\nLine No. %d : <LEXICAL_ERROR> Unfinished character constant,Lexeme %s Found\n",line,yytext);
				}else{
					fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %c Found\n",line,ch);
					//insert in symbol table
					//print symbol table
					char s[2] = "a";
					s[0] = ch;
					insertPrint("CONST_CHAR",s);

					fprintf(tokenOut,"<CONST_CHAR , %c > ",ch);
				}
			}
('\\0') 		{
				//convert into ASCII
				char ch = '\0';
				fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_CHAR","\0");
				
				fprintf(tokenOut,"<CONST_CHAR , %s > ",yytext);
			}
('\\a') 		{
				//convert into ASCII
				char ch = '\a';
				fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_CHAR","\a");

				fprintf(tokenOut,"<CONST_CHAR , %s > ",yytext);
			}
('\\b') 		{
				//convert into ASCII
				char ch = '\b';
				fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_CHAR","\b");


				fprintf(tokenOut,"<CONST_CHAR , %s > ",yytext);
			}
('\\n') 		{
				//convert into ASCII
				char ch = '\n';
				fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_CHAR","\n");


				fprintf(tokenOut,"<CONST_CHAR , %s > ",yytext);
			}
('\\t') 		{
				//convert into ASCII
				char ch = '\t';
				fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_CHAR","\t");


				fprintf(tokenOut,"<CONST_CHAR , %s > ",yytext);
			}
('\\f') 		{
				//convert into ASCII
				char ch = '\f';
				fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_CHAR","\f");


				fprintf(tokenOut,"<CONST_CHAR , %s > ",yytext);
			}
('\\r') 		{
				//convert into ASCII
				char ch = '\r';
				fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_CHAR","\r");


				fprintf(tokenOut,"<CONST_CHAR , %s > ",yytext);
			}
('\\v') 		{
				//convert into ASCII
				char ch = '\0';
				fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_CHAR","\v");


				fprintf(tokenOut,"<CONST_CHAR , %s > ",yytext);
			}
('\\\\') 		{
				//convert into ASCII
				char ch = '\\';
				fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %c Found\n",line,ch);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_CHAR","\\");

				fprintf(tokenOut,"<CONST_CHAR , %c > ",ch);
			}
('\\\"') 		{
				//convert into ASCII
				char ch = '\"';
				fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %c Found\n",line,ch);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_CHAR","\"");

				fprintf(tokenOut,"<CONST_CHAR , %c > ",ch);
			}
('\\\'') 		{
				//convert into ASCII
				char ch = '\'';
				fprintf(logOut,"\nLine No. %d : Token <CONST_CHAR> Lexeme %c Found\n",line,ch);
				//insert in symbol table
				//print symbol table
				insertPrint("CONST_CHAR","\'");

				fprintf(tokenOut,"<CONST_CHAR , %c > ",ch);
			}
[+-]			{
				fprintf(logOut,"\nLine No. %d : Token <ADDOP> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("ADDOP",yytext);

				fprintf(tokenOut,"<ADDOP , %s > ",yytext);
			}
[\*/%]			{
				fprintf(logOut,"\nLine No. %d : Token <MULOP> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("MULOP",yytext);

				fprintf(tokenOut,"<MULOP , %s > ",yytext);
			}
"++"|"--"		{
				fprintf(logOut,"\nLine No. %d : Token <INCOP> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("INCOP",yytext);

				fprintf(tokenOut,"<INCOP , %s > ",yytext);
			}
"<"|"<="|">"|">="|"=="|"!=" {
				fprintf(logOut,"\nLine No. %d : Token <RELOP> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("RELOP",yytext);

				fprintf(tokenOut,"<RELOP , %s > ",yytext);
			}
"="			{
				fprintf(logOut,"\nLine No. %d : Token <ASSIGNOP> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("ASSIGNOP",yytext);

				fprintf(tokenOut,"<ASSIGNOP , %s > ",yytext);
			}
"&&"|"\|\|"		{
				fprintf(logOut,"\nLine No. %d : Token <LOGICOP> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("LOGICOP",yytext);

				fprintf(tokenOut,"<LOGICOP , %s > ",yytext);
			}
"&"|"\|"|"~"|"<<"|">>"  {
				fprintf(logOut,"\nLine No. %d : Token <BITOP> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("BITOP",yytext);

				fprintf(tokenOut,"<BITOP , %s > ",yytext);
			}
"!"			{
				fprintf(logOut,"\nLine No. %d : Token <NOT> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("NOT",yytext);

				fprintf(tokenOut,"<NOT , %s > ",yytext);
			}
"("			{
				fprintf(logOut,"\nLine No. %d : Token <LPAREN> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("LPARENT",yytext);

				fprintf(tokenOut,"<LPAREN , %s > ",yytext);
			}
")"			{
				fprintf(logOut,"\nLine No. %d : Token <RPAREN> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("RPAREN",yytext);

				fprintf(tokenOut,"<RPAREN , %s > ",yytext);
			}
"{"			{
				fprintf(logOut,"\nLine No. %d : Token <LCURL> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("LCURL",yytext);

				fprintf(tokenOut,"<LCURL , %s > ",yytext);
			}
"}"			{
				fprintf(logOut,"\nLine No. %d : Token <RCURL> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("RCURL",yytext);

				fprintf(tokenOut,"<RCURL , %s > ",yytext);
			}
"["			{
				fprintf(logOut,"\nLine No. %d : Token <LTHIRD> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("LTHIRD",yytext);

				fprintf(tokenOut,"<LTHIRD , %s > ",yytext);
			}
"]"			{
				fprintf(logOut,"\nLine No. %d : Token <RTHIRD> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("RTHIRD",yytext);

				fprintf(tokenOut,"<RTHIRD , %s > ",yytext);
			}
","			{
				fprintf(logOut,"\nLine No. %d : Token <COMMA> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("COMMA",yytext);

				fprintf(tokenOut,"<COMMA , %s > ",yytext);
			}
";"			{
				fprintf(logOut,"\nLine No. %d : Token <SEMICOLON> Lexeme %s Found\n",line,yytext);
				//insert in symbol table
				//print symbol table
				insertPrint("SEMICOLON",yytext);

				fprintf(tokenOut,"<SEMICOLON , %s > ",yytext);
			}
\"(.|("\\\n"))*\"	{
				//Handle string function
				HandleString(yytext,true);
			}
("/\*"(.|\n)*"\*/")|("//"(.|"\\\n")*\n)	{
				fprintf(logOut,"\nLine No. %d : Token <COMMENT> Lexeme %s Found\n",line,yytext);
				//Handle comment function
				multiComment(yytext);
			}
{D}+(_|{L})+		{
				errors++;
				fprintf(logOut,"\nLine No. %d : Invalid prefix on ID or invalid suffix on Number %s Found\n",line,yytext);
			}
'..+'			{
				errors++;
				char mess[100] = "";
				if(strlen(yytext) == 4 && yytext[1] == '\\')
					strcpy(mess,"Unterminated character");
				else	strcpy(mess,"Multi character constant error");
				fprintf(logOut,"\nLine No. %d : %s %s Found\n",line,mess,yytext);
			}
''			{
				errors++;
				fprintf(logOut,"\nLine No. %d : Empty character constant error %s\n Found",line,yytext);
			}
'.[^']			{
				errors++;
				fprintf(logOut,"\nLine No. %d : Unterminated character %s\n",line,yytext);
			}
\"([^"]|(\\\n))*[^"]	{
				errors++;
				HandleString(yytext,false);
			}
"/\*"([^*/]|\n)*[^*/]	{
				errors++;
				fprintf(logOut,"\nLine No. %d : Unterminated comment %s Found\n",line,yytext);
			}
{D}*[.]+{D}*[.]+{D}*	{
				errors++;
				fprintf(logOut,"\nLine No. %d : Too many decimal point %s\n",line,yytext);
			}

[+-]?{D}*(\.)?{D}+[eE][+-]?{D}*[.]+{D}* {
				errors++;
				fprintf(logOut,"\nLine No. %d : Ill formed number %s\n",line,yytext);
			}
%%

int main(int argc,char *argv[]){

	if(argc != 2){
		printf("Please provide input file name and try again\n");
		return 0;
	}

	FILE *fin = fopen(argv[1],"r");
	if(fin == NULL){
		printf("Cannot open specified file\n");
		return 0;
	}

	logOut   = fopen("log.txt","w");
	tokenOut = fopen("token.txt","w");

	yyin= fin;

	yylex();

	fprintf(logOut,"\nTotal Lines : %d\n",line);
	fprintf(logOut,"\nTotal Errors: %d\n",errors);

	fclose(yyin);
	fclose(tokenOut);
	fclose(logOut);
	return 0;
}
