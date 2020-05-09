libUseFooButNotIncludeFoo.a:car.c
	gcc -c -o car.o car.c 
	ar rcs libUseFooButNotIncludeFoo.a car.o
 
libUseFooButIncludeFoo.a:car.c
	gcc -c -o car.o car.c 
	ar rcs tmp.a car.o
	libtool -static  tmp.a ../foo/libfoo.a  -o libUseFooButIncludeFoo.a

clean:
	rm -f libUseFooButNotIncludeFoo.a libUseFooButIncludeFoo.a car.o tmp.a