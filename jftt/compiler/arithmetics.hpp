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
};       // Structure variable 
extern int loop;
extern map<string, proc_struct> procs;
extern vector<string> p_arg;
extern vector<size_t> proc_eval;
extern vector<string> id_stack;
extern vector<string> initializations;
extern vector<string> procs_stack;
extern size_t proc_counter;
extern map<string, int> p;
extern size_t p_len;
extern size_t k;
extern size_t decstate;
extern size_t k;
extern size_t cond_state; // 0 - not NUM NUM, 1 - NUM NUM always true, 2 - NUM NUM always false
extern size_t procstate;

bool is_init(string val);
bool is_p_arg(string val);

void update(string& command, size_t starting_k);

void sub       (string& dupa, string v1, string v2);
void add       (string& dupa, string v1, string v2);
void mul       (string& dupa, string v1, string v2);
void div       (string& dupa, string v1, string v2);
void mod       (string &dupa, string v1, string v2);

void write_val (string& dupa, string val);
void read_val  (string& dupa, string val);
void assign_val(string& dupa, string val);
void set_val   (string& dupa, string val);
void block_until (string& dupa, string comm, string cond);

void is_greater   (string& dupa, string v1, string v2);
void is_equal   (string& dupa, string v1, string v2);
void is_notequal   (string& dupa,  string v1, string v2);
void is_less(string& dupa, string v1, string v2);
void is_lequal(string& dupa, string v1, string v2);
void is_gequal(string& dupa, string v1, string v2);

string errornodec(string val, int line, int loop);
string errorredec(string val, int line);
string callprocedure(string name);
string errorredecpro(string val, int line);