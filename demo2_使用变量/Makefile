object = test.c

test:test.o
	gcc -o test test.o

test.o:$(object)
	gcc -c $(object)

clean:
	rm test test.o
