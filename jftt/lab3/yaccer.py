from flexer import tokens, P

def invert(a, b):
    """
    The multiplicitive inverse of a in the integers modulo b.

    :return int: x, where a * x == 1 mod b
    """

    for d in range(1, b):
        r = (d * a) % b
        if r == 1:
            break
    else:
        d = -69
    return d


tokens = tokens[:-3]
rpn = ""
zero_div = False
nonivertable = False
precedence = (
    ('left', 'ADD', 'SUB'),
    ('left', 'MUL', 'DIV'),
    ('right', 'NEG'),
    ('nonassoc', 'POW')
)

def p_line_expr(p):
    'line : expr ENDL'
    global rpn, zero_div, nonivertable
    print("NOTATION:", rpn)
    print(f"RESULT: {p[1]}")
    rpn = ""
    zero_div = False
    nonivertable = False


def p_line_error(p):
    'line : error ENDL'
    global rpn, zero_div, nonivertable
    if zero_div:
        print("Błąd: dzielenie przez 0")
    else:
        if nonivertable:
            print("Element nieodwracalny")    
        else:    
            print("Błąd: zła składnia")
    rpn = ""
    zero_div = False
    nonivertable = False


def p_expr_number(p):
    'expr : number'
    # print("why am i here")
    # print(p[1])
    # print("why")
    global rpn
    rpn += f"{p[1]} "
    p[0] = p[1]

def p_exprpow_number(p):
    'exprpow : numberpow'
    global rpn
    rpn += f"{p[1]%(P-1)} "
    # print("base is ")
    # print(P-1)
    p[0] = p[1] % (P-1)
    # print("testy")
    # print(p[1])
    # print(p[0])
    # print("koniec testow")

def p_expr_paren(p):
    'expr : LPAREN expr RPAREN'
    p[0] = p[2]

def p_exprpow_paren(p):
    'exprpow : LPAREN exprpow RPAREN'
    p[0] = p[2]

def p_expr_neg(p):
    'expr : SUB LPAREN expr RPAREN %prec NEG'
    global rpn
    rpn += "~ "
    p[0] = -p[3] % P

def p_exprpow_neg(p):
    'exprpow : SUB LPAREN exprpow RPAREN %prec NEG'
    global rpn
    rpn += "~ "
    p[0] = -p[3] % (P-1) 

def p_expr_add(p):
    'expr : expr ADD expr'
    global rpn
    rpn += "+ "
    p[0] = (p[1] + p[3]) % P

def p_exprpow_add(p):
    'exprpow : exprpow ADD exprpow'
    global rpn
    rpn += "+ "
    p[0] = (p[1] + p[3]) % (P-1)

def p_expr_sub(p):
    'expr : expr SUB expr'
    global rpn
    rpn += "- "
    p[0] = (p[1] - p[3]) % P

def p_exprpow_sub(p):
    'exprpow : exprpow SUB exprpow'
    global rpn
    rpn += "- "
    p[0] = (p[1] - p[3]) % (P-1)


def p_expr_mul(p):
    'expr : expr MUL expr'
    global rpn
    rpn += "* "
    p[0] = (p[1] * p[3]) % P

def p_exprpow_mul(p):
    'exprpow : exprpow MUL exprpow'
    global rpn
    rpn += "* "
    p[0] = (p[1] * p[3]) % (P-1)    

def p_expr_pow(p):
    'expr : expr POW exprpow'
    global rpn
    rpn += " ^ "
    p[0] = pow(p[1], (p[3] % P), (P))

def p_expr_div(p):
    'expr : expr DIV expr'
    global rpn
    rpn += "/ "
    if p[3] == 0:
        global zero_div, nonivertable
        zero_div = True
        raise SyntaxError
    myinverse = invert(p[3], P) 
    if(myinverse != -69):
        p[0] = (myinverse * p[1]) % P
    else:
        nonivertable = True
        raise SyntaxError


def p_exprpow_div(p):
    'exprpow : exprpow DIV exprpow'
    global rpn
    rpn += "/ "
    if p[3] == 0:
        global zero_div, nonivertable
        zero_div = True
        raise SyntaxError
    myinverse = invert(p[3], (P-1)) 
    if(myinverse != -69):
        p[0] = (myinverse * p[1]) % (P-1)
    else:
        p[0] = 2137
        #print("element ten nie odwracalny")  
        nonivertable = True
        raise SyntaxError

def p_number_pos(p):
    'number : NUM'
    #print("cip")
    p[0] = p[1] % P

def p_numberpow_pos(p):
    'numberpow : NUM'
    #print("dup")
    p[0] = (p[1])%(P-1)
    #print(p[1])


def p_number_neg(p):
    'number : SUB number %prec NEG'
    p[0] = -p[2] % P

def p_numberpow_neg(p):
    'numberpow : SUB numberpow %prec NEG'
    p[0] = -p[2] % (P-1)    

def p_error(p):
    pass