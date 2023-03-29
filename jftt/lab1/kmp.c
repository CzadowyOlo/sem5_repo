#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <tgmath.h>
#include <time.h>
#include "FAPF.h"
#include <string.h>
#include <stdbool.h>
#include <locale.h>

bool isNextChar(unsigned char c){
    return (c < 128 || c > 192);
}
int utf8len(char* str){
    int len = 0;
    for(; str[0] != '\0'; ++str){
        len += isNextChar((unsigned char)str[0]);
    }
    return len;
}
static void pi(const char* pattern, size_t m, size_t* pitab);

static void pi(const char* pattern, size_t m, size_t* pitab){

    for(size_t i = 0; i <= m; i++){
        pitab[i] = 0;
    }
    printf("pitab[0] = %zu\n", pitab[0]);
    size_t k = 0;

    for(size_t q = 1; q <= m; q++){
        while (k > 0 && pattern[k] != pattern[q]){
            k = pitab[k-1];
        }
        if (pattern[k] == pattern[q]){
            k++;
        }
        pitab[q] = (unsigned long)k;

        printf("pitab[%zu] = %zu\n", q, pitab[q]);

    }

}



int main(int argc, char* argv[argc+1]){

const char* pattern = argv[1]; // @param my pattern to seek
const size_t m = strlen(pattern);
FILE *f = fopen(argv[2], "rb");
fseek(f, 0, SEEK_END);
size_t fsize = (size_t)ftell(f);
fseek(f, 0, SEEK_SET);  /* same as rewind(f); */

char* text = (char*)malloc(fsize + 2);
fread(text, fsize, 1, f);
fclose(f);

size_t* pitab;

pitab = malloc((m+1) * sizeof(size_t)); // dobrze
// pitab = (size_t*)malloc(m); źle
// c2 i c3
size_t patch = 0;
uint8_t help_operand = 240; //11110000
uint8_t help_operand2 = 224; //11100000
uint8_t help_operand3 = 192; //11000000
// int skip = 0;
pi(pattern, m, pitab);

size_t q = 0;
int len;
unsigned char y;
for( size_t i = 0; i < fsize; i++){
    y = *(unsigned char*)(&text[i]);
    //printf("kolejka: %zu\n",i);
    // if((unsigned char)text[i] == 194 || (unsigned char)text[i] == 195 ){
        //patch++;
    
    // if(true){
    //     if(((((int)text[i]) & 240) == 240)){ // sprawdzam czy znak sie koduje na 4 bajtach, 
    //         patch = patch + 3; // jeśli tak to poprawiam moje przesunięcie o +3. bo znak jest jeden, ale zajmuje w tablicy więcej miejsca
    //         //skip = 3;
    //     }
    //     else{
    //         // if((text[i] & 224) == 224){
    //         //     patch = patch + 2;
    //         //     //skip = 2;
    //         // }
    //         // else{
    //         //     if((text[i] & 192) == 192){
    //         //         patch++;
    //         //         //skip = 1;
    //         //     }

    //         // }
    //     }   
    // }      
    //     if(skip == 0){
    //     if((unsigned char)text[i] >= 240){
    //         patch+=3; 
    //         skip = 3;
    //     }
    //     else{
    //         if((unsigned char)text[i] >= 224){
    //             patch+=2;
    //             skip = 2;
    //         }
    //         else{
    //             if((unsigned char)text[i] >= 192){
    //                 patch++;
    //                 skip = 1;
    //             }

    //         }
    //     }   
    // }     
    //printf("oto q: %zu\n", q);
    // len = mblen(text + i, 4);
    // if(len > 1){
    //     patch+=len;
    // }
    //patch += len;
    // if((y & 128) == 0){  }
    // if((y & 224) == 192){
    //     patch = patch + 1;
    //     }
    // if((y & 240) == 224){
    //     patch = patch + 2;
    //     }
    // if((y & 248) == 240){
    //     patch = patch + 3;
    //     }
    patch += (int)isNextChar(text[i]);

    while (q > 0 && pattern[q] != text[i]){
        q = pitab[q-1];
        //printf("loop");
    }
    if(pattern[q] == text[i]){
        q+=1;
    }
    if(q == m){
        printf("wzorzec występuje z przesunięciem: %zu \n", (patch));
        q = pitab[q-1];

    }

    // if(skip > 0){
    //     skip--;
    // } 
}

free(pitab);
free(text);
return 0;

}
