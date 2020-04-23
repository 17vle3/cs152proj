parser: mini_l.lex
        flex mini_l.lex
        ggc -o lexer lex.yy.c -lfl
     
clean:
        rm -f lex.yy.c lexer
