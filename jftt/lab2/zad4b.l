%{
// C program for array implementation of stack
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>

int wynik;
int bottom;
int top;
bool error = false;
bool init = true;
bool word_occurence = false;

void error_occurence(char* dupa){
    printf("Wystąpił błąd: %s\n", dupa);
    error = true;
}
// A structure to represent a stack
struct Stack {
    int top;
    unsigned capacity;
    int* array;
};
  
// function to create a stack of given capacity. It initializes size of
// stack as 0
struct Stack* createStack(unsigned capacity)
{
    struct Stack* stack = (struct Stack*)malloc(sizeof(struct Stack));
    stack->capacity = capacity;
    stack->top = -1;
    stack->array = (int*)malloc(stack->capacity * sizeof(int));
    return stack;
}
  
// Stack is full when top is equal to the last index
int isFull(struct Stack* stack)
{
    return stack->top == stack->capacity - 1;
}
  
// Stack is empty when top is equal to -1
int isEmpty(struct Stack* stack)
{
    return stack->top == -1;
}
  
// Function to add an item to stack.  It increases top by 1
void push(struct Stack* stack, int item)
{
    if (isFull(stack))
        return;
    stack->array[++stack->top] = item;
    printf("%d polożono na stack\n", item);
}
  
// Function to remove an item from stack.  It decreases top by 1
void pop(struct Stack* stack)
{
    if (isEmpty(stack)){
        error_occurence("za malo liczb na stosie");
        return;
    }
    top =  stack->array[stack->top--];
    printf("%d zdjęto ze stacka\n", top);
    if (isEmpty(stack)){
        error_occurence("za malo liczb na stosie");
        return;
    }
    bottom =  stack->array[stack->top--];
    printf("%d zdjęto ze stacka\n", bottom);


}
int getres(struct Stack* stack)
{
    if (isEmpty(stack)){
        error = true;
        return INT_MIN;
    }
    int wynik = stack->array[stack->top--];
    printf("%d zdjęto ze stacka\n", wynik);
    return wynik;
}

void restore(struct Stack* stack){
    int dupa;
    while(!isEmpty(stack)){
        dupa = getres(stack);
    }
}

void print_result(struct Stack* stack){
    if (isEmpty(stack)){
        error_occurence("brak liczb na stosie");
        return;
    }
    wynik = getres(stack);
    if (!isEmpty(stack)){
        error_occurence("za mało operatorów");
        return;
    }    
    printf("oto wynik = %d\n", wynik);
}
  
// Function to return the top from stack without removing it
int peek(struct Stack* stack)
{
    if (isEmpty(stack))
        return INT_MIN;
    return stack->array[stack->top];
}

void myadd(struct Stack* stack){
    pop(stack);
    if(error){
        return;
    }
    push(stack, bottom + top);
}
void mysub(struct Stack* stack){
    pop(stack);
    if(error){
        return;
    }
    push(stack, bottom - top);
}
void mymul(struct Stack* stack){
    pop(stack);
    if(error){
        return;
    }    
    push(stack, bottom * top);
}
void mydiv(struct Stack* stack){
    pop(stack);
    if(error){
        return;
    }
    if(top == 0){
        error_occurence("nie mozna dzielic przez 0");
        return;
    }
    push(stack, bottom / top);
}
void mymod(struct Stack* stack){
    pop(stack);
    if(error){
        return;
    }    
    if(top == 0){
        error_occurence("nie mozna dzielic przez 0");
        return;
    }
    push(stack, bottom % top);
}

void myexp(struct Stack* stack){
    pop(stack);
    int res = 1;
    if(error){
        error_occurence("nie pobrano liczb");
        return;
    }
    if(top < 0){
        error_occurence("ujemna exponenta");
        return;
    }
    while(top > 0){
        top--;
        res = res * bottom;
    }
    push(stack, res);

}

  
  
  
  
// Driver program to test above functions
struct Stack* stack;

%}

DIGITS [0-9]
OPERATORS [+-:\*]
NUMBER  "-"*[0-9]+
%x OMIT

%%

{NUMBER}    {
    word_occurence = true;
    if(init){
        init = false;
        stack = createStack(100);
    }
    push(stack, atoi(yytext));}
" "
\+ { word_occurence = true; if(error){BEGIN(OMIT);} myadd(stack); if(error){BEGIN(OMIT);}; };
\- { word_occurence = true; if(error){BEGIN(OMIT);} mysub(stack); if(error){BEGIN(OMIT);}; };
\* { word_occurence = true; if(error){BEGIN(OMIT);} mymul(stack); if(error){BEGIN(OMIT);}; };
\/ { word_occurence = true; if(error){BEGIN(OMIT);} mydiv(stack); if(error){BEGIN(OMIT);}; };
\^ { word_occurence = true; if(error){BEGIN(OMIT);} myexp(stack); if(error){BEGIN(OMIT);}; };
\% { word_occurence = true; if(error){BEGIN(OMIT);} mymod(stack); if(error){BEGIN(OMIT);}; };
\n { 
        if(word_occurence){
            print_result(stack); 
            restore(stack); 
            free(stack->array);
            free(stack);
            init = true;
            error = false;
            printf("\n nowa seria:\n");
        }
        else{
            BEGIN(INITIAL);
        }
        word_occurence = false;
    }

[^ 0123456789\+\-\*\/\^\%\n]  {
    char msg[30] = "Zły symbol: ";
    strcat(msg, yytext);
    error_occurence(msg); 
    BEGIN(OMIT);
}
<OMIT>{
    .
    \n {BEGIN(INITIAL); restore(stack); error = false; printf("\n nowa seria:\n");}
}

%%

int yywrap(){}
int main(int argc, char ** argv){

   
    yylex();
    return 0;
}
