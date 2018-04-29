using namespace std;
#include <bits/stdc++.h>
#define NullString "Null"
#define DefaultBucketSize 100
#define MAXSIZE 100000
#include "SymbolInfo.cpp"
#include "ScopeTable.cpp"
#include "SymbolTable.cpp"

int main(){
    freopen("input.txt","r",stdin);
    //freopen("output.txt","w",stdout);

    string a;
    getline(cin,a);
    int n;
    char in[MAXSIZE]; strcpy(in,a.c_str());
    strcpy(in,a.c_str());
    sscanf(in,"%d",&n);

    SymbolTable table(n);

    while(1){
        a = "";getline(cin,a);
        if(a.empty()) break;

        strcpy(in,a.c_str()); //cout << in << endl;
        char name[MAXSIZE] = "",type[MAXSIZE] = "",ch;
        sscanf(in,"%c%s%s",&ch,name,type);

        if(ch == 'I'){

            cout << endl << in << endl;
            if(table.Insert(SymbolInfo(name,type))){
               printf("\n\tInserted < %s : %s > into Scope#%d\n\n",name,type,table.getCurrent());
            }

        }else if(ch == 'L'){

            cout << endl << in << endl;
            SymbolInfo *item = table.Lookup(SymbolInfo(name,type));
            if(item == NULL){
                printf("\n\tNot Found\n\n");
            }else{
                printf("\n\tFound at ScopeTable# %d\n\n",item->getScope());
            }

        }else if(ch == 'D'){

            cout << endl << in << endl;
            SymbolInfo *item = table.Lookup(SymbolInfo(name,type));
            if(item == NULL || item->getScope() != table.getCurrent()){
                printf("\n\tNot Found\n\n");
            }else{
                table.Remove(SymbolInfo(name,type));
                printf("\n\tDeleted entry From ScopeTable# %d\n\n",item->getScope());
            }

        }else if(ch == 'P'){

            cout << endl << in << endl;

                 if(name[0] == 'C') table.PrintCurrentScopeTable();
            else if(name[0] == 'A') table.PrintAllScopeTable();

        }else if(ch == 'S'){

            cout << endl << in << endl;
            printf("\n\tNew ScopeTable with id %d created\n\n",table.EnterScope());

        }else if(ch == 'E'){
            cout << endl << in << endl;
            printf("\n\tScopeTable with id %d removed\n\n",table.ExitScope());
        }
    }
    return 0;
}
