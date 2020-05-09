libfoo.a:foo.c
	gcc -c -o foo.o foo.c
	gcc -c -lobjc foo.m -o foom.o
	ar rcs libfoo.a foo.o foom.o

libfoo.so:foo.c 
	gcc -g -fPIC -c foo.c 
	gcc -c -lobjc -g -fPIC foo.m -o foom.o
	gcc -shared foo.o foom.o -framework Foundation -o libfoo.so

libfoo1.a:foo.c
	gcc -c -o foo.o foo.c
	gcc -c -lobjc foo.m -o foom.o
	ar rcs libfoo1.a foo.o foom.o

libfoo1.so:foo.c 
	gcc -g -fPIC -c foo.c 
	gcc -c -lobjc -g -fPIC foo.m -o foom.o
	gcc -shared foo.o foom.o -framework Foundation -o libfoo1.so

clean:
	rm -f libfoo.a libfoo.so foo.o foom.o libfoo1.so libfoo1.a