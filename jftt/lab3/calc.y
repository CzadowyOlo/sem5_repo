%{
#include <iostream>   
#include <string> 
#include <math.h>
#include <stdio.h>
#include "../arithmetics.hpp"
#define BASE 1234577

extern int yylex (void);
extern int yyparse();
void yyerror (std::string dup);
std::string postfix = "";
%}

/* Bison declarations. */

%define api.value.type {int}
%token NUM
%token LEFT_BRACE
%token RIGHT_BRACE
%token ERR
%token MINUS
%token PLUS
%token MULT
%token DIV
%token POW
%type exp
%type value
%type line


%left MINUS PLUS
%left MULT DIV
%left NEG /* negation--unary minus */
%nonassoc POW /* exponentiation */

%% /* The grammar follows. */
input: 
    %empty
    | input line 
;
line: 
    exp '\n' { 
      std::cout << "Notation: " << postfix << std::endl;
      std::cout << "Result: " << $1 << std::endl;
      postfix = "";
    }
    | error '\n' { 
      yyerrok ;
    }
;

exp:
    value { $$ = $1; postfix += std::to_string($1) + " "; }
    | MINUS MINUS exp {$$ = $3;}
    | MINUS LEFT_BRACE exp RIGHT_BRACE %prec NEG { $$ = _neg(-$3, BASE); postfix += "~ "; }
    | LEFT_BRACE exp RIGHT_BRACE { $$ = $2; }
    | exp PLUS exp { $$ = _add($1, $3, BASE); postfix += "+ ";}
    | exp MINUS exp { $$ = _sub($1, $3, BASE); postfix += "- ";}
    | exp MULT exp { $$ = _mul($1, $3, BASE); postfix += "* ";}
    | exp DIV exp {       
        int out = _div($1, $3, BASE);
        if (out == -1){
            yyerror("nieodwracalna w base: " + std::to_string(BASE));
            YYERROR;
        } else {
            $$ = out; 
            postfix += "/ ";
        } 
        }
    | exp POW powexp { $$ = _pow($1, $3, BASE); postfix += "^ "; }
;

value: 
    MINUS MINUS value {$$ = $3; printf("usunieto minusy ");}
    | NUM { $$ = $1 % BASE; }
    | MINUS value {$$ = _neg(-$2, BASE);}


powexp:
    powvalue { $$ = $1; postfix += std::to_string(abs($1)) + " "; }
    | LEFT_BRACE powexp RIGHT_BRACE { $$ = $2; }
    | MINUS LEFT_BRACE powexp RIGHT_BRACE %prec NEG { $$ = _neg(-$3, BASE-1); postfix += "~ "; }
    | powexp PLUS powexp { $$ = _add($1, $3, BASE-1); postfix += "+ ";}
    | powexp MINUS powexp { $$ = _sub($1, $3, BASE-1); postfix += "- ";}
    | powexp MULT powexp { $$ = _mul($1, $3, BASE-1); postfix += "* ";}
    | powexp DIV powexp {       
        int out = _div($1, $3, BASE - 1);
        if (out == -1){
            yyerror("nieodwracalna w base:" + std::to_string(BASE-1));
            YYERROR;
        } else {
            $$ = out; 
            postfix += "/ ";
        } 
        }



powvalue: 
    NUM { $$ = $1 % (BASE-1); }
    | MINUS NUM %prec NEG { $$ = _neg(-$2, (BASE-1)); postfix += "~"; }


%%
void yyerror(std::string s){
  std::cout << "Błąd: " << s <<std::endl;
}
int main(){
  yyparse();
  return 0;
}