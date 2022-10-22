# Makefile笔记

## 概述

- makefile带来的好处就是——“自动化编译”

- make是一个命令工具，是一个解释makefile中指令的命令工具

本文仅针对GNU的make进行讲述

#### 程序的编译与链接

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

