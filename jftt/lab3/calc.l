%option noyywrap
%{
    #include "calc.tab.hpp"
    int yylex();
%}

splitLine \\\n

%%
^#(.|{splitLine})*\n   ;
{splitLine}            ;
[[:blank:]]+                ;
[0-9]+                      { yylval = atoi(yytext); return NUM; }
\+                          { return PLUS; }
\-                           { return MINUS; }
\*                          { return MULT; }
\/                          { return DIV; }
\^                          { return POW; }
\(                          { return LEFT_BRACE; }
\)                          { return RIGHT_BRACE; }
\n                          { return '\n'; }
\.                           { return ERR; }
%%