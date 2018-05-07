class ScopeTable{
    SymbolInfo **table;//array of pointers
    int n;//Size of Hash table
    //Hash Function
    int h(string s){
        int hv = 0;
        for(int i = 0;i < s.length();i++)
            hv = (s[i] + (hv << 5) + hv)%n;
        return (hv+n)%n;
    }

public:
    static int objCount;
    ScopeTable *parentScope;//address of parent scope
    ScopeTable *next,*prev;//for linked list implementation

    int ID;

    ScopeTable(int _n,ScopeTable *_parentScope = NULL){
        n = _n;
        parentScope = _parentScope;

        table = new SymbolInfo*[n];//allocates n pointers of SymbolInfo
        for(int i = 0;i < n;i++)
            table[i] = new SymbolInfo[1];//assigns a pointer of SymbolInfo to table[i]

        ID = objCount;//makes the objCount the ID
        objCount++;
    }
    ~ScopeTable(){
        for(int i = 0;i < n;i++)
            delete  table[i];
        delete table;
    }

    bool Insert(SymbolInfo symbol){
        int pos = h(symbol.getName());//Hashes symbol by name to get position of entry

        SymbolInfo *head = table[pos]->next;
        SymbolInfo *prev = table[pos];
        SymbolInfo *newEntry
                    = new SymbolInfo(symbol.getName(),symbol.getType(),ID);

        while(head != NULL){
            //this checks if its already inserted or not
            if( (*head) == symbol)
                return false;//symbol already exists
            prev = head;
            head = head->next;//gets to next,after loop breaks gets to the tail
        }
        //inserts new entry to the tail
        prev->next = newEntry;
        return true;//successfully inserted
    }

    SymbolInfo* Lookup(SymbolInfo symbol){
        int pos = h(symbol.getName());//Hashes symbol by name to get position of entry
        SymbolInfo *head = table[pos];
        while(head != NULL){
            if((*head) == symbol)
                return head;
            head = head->next;
        }
        return NULL;
    }
    SymbolInfo Delete(SymbolInfo symbol){
        SymbolInfo ret(NullString,NullString);
        if(Lookup(symbol) == NULL) return ret;

        int pos = h(symbol.getName());//Hashes symbol by name to get position of entry
        SymbolInfo *head = table[pos]->next;
        SymbolInfo *prev = table[pos];
        while(head != NULL){
            //this checks if its already inserted or not
            if( (*head) == symbol){
                prev->next = head->next;

                //makes the return object
                ret.setName(head->getName());
                ret.setType(head->getType());
                ret.setScope(head->getScope());
                //frees the object
                delete head;
                return ret;
            }
            prev = head;
            head = head->next;//gets to next,after loop breaks gets to the tail
        }
    }
    void Print(FILE* out){//takes the output fine pointer
        for(int i = 0;i < n;i++){
            SymbolInfo *head = table[i]->next;
            if(head == NULL) continue;
            fprintf(out,"\t%d --> ",i);
            while(head != NULL){
                //cout << " < " << head->getName() << " : " << head->getType() << " > ";
		char name[100],type[100];
		strcpy(name,head->getName().c_str());
		strcpy(type,head->getType().c_str());
		fprintf(out," < %s : %s > ",name,type);
            
		head = head->next;
            }
            fprintf(out,"\n");
        }
    }
};
int ScopeTable::objCount = 1;//initialize static variable
