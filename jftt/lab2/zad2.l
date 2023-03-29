%{
    
%}

%x COMMENT
%x STR1
%x STR2
%x STR3

%%

#   {BEGIN(COMMENT);}
'   {ECHO; BEGIN(STR1);}
\"{1}   {ECHO; BEGIN(STR2);}
\"{3}   {ECHO; BEGIN(STR3);}

<COMMENT>{
    "\n"    {ECHO; BEGIN(INITIAL); }
    .       {}
}

<STR1>{
    "'"     {ECHO; BEGIN(INITIAL);}
    [^("'")]    {ECHO;}
}

<STR2>{
    "\""    {ECHO; BEGIN(INITIAL);}
    \\"\""    {ECHO;}
}

<STR3>{
    "\"\"\""    {ECHO; BEGIN(INITIAL);}
    \\"\"\"\""    {ECHO;}
}


%%

int yywrap(){}
int main(){
      yylex();
      //myprintf("%d %d\n", lines, words);
      return 0;
}