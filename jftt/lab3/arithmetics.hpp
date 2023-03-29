#include <iostream> 
#include <vector>
#include <algorithm>    // std::find_if
#include <map>
#include <string>
using namespace std;

void add(FILE *f, map<string, int> p, string v1, string v2);
void write_val(FILE *f, map<string, int> p, string val);
void read_val(FILE *f, map<string, int> p, string val);
void assign_val(FILE *f, map<string, int> p, string val);
