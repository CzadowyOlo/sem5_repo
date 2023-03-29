#ifndef FAPF_H
#define FAPF_H

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

char* construct (const char* pattern, size_t q, char a);
size_t sigma(char* text, char* pattern_prefix, size_t n, size_t q, size_t m);

#endif
