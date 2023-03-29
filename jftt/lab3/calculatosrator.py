from ply import lex, yacc

import flexer
import yaccer
import gmpy2


def main():
    lexer = lex.lex(module=flexer)
    parser = yacc.yacc(module=yaccer)
    while True:
        text = ""
        while True:
            try:
                text += input()
            except EOFError:
                return
            text += '\n'
            if not text.endswith('\\\n'):
                break
        parser.parse(text, lexer=lexer)


if __name__ == "__main__":
    main()