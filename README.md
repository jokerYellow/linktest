# linkDemo
该项目是对静态链接以及动态链接下，符号重复情况的一个验证。

## 执行
在每个目录下，都有 makefile 文件，包括静态库动态库的制作，以及链接、运行等过程。可以直接执行，缺什么就去 make 什么。

```sh
$ make command
```

## 概念

### 符号
符号用来方便的对变量以及函数进行引用。
* 全局符号，也称为外部符号，可供外部模块使用。如 global、f 为全局符号。
* 局部符号，带有 static 属性的为局部符号，不能被其他模块使用。如local，只在foo模块里可见，而f里的x只在f函数里可见。
```c
# foo.c
int global = 1;
static int local = 10;
int f(){
    static int x = 0;
    return x;
}
```

### 目标文件

每个代码文件都会被编译称为一个目标文件，如 main.c、foo.m 文件都会被编译成对应的 main.o、foo.o 文件。目标文件是可以重定位的。

```sh
$ gcc -c -o foo.o foo.c
$ gcc -c -lobjc foo.m -o foom.o
```

### 可执行文件
    
链接目标文件 main.o、foo.o 到标准库，成为可执行文件。

```sh
$ ld main.o foo.o -lc -o a.out
```
默认程序入口为 main 函数，链接时也可以指定程序入口。
可执行文件是可以直接运行的。
 
### 静态库

将 foo.o、foom.o 文件处理成 libfoo.a 文件，称为静态库。静态库其实是将 foo.o、foom.o 合并成了一个文件，其头部含有各个文件的偏移量以及大小。

```sh
$ ar rcs libfoo.a foo.o foom.o
```
如果 main.o 依赖 libfoo.a，在链接 main.o 成为可执行文件时，指定 libfoo.a 进行链接，libfoo.a 会被链接进最后的 a.out 文件里

```sh
$ gcc -o static.out main.c foo/libfoo.a ; ./static.out
```

### 动态库

将 foo.o 文件处理成 libfoo.so 文件，称为动态库

```sh
# -fPIC表示开启地址无关选项，只有地址无关才适合动态加载
$ gcc -g -fPIC -c foo.c
# -lobjc 表示编译objective-c文件
$ gcc -c -lobjc -g -fPIC foo.m -o foom.o
$ gcc -shared foo.o foom.o -framework Foundation -o libfoo.so
```

如果 main.o 依赖 libfoo.so，
在链接 main.o 成为可执行文件时，会在 a.out 添加 libfoo.so 的路径以及库名、重定位、符号表等信息，a.out 在启动时会寻找 libfoo.so 库进行加载。

```sh
$ gcc -g -c  main.m 
$ export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:foo1 ;ld main.o -lc foo1/libfoo.so -framework Foundation 
$ ./a.out
```

a.out 启动时会在 $DYLD_LIBRARY_PATH 环境变量寻找以及加载 libfoo.so 库。
同时也会加载 Foundation 库，用来支持 Objective-C 。
-lc 加载 C 的标准库。

动态库优势：

* 可以动态的更新程序，只需要替换 libfoo.so 文件就可以修改程序行为了。
* 多个可执行文件可以依赖同一个动态库。
* 节省内存，代码段在内存里只有一份。

## 静态库符号解析过程

链接器从左到右按照命令行上出现的顺序来扫描可重定位目标文件和存档文件。
* E：可重定位目标文件集合，这个集合里的文件会被合并起来形成可执行文件。
* U：未解析的符号集合，引用了但是尚未定义的符号，比如用 extern 引用，或者引入了 h 文件。
* D：一个在前面输入文件重已定义的符号集合。

对于命令行的每个输入文件 f：

   1. f 为目标文件，链接器把 f 加到 E 集合，修改 U 和 D 来反映 f 中的符号定义和引用。
   2. f 为静态库，链接器尝试匹配 U 中未解析的符号和静态库里的目标文件定义的符号。如静态库里的目标文件 m，定义了一个符号来解析 U 里面的一个引用，那么就把 m 加到 E 中，并且链接器修改 U 和 D 来反映 m 中的符号定义和引用。轮询完静态库里的所有的目标文件，直到 U 和 D 不再变化。此时静态库里不包含在 E 里的目标文件，会被丢弃。
   3. 命令行里所有的文件处理完毕后，假如 U 不为空，链接器会报错。 U 为空则表示所有的引用符号都已经成功匹配，接下来链接器会将 E 集合里的所有目标文件进行合并以及重定位，构建可执行文件。

## 静态库符号重复

经过验证，静态库加载时，会默认选择首次加载的符号。U 集合里的符号被匹配之后，就会被从 U 集合里去掉，不再匹配。

```sh
$ make runstaticfoo1fisrtSameName
gcc -lobjc -o  a.out main.m foo1/libfoo.a foo/libfoo.a -framework Foundation
./a.out
2020-05-08 18:40:31.028 a.out[19865:181170] [Foo name] is foo1

$ make runstaticfoofirstSameName
gcc -lobjc -o  a.out main.m foo/libfoo.a foo1/libfoo.a  -framework Foundation
./a.out
2020-05-08 18:41:45.210 a.out[19948:181814] [Foo name] is foo

$ make runstaticfoo1fisrtDifferentName
gcc -lobjc -o  a.out main.m foo1/libfoo1.a foo/libfoo.a -framework Foundation
./a.out
2020-05-08 18:43:51.154 a.out[20164:183068] [Foo name] is foo1

$ make runstaticfoofirstDifferentName
gcc -lobjc -o  a.out main.m foo/libfoo.a foo1/libfoo1.a  -framework Foundation
./a.out
2020-05-08 18:44:25.282 a.out[20209:183371] [Foo name] is foo
```
## 动态库加载
动态链接器来处理动态链接，会维护一个**全局符号表**。动态链接器从可执行文件里提取需要查找的动态库，查找动态库以及将动态库里的符号添加到**全局符号表**。所有的动态库都装载完毕后，接下来会通过**全局符号表**对动态引用的符号进行重定向。

### 全局符号介入

当一个符号需要被加入到**全局符号表**时，如果相同的符号名已经存在，则后加入的符号忽略。
这会导致一个动态库里的符号被另一个动态库的同名符号所替代，这个叫**全局符号介入**。

## 动态库符号重复

动态库名称重复，会认为是相同的库，默认加载最先找到的一个库

```sh
$ make rundynamicfoofirstSameLibraryName
gcc -g -c  main.m
export DYLD_LIBRARY_PATH=YLD_LIBRARY_PATH:foo:foo1 ; ld main.o -lc foo/libfoo.so foo1/libfoo.so  -framework Foundation ; ./a.out
2020-05-08 18:27:57.913 a.out[19150:174944] [Foo name] is foo

$ make rundynamicfoo1firstSameLibraryName
gcc -g -c  main.m
export DYLD_LIBRARY_PATH=YLD_LIBRARY_PATH:foo:foo1 ;ld main.o -lc foo1/libfoo.so foo/libfoo.so -framework Foundation ; ./a.out
2020-05-08 18:28:06.088 a.out[19184:175091] [Foo name] is foo
```

动态库名称不重复符号重复的情况，默认会选择最早加载的库。如上**全局符号介入**。

````sh
$ make rundynamicfoofirstDifferentLibraryName
gcc -g -c  main.m
export DYLD_LIBRARY_PATH=YLD_LIBRARY_PATH:foo:foo1 ; ld main.o -lc foo/libfoo.so foo1/libfoo1.so  -framework Foundation ; ./a.out
objc[19012]: Class Foo is implemented in both /Users/mi/Documents/code/linkdemo/foo1/libfoo1.so (0x1066450d8) and /Users/mi/Documents/code/linkdemo/foo/libfoo.so (0x1066410d8). One of the two will be used. Which one is undefined.
2020-05-08 18:27:15.759 a.out[19012:174315] [Foo name] is foo

$ make rundynamicfoo1firstDifferentLibraryName
gcc -g -c  main.m 
export DYLD_LIBRARY_PATH=YLD_LIBRARY_PATH:foo:foo1 ;ld main.o -lc foo1/libfoo1.so foo/libfoo.so -framework Foundation ; ./a.out
objc[40702]: Class Foo is implemented in both /Users/pipasese/Documents/miCode/linkdemo/foo/libfoo.so (0x1069c50d8) and /Users/pipasese/Documents/miCode/linkdemo/foo1/libfoo1.so (0x1069bf0d8). One of the two will be used. Which one is undefined.
2020-05-09 10:00:44.785 a.out[40702:1267961] [Foo name] is foo1
````

## 动态库与静态库重复

会使用静态库的代码，静态库链接时已经写入可执行文件，动态库启动时链接会忽略。

````sh
$ make runStaticAndDynamicMultipleSymbols
gcc -g -c  main.m 
export DYLD_LIBRARY_PATH=YLD_LIBRARY_PATH:foo ; ld main.o foo1/libfoo.a -lc foo/libfoo.so  -framework Foundation ; ./a.out
objc[40771]: Class Foo is implemented in both /Users/pipasese/Documents/miCode/linkdemo/foo/libfoo.so (0x104c690d8) and /Users/pipasese/Documents/miCode/linkdemo/./a.out (0x104c5e0f8). One of the two will be used. Which one is undefined.
2020-05-09 10:01:05.218 a.out[40771:1268288] [Foo name] is foo1
````

## 结论
不论是动态库还是静态库的场景，默认都是使用最先加载的符号。

## 参考资料
* 《深入理解计算机系统》链接
* 《程序员的自我修养》动态链接