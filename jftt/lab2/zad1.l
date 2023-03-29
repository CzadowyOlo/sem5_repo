%{
      #include <stdbool.h>
      int lines = 0; 
      int words = 0;
      bool word_occurence = false;
%}


WS  [ \t]+
WORD    [^ \t\n]+
NEWLINE [\n]



%%

{NEWLINE} {
    if (word_occurence){
        ECHO;
        lines++;
        } /* echo przepisuje linię, a linecout liczy newliny tylko jeśli zawierały slowo */
        else{
            /* jeśli pusta linia to ją usuwa */
        }
    word_occurence = false;
}

^{WS} /* bialy znak tylko na początku lini - usuń */
{WS}$ /* biały znak tylko na końcu lini - usuń */
{WS}     {printf(" ");}/* zastępuje ciąg bz jedną spacją */
{WORD}  {ECHO; words++; word_occurence = true;}

%%

int yywrap(){}
int main(){
      yylex();
      //printf("lines: %d, words: %d \n", lines, words);
      return 0;
}
