#define NullString "Null"
class SymbolInfo{
public:
    string name,type,state,para;
    int scope;

    SymbolInfo *next;
    SymbolInfo(){next = NULL;scope = 0;type = "int";state = "";para = "";}
    SymbolInfo(string a,string b,int _scope = 0){name = a;type = b;next = NULL;scope = _scope;state = "";para = "";}
    SymbolInfo(string a,string b,string c,string d){name = a;type = b;next = NULL;scope = 0;state = c;para = d;}
    string getName() {return name;}
    string getType() {return type;}
    int    getScope(){return scope;}
    void   setName(string a){name = a;}
    void   setType(string a){type = a;}
    void   setScope(int a)  {scope = a;}
    bool operator==(SymbolInfo a){return (a.name == name);}
    SymbolInfo& operator=(SymbolInfo &a){
        name  = a.getName();
        type  = a.getType();
        state = a.state;
        para  = a.para;
        return *this;
    }
    bool containsNull(){return name == NullString && type == NullString;}
};
