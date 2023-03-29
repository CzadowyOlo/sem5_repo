%option noyywrap
%option yylineno
%{
    #include "comp.tab.hpp"
    #include <iostream>
    #include <cstdlib> // for atoi
    #include <string> 

    int yylex();
%}


NUMBER  0|[1-9][0-9]*
ID      [_a-z]+
KOM     \[([^\]]|\n)*\]
ENDL    [ \t\n\r]+
ENDL2    [ \t\n\r]*

%%
{KOM}  ;
{ENDL}  ;
"("         {return '(';}
")"         {return ')';}
","         {return ',';}
";"         {return ';';}
"+"         {return '+';}
"-"         {return '-';}
"*"         {return '*';}
"/"         {return '/';}
"%"         {return '%';}
"="         {return '=';}
">"         {return '>';}
"<"         {return '<';}
"!="        {return NEQ;}
">="        {return GEQ;}
"<="        {return LEQ;}
":="        {return ASSIGN;}

"IS"{ENDL2}{KOM}*{ENDL2}"VAR"        {return IS_VAR;}
"IS"{ENDL2}{KOM}*{ENDL2}"BEGIN"                     {return IS_BEGIN;}
"PROGRAM"{ENDL2}{KOM}*{ENDL2}*"IS"{ENDL2}{KOM}*{ENDL2}*"VAR"      {return PROGRAM_IS_VAR;}
"PROGRAM"{ENDL2}{KOM}*{ENDL2}*"IS"{ENDL2}{KOM}*{ENDL2}*"BEGIN"    {return PROGRAM_IS_BEGIN;}

"PROCEDURE"         {return PROCEDURE;}
"BEGIN"             {return BEGINN;}
"END"               {return END;}
"IF"                {return IF;}
"THEN"              {return THEN;}
"ELSE"              {return ELSE;}
"ENDIF"             {return ENDIF;}
"WHILE"             {return WHILE;}
"DO"                {return DO;}
"ENDWHILE"          {return ENDWHILE;}
"REPEAT"            {return REPEAT;}
"UNTIL"             {return UNTIL;}
"READ"              {return READ;}
"WRITE"             {return WRITE;}


{NUMBER}    {yylval = std::string(yytext); return NUM;}
{ID}        {yylval = std::string(yytext); return IDENTIFIER;}

   
.           {return(yytext[0]);}

%%