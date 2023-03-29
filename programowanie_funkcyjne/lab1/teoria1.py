# laby funkcyjne
from typing import Any
from numbers import Number
def isEmpty(L: list) -> bool:
    return len(L) == 0
def head(L : list) -> Any:
    return L[0]
def tail(L : list) -> list:
    return L[1]
def sum (L : list) -> Number:
    if isEmpty(L):
        return 0
    else:
        return head(L) + sum(tail(L))

def myFunc(x,y):
    return x * (x+y)

def compose(f,g):
    return lambda x: f(g(x))
    