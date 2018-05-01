#define NullString "Null"
class SymbolInfo{
    string name,type;
    int scope;

public:
    SymbolInfo *next;
    SymbolInfo(){next = NULL;scope = 0;}
    SymbolInfo(string a,string b,int _scope = 0){name = a;type = b;next = NULL;scope = _scope;}
    string getName() {return name;}
    string getType() {return type;}
    int    getScope(){return scope;}
    void   setName(string a){name = a;}
    void   setType(string a){type = a;}
    void   setScope(int a)  {scope = a;}
    bool operator==(SymbolInfo a){return (a.name == name);}
    SymbolInfo& operator=(SymbolInfo &a){
        name = a.getName();
        type = a.getType();
        return *this;
    }
    bool containsNull(){return name == NullString && type == NullString;}
};
