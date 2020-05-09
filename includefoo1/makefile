libUseFooButNotIncludeFoo.a:car.c
	gcc -c -o car.o car.c 
	ar rcs libUseFooButNotIncludeFoo.a car.o
 
libUseFooButIncludeFoo1.a:car.c
	gcc -c -o car.o car.c 
	ar rcs tmp.a car.o
	libtool -static  tmp.a ../foo1/libfoo1.a  -o libUseFooButIncludeFoo1.a

clean:
	rm -f libUseFooButNotIncludeFoo1.a libUseFooButIncludeFoo1.a car.o tmp.a