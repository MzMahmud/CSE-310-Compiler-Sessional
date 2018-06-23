%{
#include<bits/stdc++.h>
using namespace std;
#include "SymbolInfo.cpp"
#include "ScopeTable.cpp"
int ScopeTable::objCount = 1;//initialize static variable
#include "SymbolTable.cpp"

//yylval type
#define YYSTYPE SymbolInfo *

int yyparse(void);
int yylex(void);

extern FILE *yyin;
extern int errors;
extern int yylineno;
extern char* yytext;

string dataType = "";

FILE* logOut;
FILE* errorOut;

//the symbol table
SymbolTable* table = new SymbolTable(100);

vector<string> decList;
vector< pair<string,string> > varList;

void yyerror(char *s){
	errors++;
	fprintf(errorOut,"Error At line %3d :  %s\n\n",yylineno,s);
}

%}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE
%token ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP BITOP NOT
%token LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON
%token ID CONST_INT CONST_FLOAT CONST_CHAR STRING PRINTLN
%nonassoc ONLY_IF
%nonassoc ELSE

%%
start : program							{
											fprintf(logOut,"At line no: %d start : program\n\n",yylineno);
											$$ = new SymbolInfo[1]; 
											$$->name = $1->name;
											fprintf(logOut,"%s\n\n",$$->name.c_str());
											table->PrintCurrentScopeTable(logOut);
										} 
	  ;

program : program unit 					{	
											fprintf(logOut,"At line no: %d program : program unit\n\n",yylineno);
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name;
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	| unit								{
											fprintf(logOut,"At line no: %d program : unit\n\n",yylineno);
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	;
	
unit : var_declaration					{
											fprintf(logOut,"At line no: %d unit : var_declaration\n\n",yylineno);
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
     | func_declaration					{
											fprintf(logOut,"At line no: %d unit : func_declaration\n\n",yylineno);
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
     | func_definition					{
											fprintf(logOut,"At line no: %d unit : func_definition\n\n",yylineno);
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON			{
											string state = "",para = "";
											state = "dec";
											for(int i = 0;i < decList.size();i++){
												para = para + decList[i];	
											}
											SymbolInfo s = SymbolInfo($2->name,$1->type,state,para);
											SymbolInfo*p = table->Lookup(s);
											if(p == NULL){
												table->Insert(s);
												//table->PrintCurrentScopeTable(logOut);
											}else{
												
												if( (p->type+p->para) != (s.type+s.para) ){
													errors++;
													fprintf(errorOut,"Error at line %3d:  ",yylineno);
													fprintf(errorOut,"conflicting types for '%s'\n\n",$ID->name.c_str());
												}
											}
											decList.clear();										
																						
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + " " +  $2->name + $3->name
													  +$4->name + $5->name + $6->name + "\n" ;
											
											$2->type = $1->type;
											  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
		| type_specifier ID LPAREN RPAREN SEMICOLON			{
											SymbolInfo s = SymbolInfo($2->name,$1->type,"dec","");
											SymbolInfo*p = table->Lookup(s);
											if(p == NULL){
												table->Insert(s);
												//table->PrintCurrentScopeTable(logOut);
											}else{
												
												if( (p->type) != (s.type) ){
													errors++;
													fprintf(errorOut,"Error at line %3d:  ",yylineno);
													fprintf(errorOut,"conflicting types for '%s'\n\n",$ID->name.c_str());
												}
											}
											decList.clear();
											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + " " + $2->name + $3->name
													  +$4->name + $5->name + "\n" ;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN{											
											string state = "",para = "";
											state = "def";
											for(int i = 0;i < decList.size();i++){
												para = para + decList[i];	
											}
											
											SymbolInfo s = SymbolInfo($ID->name,$type_specifier->type,state,para);
											SymbolInfo*p = table->Lookup(s);
											
											
											if(p == NULL){
												table->Insert(s);
												//table->PrintCurrentScopeTable(logOut);
											}else{
												if(p->state == "dec"){
													string a = p->type + p->para;
													string b = s.type + s.para;
													if(a != b){		
														errors++;
														fprintf(errorOut,"Error at line %3d:  ",yylineno);
														fprintf(errorOut,"conflicting types for '%s'\n\n",$ID->name.c_str());
													}else{
														
														p->state = "def";
														
													}
												}else if(p->state == "def"){
													errors++;
													fprintf(errorOut,"Error at line %3d:  ",yylineno);
													fprintf(errorOut,"redefinition of function '%s'\n\n",$ID->name.c_str());
												}
											}
											decList.clear();
										}compound_statement		{

											$$ = new SymbolInfo[1];
																				
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n");  
											$$->name = $type_specifier->name + " " + $ID->name + "("
													  +$parameter_list->name + ")" + "\n" + $compound_statement->name;  
													  
											
											
											
											
											fprintf(logOut,"%s\n\n",$$->name.c_str());
											
											table->ExitScope();
										}
		| type_specifier ID LPAREN RPAREN compound_statement			{
											
											SymbolInfo s = SymbolInfo($ID->name,$type_specifier->type,"def","");
											SymbolInfo*p = table->Lookup(s);
											if(p == NULL){
												table->Insert(s);
												//table->PrintCurrentScopeTable(logOut);
											}else{
												
												if( (p->type) != (s.type) ){
													errors++;
													fprintf(errorOut,"Error at line %3d:  ",yylineno);
													fprintf(errorOut,"conflicting types for '%s'\n\n",$ID->name.c_str());
												}
											}
											decList.clear();
											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + " " + $2->name + $3->name
													  +$4->name + "\n" + $5->name ;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		;				


parameter_list  : parameter_list COMMA type_specifier ID	{
											
											varList.push_back(make_pair($ID->name,$type_specifier->type));
											decList.push_back($3->type);
											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"parameter_list  : parameter_list COMMA type_specifier ID\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name
													  + " " + $4->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
		| parameter_list COMMA type_specifier				{
											
											decList.push_back($3->type);
											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"parameter_list  : parameter_list COMMA type_specifier\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name + " " ;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		| type_specifier ID				{
 											varList.push_back(make_pair($ID->name,$type_specifier->type)); 											
 											decList.push_back($1->type);
 											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"parameter_list  : type_specifier ID\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + " " + $2->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
		| type_specifier				{
											
											decList.push_back($1->type);
											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"parameter_list  : type_specifier\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + " " ;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		;

 		
compound_statement : LCURL{
											$$ = new SymbolInfo[1];
											table->EnterScope();
											for(int i = 0;i < varList.size();i++){
												table->Insert(SymbolInfo(varList[i].first,varList[i].second));
											}
											varList.clear();
											decList.clear();
}statements{table->PrintCurrentScopeTable(logOut);table->ExitScope();} RCURL 	{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"compound_statement : LCURL statements RCURL\n\n");
											$$ = new SymbolInfo[1];
											$$->name = "{\n" + $statements->name + "}\n";  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		    | LCURL RCURL				{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"compound_statement : LCURL RCURL\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + "\n" + $2->name + "\n";  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON				{
											for(int i = 0;i < decList.size();i++){
												int l = decList[i].length();
												//cout <<  decList[i] << endl;
												string t = $1->type;
												SymbolInfo symbol = SymbolInfo(decList[i],$1->type);
												if(table->LookupCurrent(symbol) == NULL){
													if(decList[i].at(l-1) == '*'){
														t = t + "*";
														decList[i].erase(l-1);
													}
													
													//cout  << decList[i] << " " << t << endl;
														
													table->Insert(SymbolInfo(decList[i],t));
													
												}else{
													
													errors++;
													fprintf(errorOut,"Error at line %3d :  Redeclration of '%s'\n\n",yylineno,decList[i].c_str());												
												}
											}
											decList.clear();
											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"var_declaration : type_specifier declaration_list SEMICOLON\n\n");
											
											$$ = new SymbolInfo[1];
											$$->name = $1->name + " " + $2->name + $3->name + "\n";  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
											
											//table->PrintCurrentScopeTable(logOut);
											
										}
 		 ;
 		 
type_specifier	: INT					{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"type_specifier	: INT\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		| FLOAT							{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"type_specifier	: FLOAT\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		| VOID							{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"type_specifier	: VOID\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
		| DOUBLE						{
											fprintf(logOut,"At Line no: %d ",yylineno);
											fprintf(logOut,"type_specifier	: DOUBLE\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
		| CHAR						    {
											fprintf(logOut,"At Line no: %d ",yylineno);
											fprintf(logOut,"type_specifier	: CHAR\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		;
 		
declaration_list : declaration_list COMMA ID				{
											decList.push_back($ID->name);
											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"declaration_list : declaration_list COMMA ID\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD				{
 		  									decList.push_back($ID->name+"*");
 		  									
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name
													 + $4->name + $5->name + $6->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		  | ID							{
											decList.push_back($ID->name);
											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"declaration_list : ID\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		  | ID LTHIRD CONST_INT RTHIRD	{
 		  									decList.push_back($1->name+"*");
 		  									
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name
													 + $4->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
 		  ;
 		  
statements : statement					{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"statements : statement\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	   | statements statement			{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"statements : statements statement\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	   ;
	   
statement : var_declaration				{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"statement : var_declaration\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	  | expression_statement			{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"statement : expression_statement\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	  | compound_statement				{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"statement : compound_statement\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement	{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n");
											string a,b;
											a = $3->name;a.erase(a.length()-1);
											b = $4->name;b.erase(b.length()-1);
											
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + a
													 + b 		+ $5->name + $6->name + "\n" +$7->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	  | IF LPAREN expression RPAREN statement %prec ONLY_IF			{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"statement : IF LPAREN expression RPAREN statement\n\n");
											
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name
													 + $4->name + "\n"  + $5->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	  | IF LPAREN expression RPAREN statement ELSE statement		{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"statement : IF LPAREN expression RPAREN statement ELSE statement\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name
													 + $4->name + "\n"     + $5->name 
													 + $6->name + " " +$7->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	  | WHILE LPAREN expression RPAREN statement			{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"statement : WHILE LPAREN expression RPAREN statement\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name
													 + $4->name + "\n"     + $5->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	  | PRINTLN LPAREN ID RPAREN SEMICOLON				{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name
													 + $4->name + $5->name + "\n";  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	  | RETURN expression SEMICOLON		{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"statement : RETURN expression SEMICOLON\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + " " + $2->name + $3->name + "\n";  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	  ;
	  
expression_statement 	: SEMICOLON		{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"expression_statement : SEMICOLON\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + "\n";
											$$->type = "int";  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}	
			| expression SEMICOLON 		{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"expression_statement : expression SEMICOLON \n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + "\n";
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
			;
	  
variable : ID 							{
											$$ = new SymbolInfo[1];
											
											string s = $1->type;
											if(s.rfind("*") != string::npos){
												errors++;
												fprintf(errorOut,"Error at Line %3d : ",yylineno);
												fprintf(errorOut,"Type Mismatch\n\n");
												s.erase(s.length()-1);
												$$->type = s; 
											}else{
												fprintf(logOut,"At line no: %d ",yylineno);
												fprintf(logOut,"variable : ID\n\n");
											
												SymbolInfo* p = table->Lookup(*$1);
												if(p == NULL){
													errors++;
													fprintf(errorOut,"Error at Line %3d :  ",yylineno);
													fprintf(errorOut,"'%s' is not decreared in the scope\n\n",$1->name.c_str());
												}
											
												$$->name = $1->name;
												$$->type = $1->type;  
												fprintf(logOut,"%s\n\n",$$->name.c_str());
											}
										}
	 | ID LTHIRD simple_expression RTHIRD 		{
	 										
											SymbolInfo* p = table->Lookup(*$1);
											if(p == NULL){
												errors++;
												fprintf(errorOut,"Error at Line %3d :",yylineno);
												
												fprintf(errorOut,"'%s' in not decreared in the scope\n\n",$1->name.c_str());
											}
											
											if($3->type != "int"){
 												errors++;
												fprintf(errorOut,"Error at Line %3d : Non-integer Array Index\n\n",yylineno);
											}
																						
											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"variable : ID LTHIRD expression RTHIRD\n\n");
											
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name
													 + $4->name;
													 
											string s = $1->type;
											if(s.rfind("*") == string::npos){
												$$->type = $1->type;
												errors++;
												fprintf(errorOut,"Error at Line %3d : Array Index used in non-array object\n\n",yylineno);
											}else{ 
												string s = $1->type;
												$$->type = s.erase($1->type.length()-1); 
											}
											
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	 ;
	 
expression : logic_expression			{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"expression : logic_expression\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}					
	   | variable ASSIGNOP logic_expression		{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"expression : variable ASSIGNOP logic_expression\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name;
											$$->type = "int"; 
											
											if($1->type != $3->type){
												errors++;
												fprintf(errorOut,"Error At line %3d :  Type Mismatch\n\n",yylineno);
											}
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										} 	
	   ;
			
logic_expression : rel_expression 		{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"logic_expression : rel_expression\n\n");
											$$ = new SymbolInfo[1];
											
										
											
											$$->name = $1->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
		 | rel_expression LOGICOP rel_expression	{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"logic_expression : rel_expression LOGICOP rel_expression\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name;
											$$->type = "int";  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										} 	
		 ;
			
rel_expression	: simple_expression 	{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"rel_expression : simple_expression\n\n");
											$$ = new SymbolInfo[1];
											
											
											
											$$->name = $1->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
		| simple_expression RELOP simple_expression		{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"rel_expression : simple_expression RELOP simple_expression\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name;
											
											$$->type = "int";  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}	
		;
				
simple_expression : term 				{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"simple_expression : term\n\n");
											$$ = new SymbolInfo[1];
											
											
											$$->name = $1->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
		  | simple_expression ADDOP term 	{
											$$ = new SymbolInfo[1];
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"simple_expression : simple_expression ADDOP term\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name;
											
											if($1->type == "float" || $3->type == "float")
												 $$->type = "float";
											else $$->type = "int";
											 
											
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
		  ;
					
term :	unary_expression				{
											$$ = new SymbolInfo[1];
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"term :	unary_expression\n\n");
											
											$$->name = $1->name;
											$$->type = $1->type;   
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
     |  term MULOP unary_expression		{
											$$ = new SymbolInfo[1];
											
											if($2->name == "%"){
												if($1->type != "int" || $3->type != "int"){
													fprintf(errorOut,"Error at Line %3d : Modulus Operation must occur between Integers\n\n",yylineno);
													errors++;
												}
												$$->type = "int";
											}else{
												if($1->type == "float" || $3->type == "float")
												     $$->type = "float";
												else $$->type = "int";
											}
											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"term :	term MULOP unary_expression\n\n");
											$$->name = $1->name + $2->name + $3->name;										
											
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
     ;

unary_expression : ADDOP unary_expression		{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"unary_expression : ADDOP unary_expression\n\n");
											$$ = new SymbolInfo[1];
											$$->name = " " + $1->name + $2->name;
											$$->type = $2->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}  
		 | NOT unary_expression 		{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"unary_expression : NOT unary_expression\n\n");
											$$ = new SymbolInfo[1];
											$$->name = " " + $1->name + $2->name;
											$$->type = "int";  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										} 
		 | factor 						{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"unary_expression : factor\n\n");
											
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
		 ;
	
factor	: variable 						{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"factor	: variable\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											$$->type = $1->type;
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	| ID LPAREN argument_list RPAREN	{
											string argType = "";
											for(int i = 0;i < decList.size();i++){
												argType = argType + decList[i];
											}
											decList.clear();
											
											SymbolInfo* p = table->Lookup(*$ID);
											if(p == NULL){
												errors++;
												fprintf(errorOut,"Error at Line %3d :  ",yylineno);
												fprintf(errorOut,"undefined reference to '%s'\n\n",$1->name.c_str());
											}else if(p->state == ""){
												errors++;
												fprintf(errorOut,"Error at Line %3d :  ",yylineno);
												fprintf(errorOut,"called object '%s' is not a function\n\n",$1->name.c_str());
											}else if(p->type == "void"){
												errors++;
												fprintf(errorOut,"Error at Line %3d :  ",yylineno);
												fprintf(errorOut,"void function '%s' can't be part of an expression\n\n",$1->name.c_str());
											}else if(p->para != argType){
												errors++;
												fprintf(errorOut,"Error at Line %3d :  ",yylineno);
												
												fprintf(errorOut,"argument doesn't match funtion defenation of '%s'\n\n",$1->name.c_str());
											}
							
																		
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"factor	: ID LPAREN argument_list RPAREN\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name + $4->name;  
											$$->type = $1->type;
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	| LPAREN expression RPAREN			{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"factor	: LPAREN expression RPAREN\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name;
											$$->type = $2->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	| CONST_INT 						{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"factor	: CONST_INT\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											$$->type = "int";  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	| CONST_FLOAT						{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"factor	: CONST_FLOAT\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;
											$$->type = "float";  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	| variable INCOP 					{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"variable INCOP\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	| variable DECOP					{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"factor	: variable DECOP\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name;
											$$->type = $1->type;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	;
	
argument_list : arguments				{
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"argument_list : arguments\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
			  |							{
											$$ = new SymbolInfo[1];
											$$->name = " ";
										}
			  ;
	
arguments : arguments COMMA logic_expression	{
											decList.push_back($3->type);
											
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"arguments : arguments COMMA logic_expression\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name + $2->name + $3->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	      | logic_expression			{
	      									decList.push_back($1->type);
	      									
											fprintf(logOut,"At line no: %d ",yylineno);
											fprintf(logOut,"arguments : arguments COMMA logic_expression\n\n");
											$$ = new SymbolInfo[1];
											$$->name = $1->name;  
											fprintf(logOut,"%s\n\n",$$->name.c_str());
										}
	      ;
 
%%
int main(int argc,char *argv[]){
	FILE *input;
	if((input = fopen(argv[1],"r")) == NULL){
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	logOut   = fopen("log.txt","w");
	errorOut = fopen("error.txt","w");
	
	

	yyin = input;
	
	
	yyparse();
	

	//prints lineno and error count in log
	fprintf(logOut,"\nTotal Lines: %d\n",yylineno-1);
	fprintf(logOut,"Total Errors: %d\n",errors);
	fprintf(errorOut,"\nTotal Errors: %d\n",errors);
		

	fclose(logOut);
	fclose(errorOut);
	fclose(input);
	
	
	return 0;
}

