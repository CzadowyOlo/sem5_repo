%{
    #include <stdbool.h>
    bool displaydoxy = false;
%}

%x COM1 
%x COM2
%x DOC1
%x DOC2
%x INC
%x PRINT

%%
"printf\("    {ECHO; BEGIN(PRINT);}
#    {ECHO; BEGIN(INC);}
\/\*\*|\/\*!    {
    if(displaydoxy){
    {ECHO;}
    }
    else{
        {printf("//start doc1\n"); BEGIN(DOC1);}
    }
}
\/\/\/|\/\/!  {    if(displaydoxy){
    {ECHO;}
    }
    else{
        {printf("//start doc2");BEGIN(DOC2);}
    }}
\/\//[^\/!]   {BEGIN(COM1);}
\/\*/[^\*!]     {printf("//com2 begin"); BEGIN(COM2);}

<PRINT>{
    "\);" {ECHO; printf(" // escaped print"); BEGIN(INITIAL);}
    \\\)\;  {ECHO;}
}

<INC>{
    ".h' '>"|".h>"|".h\""|".h' '\""    {ECHO; printf(" // escaped include"); BEGIN(INITIAL); }
    .       {ECHO;}    
    \n      {ECHO; BEGIN(INITIAL);}
}

<DOC1>{
    \*\/  {printf("//escape doc1\n"); BEGIN(INITIAL);}
    \n   {  }
    .   { }
}

<DOC2>{
    \n  {ECHO; printf("//escape doc2\n"); BEGIN(INITIAL);}
    .   { }
}

<COM1>{
    "\n"    {ECHO; printf(" // escaped com1"); BEGIN(INITIAL); }
    .       { }
}

<COM2>{
    "\*\/"     {printf(" // escaped com2"); BEGIN(INITIAL);}
    \n   { }
    .   { }
}



%%

int yywrap(){}
int main(int argc, char ** argv){

    if ( argc > 1 && ! strcmp(argv[1], "--doxygen")){
        displaydoxy = true;
    }
    yylex();
    return 0;
}