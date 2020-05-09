run:
	gcc -c main.c;
	ld main.o  ../includefoo/libUseFooButNotIncludeFoo.a ../foo/libfoo.a  ../foo1/libfoo.a -lc
	./a.out

run1:
	gcc -c main.c;
	ld main.o  ../includefoo/libUseFooButIncludeFoo.a -lc
	./a.out

run2:
	gcc -c main.c;
	ld main.o  ../includefoo/libUseFooButIncludeFoo.a ../includefoo1/libUseFooButIncludeFoo1.a  -lc
	./a.out

run3:
	gcc -c main.c;
	ld main.o   ../includefoo1/libUseFooButIncludeFoo1.a  ../includefoo/libUseFooButIncludeFoo.a -lc
	./a.out

clean:
	rm a.out main.o