%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define YYSTYPE int

#define BASE 1234577

int yylex(void);
void yyerror(char *);

typedef struct {
int value;
bool is_negative;
} number;

typedef struct stack_node {
YYSTYPE value;
struct stack_node *next;
} stack_node;

typedef struct {
stack_node *top;
} stack;

stack *number_stack;
stack *operator_stack;

number *number_new(int value, bool is_negative) {
number *n = (number *) malloc(sizeof(number));
n->value = value;
n->is_negative = is_negative;
return n;
}

number *number_add(number *a, number *b) {
int result = a->value + b->value;
if (result >= BASE)
result -= BASE;
return number_new(result, false);
}

number *number_subtract(number *a, number *b) {
int result = a->value - b->value;
if (result < 0)
result += BASE;
return number_new(result, false);
}

number *number_multiply(number *a, number *b) {
int result = a->value * b->value;
result %= BASE;
return number_new(result, false);
}

number *number_power(number *a, number *b) {
number *result = number_new(1, false);
for (int i = 0; i < b->value; i++)
result = number_multiply(result, a);
return result;
}

number *number_divide(number *a, number *b) {
int result = a->value * (b->value % (BASE - 1));
result %= BASE;
return number_new(result, false);
}

stack *stack_new() {
stack *s = (stack *) malloc(sizeof(stack));
s->top = NULL;
return s;
}

void stack_push(stack *s, YYSTYPE value) {
stack_node *n = (stack_node *) malloc(sizeof(stack_node));
n->value = value;
n->next = s->top;
s->top = n;
}

YYSTYPE stack_pop(stack *s) {
if (s->top == NULL) {
yyerror("stack is empty");
exit(1);
}

YYSTYPE value = s->top->value;
stack_node *n = s->top;
s->top = n->next;
free(n);
return value;

}

YYSTYPE stack_peek(stack *s) {
if (s->top == NULL) {
yyerror("stack is empty");
exit(1);
}
