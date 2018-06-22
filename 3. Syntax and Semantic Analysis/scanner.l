%option noyywrap yylineno

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
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return IF;
				}
"else" 			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return ELSE;
				}
"for" 			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return FOR;
				}
"while" 		{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return WHILE;
				}
"do" 			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return DO;
				}
"break" 		{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return BREAK;
				}
"int" 			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					p->type = "int";
					return INT;
				}
"char" 			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					p->type = "char";
					return CHAR;
				}
"float" 		{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					p->type = "float";
					yylval = p;
					return FLOAT;
				}
"double" 		{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					p->type = "float";
					yylval = p;
					return DOUBLE;
				}
"void" 			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					p->type = "void";
					yylval = p;
					return VOID;
				}
"return" 		{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return RETURN;
				}
"switch" 		{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return SWITCH;
				}
"case" 			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return CASE;
				}
"default" 		{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return DEFAULT;
				}
"continue" 		{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return CONTINUE;
				}
"println" 		{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					p->type = "void";
					
					yylval = p;
					return PRINTLN;
				}
(_|{L})+(_|{L}|{D})*	{

					SymbolInfo *p= table->Lookup(SymbolInfo(yytext,""));
					if(p == NULL){					
						p = new SymbolInfo[1];
						p->name = string(yytext);
					}					
					yylval = p;
					return ID;
				}
{D}+			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					p->type = string("int");
					
					yylval = p;
					return CONST_INT;
				}
{D}*(\.)?{D}+([eE][+-]?{D}+)? {
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					p->type = string("char");
					
					yylval = p;
					return CONST_FLOAT;
				}
('.')			{
				//convert into ASCII
				char ch = yytext[1];
				if(ch == '\\'){
					errors++;
					fprintf(errorOut,"\nLine No. %d : <LEXICAL_ERROR> Unfinished character constant,Lexeme %s Found\n",line,yytext);
				}else{
					char s[2] = "a";
					s[0] = ch;
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					return CONST_CHAR;
					
				}
			}
('\\0') 		{	
					char s[2] = "a";s[0] = '\0';
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					
					return CONST_CHAR;
				}
('\\a') 		{
					char s[2] = "a";s[0] = '\a';
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					return CONST_CHAR;
				}
('\\b') 		{
					char s[2] = "a";s[0] = '\b';
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					return CONST_CHAR;
				}
('\\n') 		{
					char s[2] = "a";s[0] = '\n';
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					return CONST_CHAR;
				}
('\\t') 		{
					char s[2] = "a";s[0] = '\t';
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					return CONST_CHAR;
				}
('\\f') 		{
					char s[2] = "a";s[0] = '\f';
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					return CONST_CHAR;
				}
('\\r') 		{
					char s[2] = "a";s[0] = '\r';
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					return CONST_CHAR;
				}
('\\v') 		{
					char s[2] = "a";s[0] = '\v';
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					return CONST_CHAR;
				}
('\\\\') 		{
					char s[2] = "a";s[0] = '\\';
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					return CONST_CHAR;
				}
('\\\"') 		{
					char s[2] = "a";s[0] = '\"';
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					return CONST_CHAR;
				}
('\\\'') 		{
					char s[2] = "a";s[0] = '\'';
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(s);
					p->type = string("char");
					
					yylval = p;
					return CONST_CHAR;
				}
[+-]			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return ADDOP;
				}
[\*/%]			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;	
					return MULOP;
				}
"++"			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;	
					return INCOP;
				}
"--"			{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;	
					return DECOP;
				}
"<"|"<="|">"|">="|"=="|"!=" {
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return RELOP;
				}
"="				{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return ASSIGNOP;
				}
"&&"|"\|\|"		{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return LOGICOP;
				}
"&"|"\|"|"~"|"<<"|">>"  {
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return BITOP;
				}
"!"				{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return NOT;
				}
"("				{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return LPAREN;
				}
")"				{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return RPAREN;
				}
"{"				{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return LCURL;
				}
"}"				{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return RCURL;
				}
"["				{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return LTHIRD;
				}
"]"				{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;
					return RTHIRD;
				}
","				{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;	
					return COMMA;
				}
";"				{
					SymbolInfo *p = new SymbolInfo[1];
					p->name = string(yytext);
					
					yylval = p;	
					return SEMICOLON;
				}
\"(.|("\\\n"))*\"	{
					//Handle string function
					HandleString(yytext,true);
				}
("/\*"(.|\n)*"\*/")|("//"(.|"\\\n")*\n)	{
					//Handle comment function
					multiComment(yytext);
				}
{D}+(_|{L})+	{
					errors++;
					fprintf(errorOut,"\nLine No. %d : Invalid prefix on ID or invalid suffix on Number %s Found\n",line,yytext);
				}
'..+'			{
					errors++;
					char mess[100] = "";
					if(strlen(yytext) == 4 && yytext[1] == '\\')
						strcpy(mess,"Unterminated character");
					else	strcpy(mess,"Multi character constant error");
					fprintf(errorOut,"\nLine No. %d : %s %s Found\n",line,mess,yytext);
				}
''				{
					errors++;
					fprintf(errorOut,"\nLine No. %d : Empty character constant error %s\n Found",line,yytext);
				}
'.[^']			{
					errors++;
					fprintf(errorOut,"\nLine No. %d : Unterminated character %s\n",line,yytext);
				}
\"([^"]|(\\\n))*[^"]	{
					errors++;
					HandleString(yytext,false);
				}
"/\*"([^*/]|\n)*[^*/]	{
					errors++;
					fprintf(errorOut,"\nLine No. %d : Unterminated comment %s Found\n",line,yytext);
				}
{D}*[.]+{D}*[.]+{D}*	{
					errors++;
					fprintf(errorOut,"\nLine No. %d : Too many decimal point %s\n",line,yytext);
				}

[+-]?{D}*(\.)?{D}+[eE][+-]?{D}*[.]+{D}* {
					errors++;
					fprintf(errorOut,"\nLine No. %d : Ill formed number %s\n",line,yytext);
				}
.				{	fprintf(errorOut,"\nLine No. %d : Unrecognised Character %s\n",line,yytext);}
