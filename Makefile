test: test.o
    gcc -o test.o

test.o: test.c
    gcc -c test.c

clean:
    rm test test.o
