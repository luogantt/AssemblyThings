反汇编
这里插播一段反汇编的讲解。引入调试器和反汇编工具，我们后续将有更多机会对程序进行深入的分析，现阶段，我们先找一个简单的程序上手，熟悉一下操作和工具。

先安装gdb：
```
$ sudo apt-get install gdb -y
```
然后，我们把这个程序，保存为test.asm：
```
global main

main:
    mov eax, 1
    mov ebx, 2
    add eax, ebx
    ret
 ```
然后编译：
```
$ nasm -f elf test.asm -o test.o ; gcc -m32 test.o -o test
```
运行：
```
$ ./test ; echo $?
3
```
OK，到这里，程序是对的了。开始动刀子，使用gdb：
```
gdb ./test
```

启动之后，你会看到终端编程变成这样了：
```
(gdb) 
```

###### 第一步首先run 一下，这一步必须做，否则断点无法插入

```
run
```
OK，说明你成功了，接下来输入，并回车：

```
(gdb) set disassembly-flavor intel
```

这一步是把反汇编的格式调整称为intel的格式，稍后完事儿后你可以尝试不用这个设置，看看是什么效果。好了，继续，反汇编，输入命令并回车：
```
(gdb) disas main
Dump of assembler code for function main:
   0x00001190 <+0>:	mov    eax,0x1
   0x00001195 <+5>:	mov    ebx,0x2
   0x0000119a <+10>:	add    eax,ebx
   0x0000119c <+12>:	ret    
End of assembler dump.
```
好了，整个程序就在这里被反汇编出来了，请你先仔细看一看，是不是和我们写的源代码差不多？（后面多了两行汇编，你把它们当成路人甲看待就行了，不用理它）。





```
Starting program: /home/lg/code/assemb/10/test 
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
[Inferior 1 (process 5971) exited with code 03]
```
#### 动态调试
后面将继续介绍动态调试，帮助更加深入地理解汇编中的一些概念。现在先提示一些概念：

断点：程序在运行过程中，当它执行到“断点”对应的这条语句的时候，就会被强行叫停，等着我们把它看个精光，然后再把它放走
注意看反汇编代码，每一行代码的前面都有一串奇怪的数字，这串奇怪的数字指它右边的那条指令在程序运行时的内存中的位置（地址）。注意，指令也是在内存里面的，也有相应的地址。
好了，我们开始尝试一下调试功能，首先是设置一个断点，让程序执行到某一个地方就停下来，给我们足够的时间观察。在gdb的命令行中输入：
```
(gdb) break *0x00001195
```
后面那串奇怪的数字在不同的环境下可能不一样，你可以结合这里的代码，对照着自己的实际情况修改。（使用反汇编中<+5>所在的那一行前面的数字）

然后我们执行程序：
```
run
```
```
Starting program: /home/lg/code/assemb/10/test 
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Breakpoint 1, 0x56556195 in main ()
```


看到了吧，这下程序就被停在了我们设置的断点那个地方，对比着反汇编和你的汇编代码，找一找现在程序是停在哪个位置的吧。run后面提示的内容里，那一串奇怪的数字又出现了，其实这就是我们前面设置断点的那个地址。

好了，到这里，我们就把程序看个精光吧，先看一下eax寄存器的值：
```
(gdb) info register eax
eax            0x1  1
```
刚好就是1啊，在我们设置断点的那个地方，它的前面一个指令是mov eax, 1，这时候eax的内容就真的变成1了，同样，你还可以看一下ebx：
```
(gdb) info register ebx
ebx            0xf7f9f000          -134615040
```
ebx的值并不是2，这是因为mov ebx, 2这个语句还没有执行，所以暂时你看不到。那我们现在让它执行一下吧：
```
(gdb) stepi
0x080483fa in main ()
```
好了，输入stepi之后，到这里，程序在我们的控制之下，向后运行了一条指令，也就是刚刚执行了mov ebx, 2，这时候看下ebx：
```
(gdb) info register ebx
ebx            0x2  2
```
看到了吧，ebx已经变成2了。继续，输入stepi，然后看执行了add指令后的各个寄存器的值：
```
(gdb) stepi
0x080483fc in main ()
```
```
(gdb) info register eax
eax            0x3  3
```
执行完add指令之后，eax跟我们想的一样，变成了3。如果我不知道程序现在停在哪里了，怎么办？很简单，输入disas之后，又能看到反汇编了，同时gdb还会标记出当前断点所在的位置：
```
(gdb) disas
Dump of assembler code for function main:
   0x080483f0 <+0>: mov    eax,0x1
   0x080483f5 <+5>: mov    ebx,0x2
   0x080483fa <+10>:    add    eax,ebx
=> 0x080483fc <+12>:    ret    
   0x080483fd <+13>:    xchg   ax,ax
   0x080483ff <+15>:    nop
End of assembler dump.
```
现在刚好就在add执行过后的ret那个地方。这时候，如果你不想玩了，可以输入continue，让程序自由地飞翔起来，直到GG。
```
(gdb) continue
Continuing.
[Inferior 1 (process 1283) exited with code 03]
```
看到了吧，程序已经GG了，而且返回了一个数字03。这刚好就是那个eax寄存器的值嘛。



##### <font color=darkblue > 所有代码和命令行

###### <font color=darkred> 代码保存为test.asm：
```
global main

main:
    mov eax, 1
    mov ebx, 2
    add eax, ebx
    ret
 ```
 ###### <font color=darkred> 所有命令行
 ```
nasm -f elf test.asm -o test.o 
gcc -m32 test.o -o test
./test ; echo $?
gdb ./test
```
```
run
```
```
set disassembly-flavor intel
```
```
disas main
```

```
break *0x00001195
```
```
run
```
```
info register eax
```
```
info register ebx
```


 stepi

```
info register ebx
```

 stepi

```
 info register eax
```

```
continue
```

