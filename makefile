LEX = flex
YYAC = bison
CC = gcc
LIB_HASHTABLE = lib/hashtable
CFLAGS	= -Wall -Wextra -g -DDEBUG -DTEST $(MURMUR)


all: clean parser

parser: main.c syntax.tab.c lex.yy.c utils
	gcc *.c -lc -lfl -ly -g -o parser
#syntax.tab.c syntax.tab.h: syntax.y
#	$(YYAC) -vd syntax.y

#lex.yy.c: lexical.l
#	$(LEX) -o $@ $<

hashtable-lib: $(LIB_HASHTABLE)/hashtable.h $(LIB_HASHTABLE)/hashtable.c $(LIB_HASHTABLE)/murmur.h $(LIB_HASHTABLE)/murmur.c
	$(CC) $(CFLAGS) -c $(LIB_HASHTABLE)/hashtable.c $(LIB_HASHTABLE)/murmur.c
	ar crf libhashtable.a hashtable.o murmur.o

main.o: main.c

syntax.translate.o : syntax.translate.c syntax.translate.h

syntax.tab.o : syntax.tab.c syntax.tab.h

scanner.o: scanner.c parser.tab.h

scanner: main.c lex.yy.c
	$(CC) -o $@ main.c lex.yy.c -lfl

.PHONY : clean head all testreq testopt test debug

head: clean syntax.tab.h

test2: all
	for i in {1..21}  \
	do  \
	echo "\n\033[34m<1.c>\033[0m\n" && \
	./parser ./examples/lab2/$i.c\
	done

test1: testreq1 testopt1

testreq1: all
	echo "\n\033[34m<1.c>\033[0m\n" && ./parser ./examples/lab1/1.c \
	&& echo "\n\033[34m<2.c>\033[0m\n" && ./parser ./examples/lab1/2.c \
	&& echo "\n\033[34m<3.c>\033[0m\n" && ./parser ./examples/lab1/3.c \
	&& echo "\n\033[34m<4.c>\033[0m\n" && ./parser ./examples/lab1/4.c \
	&& echo "\n\033[34m<5.c>\033[0m\n" && ./parser ./examples/lab1/5.c

testopt1: all
	echo "\n\033[34m<6.c>\033[0m\n" && ./parser ./examples/lab1/6.c \
	&& echo "\n\033[34m<7.c>\033[0m\n" && ./parser ./examples/lab1/7.c \
	&& echo "\n\033[34m<8.c>\033[0m\n" && ./parser ./examples/lab1/8.c \
	&& echo "\n\033[34m<9.c>\033[0m\n" && ./parser ./examples/lab1/9.c \
	&& echo "\n\033[34m<10.c>\033[0m\n" && ./parser ./examples/lab1/10.c
clean:
	-@ rm parser syntax.output *.o

debug: clean test