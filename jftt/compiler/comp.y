// Aleksander Głowacki, Projekt "one-shot compilator"
%{
#include <iostream>   
#include <string> 
#include <math.h>
#include <stdio.h>
#include "../arithmetics.hpp"
#include <cstdlib> 
#include <vector>
#include <map>
#include <fstream>
#define YYDEBUG 1

extern int yylineno;
extern int yylex (void);
extern int yyparse();
void yyerror (std::string s);
extern FILE *yyin;
FILE *fout;     
// Plik wyjściowy z kodem asma



size_t com1_len = 0;
size_t com2_len = 0;

string  program = "";
string dupa = ""; // kod assemblera w zmiennej dupa
string cond = "";
string com1 = "";
string com2 = "";

%}
%code requires {
  #include <string>
}


/* Bison declarations. */
%define parse.error verbose

%define api.value.type {std::string}

%token NUM
%token IDENTIFIER
%token ASSIGN
%token NEQ LEQ GEQ
%token PROCEDURE IS_VAR IS_BEGIN BEGINN END PROGRAM_IS_VAR PROGRAM_IS_BEGIN IF THEN ELSE ENDIF WHILE DO ENDWHILE REPEAT UNTIL READ WRITE

%left '-' '+'
%left '*' '/'
%left '%'

%%
program_all:
    procedures main {size_t proc_len = count($1.begin(), $1.end(), '\n');
                    program = "JUMP " + to_string(proc_len+1) + "\n" +  $1 + $2 + "HALT\n"; k++;}

procedures:
    procedures PROCEDURE proc_head IS_VAR declarations BEGINN commands END {p.clear(); p_arg.clear(); initializations.clear();// czyścimy zmienne pomocnicze
                                                                            id_stack.clear(); proc_eval.clear();
                                                                            procs[procs_stack.back()].linend = p_len;
                                                                            $$ += $7 + "JUMPI " + to_string(p_len) + "\n";
                                                                            p_len++; k++; proc_counter++; decstate = 0;
                                                                            procstate=0;}
|   procedures PROCEDURE proc_head IS_BEGIN commands END    {p.clear(); p_arg.clear(); initializations.clear(); 
                                                            id_stack.clear(); proc_eval.clear();// czyścimy zmienne pomocnicze
                                                            procs.rbegin()->second.linend = p_len;  
                                                            $$ += $5 + "JUMPI " + to_string(p_len) + "\n";
                                                            p_len++; k++; proc_counter++; decstate =0;
                                                            procstate=0;}
|   %empty {}


main:
    PROGRAM_IS_VAR declarations BEGINN commands END {$$ = $4;}
|   PROGRAM_IS_BEGIN commands END   {$$ = $2;}

commands:
    commands command {$$ += $2;}
|   command {$$ = $1;}



command:
    IDENTIFIER ASSIGN expression ';'                {cond = ""; initializations.push_back($1); if(errornodec($2, yylineno,loop)!= ""){
                        yyerror(errornodec($2, yylineno, loop)); 
                        YYERROR;
                    }assign_val(cond, $1); $$ = $3 + cond; }


|   IF condition THEN commands ELSE commands ENDIF  {k+=1; cond = $2; com1 = $4; com2 = $6; 
                                                    com1_len = count(com2.begin(), com2.end(), '\n');
                                                    cond += to_string(k-com1_len) + '\n';
                                                    //update(com1); 
                                                    update(com2, k-com1_len);
                                                    $$ = cond + com1 + "JUMP " + to_string(k) +"\n"+ com2; 
                                                    //proc_eval.clear();
                                                    }

|   IF condition THEN commands ENDIF                {cond = $2; com1 = $4; cond += to_string(k) + "\n"; $$ = cond + com1;}

|   WHILE {loop++;} condition DO commands ENDWHILE            { k+=1; cond = $3; com1 = $5; com1_len = count(cond.begin(), cond.end(), '\n'); 
                                                    cond +=  to_string(k) + "\n"; 
                                                    com2_len = count(com1.begin(), com1.end(), '\n');
                                                    //update(com1);
                                                    $$ = cond + com1 + "JUMP " + to_string(k-com1_len-com2_len - 2) + "\n";
                                                    loop = 0;}

|   REPEAT {loop++;} commands UNTIL condition ';'             { block_until(cond, $3, $5); $$ = cond; loop = 0;}
|   proc_head ';'                                   {{if ($1 == ""){
                                                        yyerror(" Wywołano niezadeklarowaną procedurę w lini "+to_string(yylineno)+" !\n");
                                                        YYERROR;
                                                    }
                                                    else {
                                                        $$ = $1;
                                                    }
                                                                    }}



|   READ IDENTIFIER ';'                             {cond = "";initializations.push_back($2); if(errornodec($2, yylineno,loop)!= ""){
                        yyerror(errornodec($2, yylineno,loop)); 
                        YYERROR;
                    }
                    read_val(cond, $2); $$ = cond; }
|   WRITE value ';'                                 {cond = ""; write_val(cond, $2);$$ = cond;}



proc_head:
    IDENTIFIER '(' declarations_ofprocedure ')' { cond = callprocedure($1); procstate++;
    if(cond == "D"){
        yyerror("procedura wywołana na niezadeklarowanej zmiennej: " + id_stack.back() + " ,w lini: " + to_string(yylineno));
        YYERROR;} 
    if(cond == "O"){
        yyerror("redeklaracja procedury: " + $1 + " w lini: " + to_string(yylineno));
        YYERROR;}
    $$ = cond;
    procstate+1;}

declarations_ofprocedure: //cztery sytuacje: ispros isvar | isproc prochead | ismain isvar |ismain prochead
    declarations_ofprocedure ',' IDENTIFIER     {p.insert(pair<string,int>($3,p_len)); p_len++; id_stack.push_back($3);
                                        if(errorredecpro($3, yylineno)!= ""){
                        yyerror(errorredecpro($3, yylineno)); 
                        YYERROR;
                    }}

|   IDENTIFIER                      { p.insert(pair<string,int>($1,p_len)); p_len++; 
                                    id_stack.push_back($1); 
                                    if(errorredecpro($1, yylineno)!= ""){
                        yyerror(errorredecpro($1, yylineno)); 
                        YYERROR;
                    }
                                    }

declarations: //cztery sytuacje: ispros isvar | isproc prochead | ismain isvar |ismain prochead
    declarations ',' IDENTIFIER     {p.insert(pair<string,int>($3,p_len)); p_len++; id_stack.push_back($3);
                                        if(errorredec($3, yylineno)!= ""){
                        yyerror(errorredec($3, yylineno)); 
                        YYERROR;
                    }}

|   IDENTIFIER                      { p.insert(pair<string,int>($1,p_len)); p_len++; 
                                    id_stack.push_back($1); decstate++;
                                    if(errorredec($1, yylineno)!= ""){
                        yyerror(errorredec($1, yylineno)); 
                        YYERROR;
                    }
                                    }

expression:
    value               {cond = ""; set_val(cond, $1); $$ = cond;}
|   value '+' value     {cond = ""; add(cond, $1, $3); $$ = cond;}
|   value '-' value     {cond = ""; sub(cond, $1, $3); $$ = cond;}
|   value '*' value     {cond = ""; mul(cond, $1, $3); $$ = cond;}
|   value '/' value     {cond = ""; div(cond, $1, $3); $$ = cond;}
|   value '%' value     {cond = ""; mod(cond, $1, $3); $$ = cond;}


condition:
    value '=' value     {cond = ""; is_equal(cond, $1, $3); $$ = cond ;}
|   value '>' value     {cond = ""; is_greater(cond, $1, $3); $$ = cond ;}
|   value '<' value     {cond = ""; is_less(cond,  $1, $3); $$ = cond;}
|   value GEQ value     {cond = ""; is_gequal(cond,  $1, $3); $$ = cond;}
|   value LEQ value     {cond = ""; is_lequal(cond,  $1, $3); $$ = cond;}
|   value NEQ value     {cond = ""; is_notequal(cond, $1, $3); $$ = cond;}


value:
    NUM         {}
|   IDENTIFIER  {  if(errornodec($1, yylineno, loop)!= ""){
                        yyerror(errornodec($1, yylineno,loop)); 
                        YYERROR;
                    }
                }

%%

void yyerror(std::string s){
  std::cout << "\nERROR: " << s << std::endl;
}
//cipa
int main(int argc, char const * argv[]){
  
    if(argc < 3){
        cout << "Za mała liczba argumentów!" << endl;
        return -1;
    }

    FILE *data;
    data = fopen( argv[1], "r" );
    if( !data ){
        cout << "Nie ma takiego pliku!" << endl; 
        return -1;
    }
    yyin = data;

    ofstream out(argv[2]);

    //yydebug = 1; //    
    yyparse();
    
    cout << endl;

    out << program; //string program zawira kod assm
    fclose(data);
    //fclose(out);
    return 0;
}
