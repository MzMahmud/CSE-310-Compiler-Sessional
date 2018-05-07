#include<bits/stdc++.h>
using namespace std;

int line = 1,errors = 0;

//output files
FILE* logOut;
FILE* tokenOut;

#include "SymbolInfo.cpp"
#include "ScopeTable.cpp"
#include "SymbolTable.cpp"

SymbolTable symbolTable(10);//the symbol table

void multiComment(char a[]){
    for(int i = 0;i < strlen(a);i++)
        if(a[i] == '\n')
            line++;
}
void insertPrint(string token,string lexeme){
	if(symbolTable.Insert(SymbolInfo(lexeme,token)))
		symbolTable.PrintAllScopeTable(logOut);
}
void HandleString(char a[],bool valid){
	string s = "";
	int FoundInline = line;
	for(int i = 0;i < strlen(a);i++){
		if(a[i] == '\"') continue;
		if(a[i] == '\n'){
			line++;
			if(a[i-1] != '\\') valid = false;
		}
		char ch = a[i];
		if(a[i] == '\\'){
		     i++;
		     switch(a[i]){
			case 'n' : ch = '\n';break;
			case 't' : ch = '\t';break;
			case '\\': ch = '\\';break;
			case '\"': ch = '\"';break;
			case 'a' : ch = '\a';break;
			case 'f' : ch = '\f';break;
			case 'r' : ch = '\r';break;
			case 'b' : ch = '\b';break;
			case 'v' : ch = '\v';break;
			case '\'': ch = '\'';break;
			default  : ch = a[i+1];
		    }
		    
		    if(a[i] == '0')  break;
		    if(a[i] == '\n') {line++;continue;}
		}
		s += ch;
	}
	if(valid){
		fprintf(logOut,"Line No. %d : Token <STRING> Lexeme %s Found\n",FoundInline,s.c_str());
		fprintf(tokenOut,"<STRING , %s > ",s.c_str());
		//add to symbol table
		insertPrint("STRING",s);
	}else{
		fprintf(logOut,"Line No. %d : Unterminated String %s\n",FoundInline,yytext);
	}
}







