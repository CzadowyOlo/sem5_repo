
#include <iostream> 
#include <vector>
#include <algorithm>    // std::find_if
#include <map>
#include <string>

using namespace std;

struct proc_struct
{             // Structure declaration
  size_t args;      // ilość argumentów procedury
  size_t myfirst;   // adres pierwszego wskaźnika  
  size_t start;     // linia w której zaczyna się procedura
  size_t linend;      // adres pod którym zajduje się linia do której chcemy powrócić po wykonaniu procedury
};       // Structure variable / Structure variable 

map<string, proc_struct> procs; //lista procedur nazwa-struktura
vector<string> p_arg; //lista argumentów procedury
vector<size_t> proc_eval; //pomocnicza lista do ustawiania lini skoku do procedury i po powrocie z procedury
vector<string> id_stack; //lista kolejnych zmiennych które były czytane, wywoływane, zmieniane itd
vector<string> initializations; //lista zmiennych, które zostały zainicializowane
vector<string> procs_stack; // lista procedur w kolejności przetwarzania
map<string, int> p; //lista zmiennych które byly deklarowane
size_t decstate = 0; //licznik który określa czy deklarujemy czy wywołujemy procedurę
size_t p_len = 6; //pierwsze miejsca na szynie zarezerwowane do obliczen
size_t k = 1;       // linia kodu maszynowego
size_t cond_state;  // 0 - not NUM NUM, 1 - NUM NUM always true, 2 - NUM NUM always false
bool procedures_end = false;
size_t proc_counter = 0; //licznik procedur do porównania z wielkością mapy procedur
size_t procstate = 0;
int loop = 0;
/**
 * @brief funkcja sprawdza czy id jest argumentem procedury
 * 
 * @param val id
 * @return true 
 * @return false 
 */
bool is_p_arg(string val) {
    for (size_t i = 0; i < size(p_arg); i++) {
        if (val == p_arg[i])
            return true;
    }
    return false;
}
/**
 * @brief sprawdza czy id zostało zainicjalizowane
 * 
 * @param val id
 * @return true 
 * @return false 
 */
bool is_init(string val){
    if (count(initializations.begin(), initializations.end(), val)){
        return true;
    }
    return false;
}

/**
 * @brief funkcja do przetwarzania procheada: deklaracja lub wywołanie
 * 
 * @param name nazwa procedury
 * @return string 
 */
string callprocedure(string name) {
    if (procs.find(name) == procs.end()) {  //deklaracja procedury
        // nie znalazłem czyli dec
        for (auto const& [id, adress] : p) {   
            p_arg.push_back(id); 
            initializations.push_back(id);  // argumenty są z automatu zainicjalizowane        
        }
        proc_struct myfunc;
        myfunc.args = size(p);
        myfunc.myfirst = p_len-myfunc.args;
        myfunc.start = k;
        procs.insert(pair<string,proc_struct>(name,myfunc));
        procs_stack.push_back(name);
        return "";
    } else {
        // znalazłem czyli call
        
        proc_struct x = procs[name];
        size_t id_stack_len = size(id_stack);
        string buf = "";
        string helper = "";
        if(id_stack_len == size(p)){ //sprawdzam czy nie deklaruję drugi raz
            return "O";
        }
        for (size_t i = 0; i < x.args; i++) {
            helper = id_stack[id_stack_len-x.args+i];
            if((count(id_stack.begin(), id_stack.end(), helper))  < 2){ //czy zmienne w wyłowaniu były zadeklarowane
                return "D";
            }
            if(is_p_arg(id_stack[id_stack_len-x.args+i])){ //lokalna czy pointerowa
                buf += "LOAD " + to_string(p[id_stack[id_stack_len-x.args+i]]) + "\n" +
                "STORE " + to_string(x.myfirst + i) + "\n";
            }
            else{
                buf += "SET " + to_string(p[id_stack[id_stack_len-x.args+i]]) + "\n" +
                "STORE " + to_string(x.myfirst + i) + "\n";
            }
            k+=2;
            initializations.push_back(id_stack[id_stack_len-x.args+i]);
        }
        proc_eval.push_back(k);
        k+=3;
        buf +=  "SET " + to_string(k) + "\n" +
                "STORE " + to_string(x.linend) + "\n" +
                "JUMP " + to_string(x.start) + "\n";
        return buf;
    }
}
/**
 * @brief poprawiam linię jumpów w  if-else
 * 
 * @param command body else
 * @param starting_k linia startu commandów w body else
 */
void update(string& command, size_t starting_k){
    string liczba = "";
    size_t pozycja;
    size_t end = command.length();
    //cout<<"did update"<<endl;

    for(size_t i = 0; i < end; i++){
        if(command[i] == '\n'){
            starting_k++;
        }
        if(count(proc_eval.begin(), proc_eval.end(), (starting_k-1))){
            if(command[i] == 'S' && command[i+1] == 'E'){
                while(command[i] != ' '){
                    i++;
                }
            i++;

            while(isdigit(command[i])){
                liczba += command[i];
                command.erase(i, 1);
                //i++;
            }
            pozycja = stoll(liczba) + 1;
            liczba = to_string(pozycja);
            command.insert(i, liczba);
            //cout<<"updated set, k = "<<liczba<<endl;
            liczba = ""; 
            starting_k++;
            i++;
            while(command[i] != '\n'){
                    i++;
                }
            i++;    
            starting_k++;   
            while(command[i] != '\n'){
                    i++;
                }
            i++;    
            starting_k++;  
            while(command[i] != '\n'){
                i++;
            }
            i++;    
            starting_k++; 
               for(int i = 0; i < proc_eval.size(); i++){
                if(proc_eval[i] == (starting_k - 5)){
                    proc_eval[i]++;
                }
            }
            }
         
        }

        if(command[i] == 'J' && command[i+4] != 'I'){

            while(command[i] != ' '){
                i++;
            }
            i++;


            while(isdigit(command[i]) && command[i] != ' ' && command[i] != '\n'){
                liczba += command[i];
                command.erase(i, 1);
                //i++;
            }
            pozycja = stoll(liczba) + 1;
            liczba = to_string(pozycja);
            command.insert(i, liczba);
            liczba = "";
        }
    }
}

void set_val(string &dupa, string val) {
    k++;
    if (isdigit(val[0])){
        dupa = dupa + "SET " + val + "\n";

    }
    else{
        if(is_p_arg(val)){
            dupa = dupa + "LOADI " + to_string(p[val]) + "\n";
        }
        else{
        dupa = dupa + "LOAD " + to_string(p[val]) + "\n";
        }
    }
}

void block_until(string &dupa, string comm, string cond)
{
    if (cond_state == 0)
    { // 0 - not NUM NUM
        string buf = comm + cond;
        size_t buf_len = count(buf.begin(), buf.end(), '\n') + 1;
        dupa = buf + to_string(k - buf_len) + "\n";
    }
    else if (cond_state == 1)
    {        
        k++; 
        size_t comm_len = count(comm.begin(), comm.end(), '\n');
        dupa = comm + "JUMP " + to_string(k - comm_len - 1) + "\n"; 
    }
    else
    { 
        dupa = comm;
    }
}

void add(string &dupa, string v1, string v2)
{
    if (is_p_arg(v1)){         
    v1 = "I " + to_string(p[v1]);
    }
    else if (!isdigit(v1[0])) { 
        v1 = " " + to_string(p[v1]);
    }                           
    
    if (is_p_arg(v2)){              
        v2 = "I " + to_string(p[v2]);
    }
    else if (!isdigit(v2[0])) {     
        v2 = " " + to_string(p[v2]);
    } 

    if (isdigit(v1[0])) {
        if (isdigit(v2[0])) {
            int a = stoll(v1);
            int b = stoll(v2);
            k++;   
            dupa =  "SET " + to_string(a+b) + "\n";
        }
        else {
            
            k += 2;
            dupa = "SET " + v1 + "\n" + 
                   "ADD" + v2 + "\n";
        }
    }
    else {
        if (isdigit(v2[0])) {
            // ID NUM
            k+=2;
            dupa = "SET " + v2 + "\n" + 
                   "ADD" + v1 + "\n"; 
        }
        else {
            k+=2;
            dupa = "LOAD" + v1 + "\n" + 
                   "ADD" + v2 + "\n"; 
        }
    }
}

void sub(string &dupa, string v1, string v2){
   
    if (is_p_arg(v1))
        v1 = "I " + to_string(p[v1]);
    else if (!isdigit(v1[0])) 
        v1 = " " + to_string(p[v1]);
    if (is_p_arg(v2)) 
        v2 = "I " + to_string(p[v2]);
    else if (!isdigit(v2[0])) 
        v2 = " " + to_string(p[v2]);
    if (isdigit(v1[0]))
    {
        if (isdigit(v2[0]))
        {
            long long a = stoll(v1);
            long long b = stoll(v2);
            ;
            k++;
            dupa = "SET " + to_string(a - b) + "\n";
        }
        else
        {
            k += 2;
            dupa = "SET " + v1 + "\n" +
                   "SUB" + v2 + "\n";
        }
    }
    else
    {
        if (isdigit(v2[0]))
        {
            // ID NUM
            k += 4;
            dupa = "SET " + v2 + "\n" +
                   "STORE 1\n" +
                   "LOAD" + v1 + "\n" +
                   "SUB 1\n";
        }
        else
        {
            // ID ID
            k += 2;
            dupa = "LOAD" + v1 + "\n"
                "SUB" + v2 + "\n";
        }
    } 
}

void mul(string &dupa, string v1, string v2){

    if (is_p_arg(v1)) 
        v1 = "I " + to_string(p[v1]);
    else if (!isdigit(v1[0])) 
        v1 = " " + to_string(p[v1]);

    if (is_p_arg(v2)) 
        v2 = "I " + to_string(p[v2]);
    else if (!isdigit(v2[0])) 
        v2 = " " + to_string(p[v2]);
    string buf = "";
    unsigned long long hui = 4294967290; //stała antylimit
    if (isdigit(v1[0]))
    {
        if (isdigit(v2[0])) {
             // NUM NUM

            unsigned long long a = stoull(v1);
            unsigned long long b = stoull(v2);
            if(a >= hui && b >= hui){
                buf =   "SET " + v1 + "\nSTORE 2169\nSET " + v2 + "\nSTORE 2170\n";
            }
            else{
                k++;
                dupa = "SET " + to_string(a * b) + "\n";
                return;
            }
            
        }
        else {   
            if(stoll(v1) == 2){
                dupa = "LOAD" + v2 + "\nADD 0\n";
                k+=2;
                return;
            }            

            buf =   "SET " + v1 + "\nSTORE 2169\nLOAD" + v2 + "\nSTORE 2170\n";
        }
    }
    else
    {
        if (isdigit(v2[0])) {
            
            buf =   "LOAD" + v1 + "\nSTORE 2169\nSET " + v2 + "\nSTORE 2170\n";
        }
        else {
            
            buf =   "LOAD" + v1 + "\nSTORE 2169\nLOAD" + v2 + "\nSTORE 2170\n";                       
        }
    }
    k+=25;
    string help = "";
    string help2 = "";

    help =  help +
            "SET 0\n" +                
            "STORE 2\n" +           
            "LOAD 2170\n" +               
            "HALF\n" +
            "ADD 0\n" +
            "STORE 1\n" +               
            "LOAD 2170\n" +
            "SUB 1\n" +
            "JZERO " + to_string(k-9) + "\n" + 
            "LOAD 2169\n" +
            "ADD 2\n" +
            "STORE 2\n" +
            "LOAD 2169\n" +
            "ADD 0\n" +
            "STORE 2169\n" +
            "LOAD 2170\n" +
            "HALF\n" +
            "STORE 2170\n" +        
            "JPOS " + to_string(k-18) +"\n" +
            "LOAD 2169\nLOAD 2\n";
    dupa = buf + help;        
    //         // a = 3, b = 4
    // help2 = help2 + 
    // "SET 0\n" + "STORE 2\n" + "LOAD 4\n" + "JZERO " + to_string(k+25) + "\nHALF\n" + 
    // "ADD 0\n" + "STORE 1\n" + "LOAD 4\nSUB 1\nJZERO " + to_string(k+18) + "\nLOAD 2\n" + "ADD 3\nSTORE 2\nLOAD 2\nADD 0\nSTORE 3\nLOAD 4\nHALF\n" + 
    // "STORE 4\n" + "JPOS " + to_string(k+7) + "\nLOAD 2\n";
    // k+=25;
}

void div(string &dupa, string v1, string v2)
{
    if (is_p_arg(v1)) 
        v1 = "I " + to_string(p[v1]);
    else if (!isdigit(v1[0])) 
        v1 = " " + to_string(p[v1]);
  
    if (is_p_arg(v2))
        v2 = "I " + to_string(p[v2]);
    else if (!isdigit(v2[0])) 
        v2 = " " + to_string(p[v2]);
 
    string buf = "";
    if (isdigit(v1[0]))
    {
        if (isdigit(v2[0])) {
             
            long long a = stoll(v1);
            long long b = stoll(v2);
            ;
            k++;
            dupa = "SET " + to_string(a / b) + "\n";
            return;
        }
        else {    
            if(stoll(v1) == 2){
                dupa = "LOAD" + v2 + "\nADD 0\n";
                k+=2;
                return;
            }         
            
            dupa =   "SET " + v1 + "\nSTORE 2169\nLOAD" + v2 + "\nSTORE 2170\nSTORE 1\n";
        }
    }
    else
    {
        if (isdigit(v2[0])) {
            if(stoll(v2) == 2){
                dupa = "LOAD" + v1 + "\nHALF\n";
                k+=2;
                return;
            }
            
            dupa =   "LOAD" + v1 + "\nSTORE 2169\nSET " + v2 + "\nSTORE 2170\nSTORE 1\n";
        }
        else {
            
            dupa =   "LOAD" + v1 + "\nSTORE 2169\nLOAD" + v2 + "\nSTORE 2170\nSTORE 1\n";                       
        }
    }
    k+= 36;
    dupa =  "SET 0\nSTORE 2\nSET 1\nSTORE 5\n" +   
            dupa +
            "JZERO " + to_string(k) +"\n" +  
            "SUB 2169\n" +                   
            "JPOS " + to_string(k-17) +"\n" + 
            "LOAD 5\n" +"ADD 5\n" +               
            "STORE 5\n" +
            "LOAD 2170\n" +
            "ADD 2170\n" +
            "STORE 2170\n" +
            "JUMP " + to_string(k-26) +"\n" +  
            "LOAD 5\n" +  
            "HALF\n" +
            "ADD 2\n" +
            "STORE 2\n" +     "SET 1\n" +
            "STORE 5\n" +   
            "LOAD 2170\n" +        
            "HALF\n" +
            "STORE 2170\n" +    
            "LOAD 2169\n" +
            "SUB 2170\n" +
            "STORE 2169\n" +   
            "LOAD 1\n" + "STORE 2170\n" +
            "SUB 2169\n" +        
            "JZERO " + to_string(k-24) +"\n" +
            "LOAD 2\n";
}

void mod(string &dupa, string v1, string v2){
    
    if (is_p_arg(v1))
        v1 = "I " + to_string(p[v1]);
    else if (!isdigit(v1[0])) 
        v1 = " " + to_string(p[v1]);
  

    if (is_p_arg(v2)) 
        v2 = "I " + to_string(p[v2]);
    else if (!isdigit(v2[0])) 
        v2 = " " + to_string(p[v2]);
    
    string buf = "";
    if (isdigit(v1[0]))
    {
        if (isdigit(v2[0])) {
            
            long long a = stoll(v1);
            long long b = stoll(v2);
            ;
            k++;
            dupa = "SET " + to_string(a / b) + "\n";
            return;
        }
        else {            
            
            dupa =   "SET " + v1 + "\nSTORE 2169\nLOAD" + v2 + "\nSTORE 2170\nSTORE 1\n";
        }
    }
    else
    {
        if (isdigit(v2[0])) {
            
            if(stoll(v2) == 2){
                dupa = "LOAD" + v1 + "\nHALF\nADD 0\nSTORE 2169\nLOAD" + v1 + "\nSUB 2169\n";
                k+=6;
                return;
            } 
            
            dupa =   "LOAD" + v1 + "\nSTORE 2169\nSET " + v2 + "\nSTORE 2170\nSTORE 1\n";
        }
        else {
            
            dupa =   "LOAD" + v1 + "\nSTORE 2169\nLOAD" + v2 + "\nSTORE 2170\nSTORE 1\n";                       
        }
    }
    k+= 26;
    dupa =  dupa +
            "JZERO " + to_string(k) +"\n" +  
            "SUB 2169\n" +                  
            "JPOS " + to_string(k-1) +"\n" +      
            "LOAD 2170\n" +   
            "SUB 2169\nJPOS " + to_string(k-11) +"\n" + 
            "LOAD 2170\n" +
            "ADD 2170\n" +
            "STORE 2170\n" +
            "JUMP " + to_string(k-17) +"\n" +  
            "LOAD 2170\nHALF\n" +
            "STORE 2170\n" +   
            "LOAD 2169\n" +
            "SUB 2170\n" +
            "STORE 2169\n" +   
            "LOAD 1\n" +
            "STORE 2170\nSUB 2169\n" +        
            "JZERO " + to_string(k-15) +"\n" +
            "LOAD 2169\n";
}

void write_val(string &dupa, string val) {
    if (isdigit(val[0])) {
        k+=2;
        dupa = "SET " + val + "\n" + "PUT 0 \n";
    }
    else {
        k+=1;
        if (is_p_arg(val)) {
        k+=1;
        dupa = "LOADI " + to_string(p[val]) + "\n" +
                "PUT 0\n";
        }
        else{
        dupa = "PUT " + to_string(p[val]) + "\n";
        }
    }
}

void read_val(string &dupa, string val) {

    if(is_p_arg(val)) {
        k++;
        dupa = "GET 0\nSTOREI " + to_string(p[val]) + "\n";
    }
    else{
        dupa =  "GET " + to_string(p[val]) + "\n";
    }
    k++;
}

void assign_val(string &dupa, string val) {

    if (is_p_arg(val)){
        dupa = "STOREI " + to_string(p[val]) + "\n"; 
    }
    else{
    dupa =  "STORE " + to_string(p[val]) + "\n";
    }
    k++;
}

string pom1 = "";
string pom2 = "";

void is_notequal(string& dupa, string v1, string v2){
   
    cond_state = 0;
    if (isdigit(v1[0]))
    {
        if (isdigit(v2[0]))
        {
            
            long long a = stoll(v1);
            long long b = stoll(v2);
            ;
            if (a != b)
                cond_state = 1;
            else
                cond_state = 2;
        }
        else
        {
            
            sub(pom1, v1, v2);
            sub(pom2, v2, v1);
            dupa = pom1 +                       
                  "JPOS " + to_string(k + 1) + "\n" + 
                  pom2 +                       
                  "JZERO ";
            k += 2; 
        }
    }
    else
    {
        if (isdigit(v2[0]))
        {
            if(stoll(v2) == 0){
                dupa = "LOAD "+to_string(p[v1])+"\nJZERO ";
                k+=2;
                return;
            }
            
            sub(pom2, v1, v2);
            sub(pom1, v2, v1);
            dupa = pom1 +                       
                  "JPOS " + to_string(k + 1) + "\n" + 
                  pom2 +                      
                  "JZERO ";
            k += 2; 
        }
        else
        {
            
            if (is_p_arg(v1)) 
                v1 = "I " + to_string(p[v1]);
            else 
                v1 = " " + to_string(p[v1]);

            if (is_p_arg(v2)) 
                v2 = "I " + to_string(p[v2]);
            else 
                v2 = " " + to_string(p[v2]);

            dupa = "LOAD" + v1 + "\n" +
                  "SUB" + v2 + "\n" +
                  "JPOS " + to_string(k + 5) + "\n" +
                  "LOAD" + v2 + "\n" +
                  "SUB" + v1 + "\n" +
                  "JZERO ";
            k += 6;
        }
    }
}
void is_equal(string& dupa,  string v1, string v2){
    cond_state = 0;

    if (isdigit(v1[0]))
    {
        if (isdigit(v2[0]))
        {
            
            long long a = stoll(v1);
            long long b = stoll(v2);
            ;
            if (a == b)
                cond_state = 1;
            else
                cond_state = 2;
            dupa = "";
        }
        else
        {
            
            sub(pom2, v2, v1);
            sub(pom1, v1, v2);
            dupa =    pom1   +                 
                  "JPOS " + to_string(k + 1) + "\n" + 
                      pom2 +                   
                  "JPOS ";
            k += 2; 
        }
    }
    else
    {
        if (isdigit(v2[0]))
        {
            
            sub(pom1, v2, v1);
            sub(pom2, v1, v2);
            dupa =    pom2   +                  
                  "JPOS " + to_string(k + 1) + "\n" + 
                      pom1 +                   
                  "JPOS ";
            k += 2; 
        }
        else
        {
            
            if (is_p_arg(v1)) 
                v1 = "I " + to_string(p[v1]);
            else 
                v1 = " " + to_string(p[v1]);

            if (is_p_arg(v2)) 
                v2 = "I " + to_string(p[v2]);
            else 
                v2 = " " + to_string(p[v2]);

            dupa = "LOAD" + v1 + "\n" +
                  "SUB" + v2 + "\n" +
                  "JPOS " + to_string(k + 5) + "\n" +
                  "LOAD" + v2 + "\n" +
                  "SUB" + v1 + "\n" +
                  "JPOS ";
            k += 6;
        }
    }
}

void is_greater(string& dupa, string v1, string v2){
    cond_state = 0;
    if (isdigit(v1[0]) && isdigit(v2[0]))
    {
        
        long long a = stoll(v1);
        long long b = stoll(v2);
        ;
        if (a > b)
            cond_state = 1;
        else
            cond_state = 2;
        dupa = "";
    }
    else
    {
        k++;
        sub(pom1, v1, v2);
        dupa = pom1 + "JZERO ";
    }
}
void is_less(string& dupa, string v1, string v2){
    is_greater(dupa, v2, v1);
}
void is_gequal(string& dupa, string v1, string v2){

    cond_state = 0;
    if (isdigit(v1[0]) && isdigit(v2[0]))
    {
        
        long long a = stoll(v1);
        long long b = stoll(v2);
        ;
        if (a >= b)
            cond_state = 1;
        else
            cond_state = 2;
    }
    else
    {
        k++;
        sub(pom1, v2, v1);
        dupa = pom1 +  "JPOS ";
    }
}
void is_lequal(string& dupa, string v1, string v2){
    is_gequal(dupa, v2, v1);
}
/**
 * @brief druga deklaracja zmiennej
 * 
 * @param val id
 * @param line linia
 * @return string 
 */
string errorredec(string val, int line){
    if(decstate == 1 && size(p) != size(id_stack)){
        return "redeklaracja zmiennej: " + id_stack.back() +  " w lini:" + to_string(line) + "!\n"; 
    }
    return "";
}
string errorredecpro(string val, int line){
    if(decstate == 0 && procstate == 0 && size(p) != size(id_stack)){
        return "redeklaracja zmiennej: " + id_stack.back() +  " w lini:" + to_string(line) + "!\n"; 
    }
    return "";
}
/**
 * @brief brak deklaracji
 * 
 * @param val 
 * @param line 
 * @return string 
 */
string errornodec(string val, int line, int loop){
    if(p.find(val) == p.end()){
        return "Użycie niezadeklarowanej zmiennej: " + val + " w lini:" + to_string(line) + "!\n";
    }
    if(!is_init(val)){
        if(loop){
        cout<< "WARN: zmienna mogła nie zostać zainicjalizowana: " + val + " w lini:" + to_string(line) + "!\n";
        }
        else{
            return "Użycie niezainicjowanej zmiennej: " + val + " w lini:" + to_string(line) + "!\n";
        }
    }
    return "";
}

