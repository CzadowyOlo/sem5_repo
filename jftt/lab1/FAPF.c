#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <tgmath.h>
#include <time.h>
#include "FAPF.h"
#include <string.h>
#include <stdbool.h>

// TODO:  write array of char arrays of all states of pattern. ex:
// patter = "ciba"
//array of arrays = ["c", "ci", "cib", "ciba"]

/**
 * @brief create word for matching - its prefix of patter + letter from text
 * 
 * @param pattern - pattern from cmd line
 * @param q index of P - pattern
 * @param a letter from T - text
 * @return concatanation of prefiks of pattern and letter a
 */
char* construct (const char* pattern, size_t q, char a){

    char* piece;
    
    piece = (char*)malloc(q+1);

    strncpy(piece, pattern, q);
    piece[q] = a;
    //printf("stan: \n");
    // for(size_t i = 0; i <= q; i++){
    //     printf("%c", piece[i]);
    // }
    // printf("\n");
    return piece;

}
/**
 * @brief compares prefix of pattern with suffix of text
 * 
 * @param text substring of text at main loop moment (n)
 * @param pattern_prefix state - prefix of pattern with t[n-1] added
 * @param n len of given subtext
 * @return size_t len of prefix of pattern if matches, 0 otherwise
 */
size_t sigma(char* text, char* pattern_prefix, size_t n, size_t q, size_t m){

    size_t len = q+1;
    //printf("sizeof: %zu\n", len);
    size_t diff = n + 1 - len;
    size_t max = 0;
    // if(diff > n) return 0;
    // bool succes = 1;

    for (size_t i = 0; i < len; i++){

        if(text[i+diff] == pattern_prefix[i]){
            // 
            //printf("litera: %c, iteration: %zu \n", pattern_prefix[i], n);
            max++;
        }
        else{
            // succes = 0;
            break;
        }
        
    }
    free(pattern_prefix);
    return max;

}

int main(int argc, char* argv[argc+1]){

const char* pattern = argv[1]; // @param my pattern to seek
const size_t m = strlen(pattern);
FILE *f = fopen(argv[2], "rb");
fseek(f, 0, SEEK_END);
size_t fsize = (size_t)ftell(f);
fseek(f, 0, SEEK_SET);  /* same as rewind(f); */

char *text = malloc(fsize + 1);
fread(text, fsize, 1, f);
fclose(f);

size_t q = 0; // @param state of automat
for (size_t i = 0; i < fsize; i++){
    q = sigma(text, construct(pattern, q, text[i]), i, q, m);
    if(q == m){
        printf("wzorzec występuje z przesunięciem: %zu \n", (i - m));
        q = 0;
    }
}

free(text);
return 0;

}
