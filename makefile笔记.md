# Makefile笔记

https://seisman.github.io/how-to-write-makefile/



## 概述

- makefile带来的好处就是——“自动化编译”

- make是一个命令工具，是一个解释makefile中指令的命令工具

本文仅针对GNU的make进行讲述



## 程序的编译与链接

- **源代码** —— 编译 & 汇编 —— **中间代码（.o文件）**—— 链接 —— **可执行文件**
  - 一般来说，每个源文件都应该对应于一个中间目标文件

> 在编译时，编译器只检测程序语法和函数、变量是否被声明。如果函数未被声明，编译器会给出一个警告，但可以生成Object File。
>
> 而在链接程序时，链接器会在所有的Object File中找寻函数的实现，如果找不到，那到就会报链接错误码（Linker Error）



## Makefile介绍

```makefile
target ... : prerequisites ...
    command
    ...
    ...
```

- target —— 生成的目标
- prerequisites —— 生成该target所依赖的文件和/或target
- command —— 该target要执行的命令（任意的shell命令）

【**prerequisites中如果有一个以上的文件比target文件要新的话，command所定义的命令就会被执行】**



#### Demo1：简单样例

> **【在Makefile中的命令，必须要以 `Tab` 键开始】**
>
> 需要在vimrc中设置 set noexpandtab，不用空格代替制表符，否则会导致错误

```makefile
test:test.o
	gcc -o test test.o

test.o:test.c
	gcc -c test.c
	
clean:
	rm test test.o
```

- make —— 执行编译
- make clean —— 清楚指定文件



#### Demo2：使用变量

- 类比C语言中的 **宏**，进行替换
- 使用 **$(name)** 引用变量

```makefile
object = test.c

test:test.o
	gcc -o test test.o

test.o:$(object)
	gcc -c $(object)

clean:
	rm test test.o
```



#### Demo3：自动推导

- 只要make看到一个 `.o` 文件，它就会自动的把 `.c` 文件加在依赖关系中

> 如果make找到一个`whatever.o` ，那么 `whatever.c` 就会是 `whatever.o` 的依赖文件。并且 `cc -c whatever.c` 也会被推导出来

```makefile
object = test.o

test:$(object)
	gcc -o test $(object)

$(object):
# 此处利用了自动推导，test.o - test.c - gcc

.PHONY:clear
clean:
	rm test $(object)
```

-  `.PHONY` 表示 `clean` 是个伪目标文件
  - “伪目标”并不是一个文件，只是一个标签
-  `clean` 的规则不要放在文件的开头，不然，这就会变成make的默认目标



> #### 另类风格的makefiles
>
> 合并共同的依赖项，写在同一条规则里面
>
> - 好处：简洁
> - 坏处：依赖关系不直观，添加新规则时较麻烦
>
> ```makefile
> objects = main.o kbd.o command.o display.o \
>     insert.o search.o files.o utils.o
> 
> edit : $(objects)
>     cc -o edit $(objects)
> 
> # 将依赖关系【合并同类项】
> $(objects) : defs.h
> kbd.o command.o files.o : command.h
> display.o insert.o search.o files.o : buffer.h
> 
> .PHONY : clean
> clean :
>     rm edit $(objects)
> ```





## 书写规则详解

- 顺序很重要，最终目标放在第一个，其它目标都是被这个目标所连带出来的
- 支持使用 ～、*、？等通配符



#### 伪目标

伪目标一般没有依赖的文件。但是，我们也可以为伪目标指定所依赖的文件。伪目标同样可以作为“默认目标”，只要将其放在第一个。一个示例就是，如果你的Makefile需要一口气生成若干个可执行文件，但你只想简单地敲一个make完事，并且，所有的目标文件都写在一个Makefile中，那么你可以使用“伪目标”这个特性：

```makefile
all : prog1 prog2 prog3
.PHONY : all

prog1 : prog1.o utils.o
    cc -o prog1 prog1.o utils.o

prog2 : prog2.o
    cc -o prog2 prog2.o

prog3 : prog3.o sort.o utils.o
    cc -o prog3 prog3.o sort.o utils.o
```

我们知道，Makefile中的第一个目标会被作为其默认目标。我们声明了一个“all”的伪目标，其依赖于其它三个目标。由于默认目标的特性是，总是被执行的，但由于“all”又是一个伪目标，伪目标只是一个标签不会生成文件，所以不会有“all”文件产生。于是，其它三个目标的规则总是会被决议。也就达到了我们一口气生成多个目标的目的。 `.PHONY : all` 声明了“all”这个目标为“伪目标”。（注：这里的显式“.PHONY : all” 不写的话一般情况也可以正确的执行，这样make可通过隐式规则推导出， “all” 是一个伪目标，执行make不会生成“all”文件，而执行后面的多个目标。建议：显式写出是一个好习惯。）



#### 依赖关系自动推导

- -M 或者 -MM，自动判断依赖哪些头文件





## 书写命令详解

- 每条规则中的命令和操作系统Shell的命令行是一致的
- make会按顺序一条一条的执行命令
  - 多条命令分别执行 —— 换行
  - 在前一条命令的基础上执行下一条 —— 用分号隔开，不换行
- 每条命令的开头必须以 `Tab` 键开头



## 使用条件判断

- 下面的例子，判断 `$(CC)` 变量是否 `gcc` ，如果是的话，则使用GNU函数编译目标。
  - 三个关键词 **ifeq**， **else**， **endif**

```makefile
libs_for_gcc = -lgnu
normal_libs =

foo: $(objects)
ifeq ($(CC),gcc)
    $(CC) -o foo $(objects) $(libs_for_gcc)
else
    $(CC) -o foo $(objects) $(normal_libs)
endif
```

- 可见，在上面示例的这个规则中，目标 `foo` 可以根据变量 `$(CC)` 值来选取不同的函数库来编译程序。



## make的运行

- make命令执行后有三个退出码：
  - 0 表示成功执行。
  - 1 如果make运行时出现任何错误，其返回1。
  - 2 如果你使用了make的“-q”选项，并且make使得一些目标不需要更新，那么返回2。

- **默认寻找 makefile或Makefile文件**
- 也可以手动指定，`make –f hchen.mk`

