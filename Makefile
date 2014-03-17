all: pascal

pascal: pascal.o

pascal.o: pascal.c
	gcc -o pascal.o -dynamiclib pascal.c

pascal.c: pascal.lex
	flex -opascal.c pascal.lex

clean:
	rm -f pascal.c pascal.o