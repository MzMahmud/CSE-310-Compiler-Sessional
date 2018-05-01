#define DefaultBucketSize 100
class SymbolTable{
    ScopeTable *scopes,*tail;//linked list of scope table
    int numScopes;
    int n;//number of buckets in each hash table

public:
    ScopeTable *currentScope;
    int getCurrent(){return currentScope->ID;}

    SymbolTable(int _n = DefaultBucketSize){
        n = _n;

        //initially makes a global scope
        scopes = new ScopeTable(n,NULL);//creates Global scope
        scopes->next = scopes->prev = NULL;//first entyr's next = prev = null
        numScopes = 1;//global scope

        tail = currentScope = scopes;//global scope element is the current scope
    }

    ~SymbolTable(){free(scopes);}//destructor

    int EnterScope(){
        ScopeTable *newEntry
                    = new ScopeTable(n,currentScope);

        //Tail <-> newEntry -> NULL
        newEntry->next = NULL;
        newEntry->prev = tail;
        tail->next = newEntry;

        tail = currentScope = newEntry;

        numScopes++;

        return getCurrent();//return the ID of Current Scope
    }
    int ExitScope(){//to remove current scope

        if(numScopes == 1)  return -1;//the global scope cant be exited

        int exitedScope = getCurrent();//current scope is the exited scope

        //A <-> B <-> C(tail) -> null
        ScopeTable *toDelete = currentScope;
        currentScope = currentScope->parentScope;

        if(toDelete == tail){
            toDelete->prev->next = NULL;
            tail = toDelete->prev;
        }else{
            toDelete->prev->next = toDelete->next;
            toDelete->next->prev = toDelete->prev;
        }

        numScopes--;
        free(toDelete);

        return exitedScope;
    }

    bool Insert(SymbolInfo symbol){
        symbol.setScope(getCurrent());
        return currentScope->Insert(symbol);
    }

    bool Remove(SymbolInfo symbol){
        //if Delete() contains Null Then Not removed
        return !(currentScope->Delete(symbol)).containsNull();
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
