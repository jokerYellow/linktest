runstatic: 
	gcc -o static.out main.c foo/libfoo.a ; ./static.out

runstatic1: 
	gcc -o static.out main.c foo1/libfoo1.a ; ./static.out

runstaticfoo1fisrtSameName: 
	gcc -lobjc -o  a.out main.m foo1/libfoo.a foo/libfoo.a -framework Foundation 
	./a.out 
	rm a.out

runstaticfoofirstSameName: 
	gcc -lobjc -o  a.out main.m foo/libfoo.a foo1/libfoo.a  -framework Foundation 
	./a.out 
	rm a.out

runstaticfoo1fisrtDifferentName: 
	gcc -lobjc -o  a.out main.m foo1/libfoo1.a foo/libfoo.a -framework Foundation 
	./a.out 
	rm a.out

runstaticfoofirstDifferentName: 
	gcc -lobjc -o  a.out main.m foo/libfoo.a foo1/libfoo1.a  -framework Foundation 
	./a.out 
	rm a.out


rundynamicfoo1: 
	gcc -g -c  main.m 
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:foo1 ;ld main.o -lc foo1/libfoo.so -framework Foundation ; ./a.out
	rm a.out main.o
	rm -rf a.out.dSYM

rundynamicfoo: 
	gcc -g -c  main.m 
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:foo ;ld main.o -lc foo/libfoo.so -framework Foundation ; ./a.out
	rm a.out main.o
	rm -rf a.out.dSYM

rundynamicfoo1firstSameLibraryName: 
	gcc -g -c  main.m 
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:foo:foo1 ;ld main.o -lc foo1/libfoo.so foo/libfoo.so -framework Foundation ; ./a.out
	rm a.out main.o
	rm -rf a.out.dSYM

rundynamicfoofirstSameLibraryName: 
	gcc -g -c  main.m 
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:foo:foo1 ; ld main.o -lc foo/libfoo.so foo1/libfoo.so  -framework Foundation ; ./a.out
	rm a.out main.o
	rm -rf a.out.dSYM

rundynamicfoo1firstDifferentLibraryName: 
	gcc -g -c  main.m 
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:foo:foo1 ;ld main.o -lc foo1/libfoo1.so foo/libfoo.so -framework Foundation ; ./a.out
	rm a.out main.o
	rm -rf a.out.dSYM

rundynamicfoofirstDifferentLibraryName: 
	gcc -g -c  main.m 
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:foo:foo1 ; ld main.o -lc foo/libfoo.so foo1/libfoo1.so  -framework Foundation ; ./a.out
	rm a.out main.o
	rm -rf a.out.dSYM

runStaticAndDynamicMultipleSymbols: 
	gcc -g -c  main.m 
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:foo ; ld main.o foo1/libfoo.a -lc foo/libfoo.so  -framework Foundation ; ./a.out
	rm a.out main.o
	rm -rf a.out.dSYM

runStaticAndDynamicMultipleSymbols1: 
	gcc -g -c  main.m 
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:foo ; ld main.o foo1/libfoo1.a -lc foo/libfoo.so  -framework Foundation ; ./a.out
	rm a.out main.o
	rm -rf a.out.dSYM

runStaticAndDynamicMultipleSymbols2: 
	gcc -g -c  main.m
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:foo ; ld main.o -lc foo/libfoo.so foo1/libfoo1.a  -framework Foundation ; ./a.out
	rm a.out main.o
	rm -rf a.out.dSYM

runStaticAndDynamicMultipleSymbols3: 
	gcc -g -c  main.m
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:foo ; ld main.o -lc foo/libfoo.so foo1/libfoo.a  -framework Foundation ; ./a.out
	rm a.out main.o
	rm -rf a.out.dSYM