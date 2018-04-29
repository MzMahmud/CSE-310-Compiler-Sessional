class SymbolTable{
    ScopeTable *scopes,*tail;//linked list of scope table
    int numScopes;

    int n;//number of buckets in each hash table

public:
    ScopeTable *currentScope;
    int getCurrent(){return currentScope->ID;}

    SymbolTable(int _n = DefaultBucketSize){
        //initially makes a global scope
        n = _n;
        numScopes = 0;

        scopes = new ScopeTable(n,NULL);//creates Global scope
        scopes->next = scopes->prev = NULL;//first entyr's next = prev = null

        tail   = scopes;
        currentScope = scopes;//global scope element is the current scope
    }

    int EnterScope(){
        ScopeTable *newEntry
                    = new ScopeTable(n,currentScope);

        //Tail <-> newEntry -> NULL
        newEntry->prev = tail;
        newEntry->next = NULL;
        tail->next = newEntry;

        tail = newEntry;
        currentScope = newEntry;

        numScopes++;

        return getCurrent();//return the ID of Current Scope
    }
    int ExitScope(){//to remove current scope
        if(!numScopes)  return -1;

        int exitedScope = getCurrent();//current scope is the exited scope

        //A <-> B <-> C(tail) -> --
        ScopeTable *toDelete = currentScope;
        currentScope = currentScope->parentScope;

        if(toDelete == tail){
            tail->prev->next = NULL;
            tail = tail->prev;
        }else{
            toDelete->prev->next = toDelete->next;
            toDelete->next->prev = toDelete->prev;
        }

        free(toDelete);
        return exitedScope;
    }

    bool Insert(SymbolInfo symbol){
        symbol.setScope(getCurrent());
        return currentScope->Insert(symbol);
    }

    bool Remove(SymbolInfo symbol){
        return !(currentScope->Delete(symbol)).containsNull();
        //if Delete() contains Null Then Not removed
    }

    SymbolInfo* Lookup(SymbolInfo symbol){
        ScopeTable *searchingScope = currentScope;
        SymbolInfo *item;
        while(searchingScope != NULL){
            item = searchingScope->Lookup(symbol);

            if(item != NULL){//if symbol exists in searching scope
                return item;
            }else{
                searchingScope = searchingScope->parentScope;
            }
        }

        return NULL;//not even found in Global Scope
    }

    void PrintCurrentScopeTable(){
        printf("\n--CURRENT SCOPES--\n");
        currentScope->Print();
    }
    void PrintAllScopeTable(){
        ScopeTable *head = scopes;
        printf("\n--ALL SCOPES--\n");
        while(head){
            printf("\n::Scope#%d::\n",head->ID);
            head->Print();
            head = head->next;
        }
    }
};
