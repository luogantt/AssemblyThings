##### 最近在看函数的栈帧 ，英文名称 stack  frame ，我看了国内和一些国外的文章，发现讲的都不是很清楚，今天就来说说，我不喜欢纯粹说理的文章。
###### 废话不多说，coding them 



###### 首先新建一个c 文件,姑且命名为 main.c
```
#include <stdio.h>
int NUM=100;
int n;
static int m= 36;
int sum(int _a,int _b)
{
    int c=0;
    c=_a+_b;
 
    return c;
}
 

int main()
{
    
    int a=10;
    int b=20; 

    int c ;

    printf("%p",&c); 
     printf("%p",&NUM);
    
    int ret=sum(a,b);
    return 0;
}
```

###### 编译一下，注意  -g 必须要加，我们这次要进入程序内部看看，要用一个工具 gdb
```
gcc -g -o  main main.c
./main
```

```
cc的地址是 0x7ffe45591048
NUM的地址是 0x55c8cffb9010
c的地址是 0x7ffe45591024
```


###### <font color=darkred> 我们发现一个问题，就是全局变量 NUM 和局部变量 cc 和c 的内存地址差距比较大，不是同一段代码吗，真么差距这么大呢


###### 那我们就进入计算机内部看看 
```
gdb main 
```

###### 这样我们就进来了首先我们简单设置一下，我们的cpu 是x86 架构，设置一下汇编格式

```
set disassembly-flavor intel 
```

###### 我们想看看代码，看看选择在哪里打断点

```
l(gdb) l
4	
5	int n;
6	
7	static int m= 36;
8	int sum(int _a,int _b)
9	{
10	    int c=0;
11	    c=_a+_b;
12	    printf("c的地址是 %p\n",&c);
13	    return c;
(gdb) l
14	}
15	 
16	 
17	int main()
18	{
19	    
20	    int a=10;
21	    int b=20; 
22	
23	    int cc ;
(gdb) l
24	
25	    printf("cc的地址是 %p\n",&cc);
26	    printf("NUM的地址是 %p\n",&NUM);
27	    int ret=sum(a,b);
28	    return 0;
29	}
(gdb) l

```

###### 打断点

```
b 10
```


```
b 20
```


```
b 21
```

```
b 27
```



###### 开始运行

```
r
```

###### 我们可以看到运行到了第20行，这下我们要停下来仔细看看
```
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 2, main () at main.c:20
20	    int a=10;

```

###### 

```
info frame
```


###### 我们看到 frame 在0x7fffffffdbb0， 我们看到  rip = 0x5555555551eb,在文章开头我们说过 全局变量 NUM 和局部变量 cc 和c 的内存地址差距比较大 也是 `cc的地址是 0x7ffe45591048        NUM的地址是 0x55c8cffb9010`
###### 当前的栈帧 位置是 在0x7fffffffdbb0

```c
(gdb) info frame
Stack level 0, frame at 0x7fffffffdbb0:
 rip = 0x5555555551eb in main (main.c:20); saved rip = 0x7ffff7da8d90
 source language c.
 Arglist at 0x7fffffffdba0, args: 
 Locals at 0x7fffffffdba0, Previous frame's sp is 0x7fffffffdbb0
 Saved registers:
  rbp at 0x7fffffffdba0, rip at 0x7fffffffdba8

```

###### 我们继续运行

```
n
```

```
info frame 
```


###### 当前的栈帧 位置是 frame at 0x7fffffffdbb0,发现栈帧没有变
```
(gdb) n 

Breakpoint 3, main () at main.c:21
21	    int b=20; 
(gdb) info frame 
Stack level 0, frame at 0x7fffffffdbb0:
 rip = 0x5555555551f2 in main (main.c:21); saved rip = 0x7ffff7da8d90
 source language c.
 Arglist at 0x7fffffffdba0, args: 
 Locals at 0x7fffffffdba0, Previous frame's sp is 0x7fffffffdbb0
 Saved registers:
  rbp at 0x7fffffffdba0, rip at 0x7fffffffdba8

```

###### 我们继续运行 0x7fffffffdbb0 还是没有变

```
(gdb) n
25	    printf("cc的地址是 %p\n",&cc);
(gdb) info frame 
Stack level 0, frame at 0x7fffffffdbb0:
 rip = 0x5555555551f9 in main (main.c:25); saved rip = 0x7ffff7da8d90
 source language c.
 Arglist at 0x7fffffffdba0, args: 
 Locals at 0x7fffffffdba0, Previous frame's sp is 0x7fffffffdbb0
 Saved registers:
  rbp at 0x7fffffffdba0, rip at 0x7fffffffdba8

```

###### 查看局部变量的地址，我们发现 a,b ,cc 的位置是彼此挨着的
```
$12 = (int *) 0x7fffffffdb8c
(gdb) p &a
$13 = (int *) 0x7fffffffdb8c
(gdb) p &b
$14 = (int *) 0x7fffffffdb90
(gdb) p &cc
$15 = (int *) 0x7fffffffdb88
```


###### 还是没有变frame at 0x7fffffffdbb0，在调用子函数 sum 之前 都没有变

```
(gdb) n 
NUM的地址是 0x555555558010

Breakpoint 4, main () at main.c:27
27	    int ret=sum(a,b);
(gdb) info frame 
Stack level 0, frame at 0x7fffffffdbb0:
 rip = 0x555555555232 in main (main.c:27); saved rip = 0x7ffff7da8d90
 source language c.
 Arglist at 0x7fffffffdba0, args: 
 Locals at 0x7fffffffdba0, Previous frame's sp is 0x7fffffffdbb0
 Saved registers:
  rbp at 0x7fffffffdba0, rip at 0x7fffffffdba8

```



###### 继续运行

```
n 
info frame
```



###### 我们 现在靠近了  int ret=sum(a,b);  但是我们还在main 函数中 frame at 0x7fffffffdbb0 没有变，好了小心了
```
(gdb) n
NUM的地址是 0x555555558010

Breakpoint 4, main () at main.c:27
27	    int ret=sum(a,b);
(gdb) info frame 
Stack level 0, frame at 0x7fffffffdbb0:
 rip = 0x555555555232 in main (main.c:27); saved rip = 0x7ffff7da8d90
 source language c.
 Arglist at 0x7fffffffdba0, args: 
 Locals at 0x7fffffffdba0, Previous frame's sp is 0x7fffffffdbb0
 Saved registers:
  rbp at 0x7fffffffdba0, rip at 0x7fffffffdba8
```



```
n
info frame
```

```
(gdb) n

Breakpoint 1, sum (_a=10, _b=20) at main.c:10
10	    int c=0;
(gdb) info frame 
Stack level 0, frame at 0x7fffffffdb80:
 rip = 0x55555555518a in sum (main.c:10); saved rip = 0x555555555241
 called by frame at 0x7fffffffdbb0
 source language c.
 Arglist at 0x7fffffffdb70, args: _a=10, _b=20
 Locals at 0x7fffffffdb70, Previous frame's sp is 0x7fffffffdb80
 Saved registers:
  rbp at 0x7fffffffdb70, rip at 0x7fffffffdb78
```


###### 我们发现 frame 的函数地址变了 从 frame at 0x7fffffffdbb0 变成了frame at 0x7fffffffdb80
###### 再重复一遍，我们发现 frame 的地址变了 从 frame at 0x7fffffffdbb0 变成了frame at 0x7fffffffdb80，从main 中到 sum 中
###### 再重复一遍，0x7fffffffdbb0到0x7fffffffdb80 是减小的，我的意思是，sum函数的frame 在 main 的下面，在低地址位置


```
==========   
|| main ||            高地址位置 -------->0x7fffffffdbb0

|| sum  ||            低地址位置 -------->0x7fffffffdb80
```


######  <font color=darkblue > 函数的栈帧 stack frame 这个名字非常好，主函数 main  在栈低，main 调用了sum  在栈顶，一个函数一个栈帧 (frame), 所有的frame 都在栈中，这就是函数栈帧的本意


######


######


