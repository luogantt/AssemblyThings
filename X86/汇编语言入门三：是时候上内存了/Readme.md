[原文](https://zhuanlan.zhihu.com/p/23722940)

<div class="RichText ztext Post-RichText css-yvdm7v" options="[object Object]"><p data-first-child="" data-pid="uI444bze">上回说到了寄存器和指令，这回说下内存访问。开始之前，先来复习一下。</p><h1>回顾</h1><h2>寄存器</h2><ul><li data-pid="9ABGRp61">寄存器是在CPU里面</li><li data-pid="nnBp2YhB">寄存器的存储空间很小</li><li data-pid="L55qk3dh">寄存器存放的是CPU马上要处理的数据或者刚处理出的结果（还是热乎的）</li></ul><h2>指令</h2><ul><li data-pid="IsPSoasG">传送数据用的指令mov</li><li data-pid="j94pRcxS">做加法用的指令add</li><li data-pid="ZQnTzDrK">做减法用的指令sub</li><li data-pid="WyZFR-mh">函数调用后返回的指令ret</li></ul><h1>指针和内存</h1><h2>高能预警</h2><p data-pid="DqUAayR_">高能预警，后面会涉及到一些高难度动作，请提前做好以下准备：</p><ul><li data-pid="vJpDVeyI">精通2进制和16进制加减法</li><li data-pid="7vKCUTL3">精通2进制表示与16进制表示之间的关系</li><li data-pid="gfJ6xT7Y">精通8位、16位、32位、64位二进制数的16进制表示</li></ul><p data-pid="ltbi8u_d">举个例子，一个16进制数0BC71820，其二进制表示为：</p><div class="highlight"><pre><code class="language-text">00001011 11000111 00011000 00100000</code></pre></div><p data-pid="m-tpZFux">你能快速地找到它们之间的对应关系吗？不会的话快去复习吧。</p><h2>寄存器宽度</h2><p data-pid="JpL1Bf0L">现在，为了简便，我们只讨论32位宽的寄存器。也就是说，目前我们讨论的寄存器，它的宽度都是32位的，也就是里面存放了一个32位长的2进制数。</p><p data-pid="mB6tldUD">通常，一个字节为8个二进制比特位，那么一个32位长的二进制数，那么它的大小就应该是4个字节。也就是把32位长的寄存器写入到内存里，会覆盖掉四个字节的存储空间。</p><h2>内存</h2><p data-pid="jS9GSJ1v">想必内存大家心里都比较有数，就是暂时存放CPU计算所需的指令和数据的地方。</p><p data-pid="KfHNoXDR">诶？那前面说好的寄存器呢？寄存器也是类似的功能啊。对的，寄存器有类似功能，理论上一个最小的计算系统只需要寄存器和CPU的计算部件（ALU）就够了。不过，实际情况更加复杂一些，还是拿计算题举例，这次更复杂了：</p><p data-pid="IAetefut">（这里的例子只够说明寄存器和内存的角色区别，而非出现内存和寄存器这样角色的根本原因）</p><div class="highlight"><pre><code class="language-text">( 847623785 * 12874873 + 274632 ) / 999 =</code></pre></div><p data-pid="qZ_2NNCc">好了，这个题目就不像前面的那么简单了，首先你肯定没法直接在脑子里三两下就算出来，还是得需要一个草稿纸了。</p><p data-pid="Lw4TPI_f">计算过程中，你还是会把草稿纸上正在计算的几个数字记在脑子里，然后快速地算完并记下来，然后往草稿纸上写。</p><p data-pid="eC8cXrC0">最后，在草稿纸上演算完毕后，你会把最终结果写到试卷上。</p><p data-pid="Zv3REXSm">好了，这里的草稿纸就相当于是内存了。它也充当一个临时记录数据的作用，不过它的容量就比自己的脑子要大得多了，而且一旦你把东西写下来，也就不那么担心忘记了。</p><p data-pid="of6yei4r">诶？我不能多做点寄存器，就不需要单独的内存了呀？是的，理论上是这样，然而，实际上如果多做一点寄存器的话，CPU就要卖$9999999一片了，贵啊（具体原因可以了解SRAM与DRAM）。</p><p data-pid="cCw9ewAZ">也就是说，在计算机系统里，寄存器和内存都充当临时存储用，但是寄存器太小也太少了，内存就能帮个大忙了。</p><h2>指针</h2><p data-pid="PovKXoWP">在C语言里面，有个神奇的东西叫做指针，它是初学者的噩梦，也是高手的天堂。</p><p data-pid="PWqtBbk0">这里不打算给不明白指针的人讲个明白，直接进入正题。首先，内存是一个比较大的存储器，里面可以存放非常非常多的字节。</p><p data-pid="y5ARSRcD">好了，现在我们来为整个内存的所有字节编号，为了方便，咱们首先考虑按照字节为单位连续编号：</p><div class="highlight"><pre><code class="language-text">  0  1  2  3  4  5  6  7              ...
.........................           ......................
|12|b7|33|e8|66|4c|87|3c|    ...    |cc|cc|cc|cc|cc|cd|cd|
```````````````````````````````````````````````</code></pre></div><p data-pid="XzcUwhOn">大概意思一下，你可以想象每一个格子就是一个字节，每个格子都有编号，相邻的格子的编号也是相邻的。这个编号，你就可以理解为所谓的指针或者地址（这里不严格区分指针与地址）。那么当我需要获取某个位置的数据时，那么我们只需要一个编号（也就是地址）就知道在哪些格子里获取数据了，当然，写入数据也是一样的道理。</p><p data-pid="-aXPLn1L">到这里，我们大概清楚了访问内存的时候需要一些什么东西：</p><ul><li data-pid="m515WHrR">首先得有内存</li><li data-pid="eUfxITGP">要访问内存的哪个位置（编号，地址）</li></ul><p data-pid="bCBWrgpR">那，我哪知道地址是多少呢？别介，这不是重点，你不需要知道地址具体是多少，你只需要知道它是个地址，按照正确的方式去思考和使用就行了。继续。</p><h1>mov指令还没完</h1><p data-pid="BT20cIOQ">前面说到，寄存器可以临时存储计算所需数据和结果，那么，问题来了，寄存器也就那么几个，用完了咋办？你能发现这个问题，说明你有成为大佬的潜质。接下来，说正事。</p><p data-pid="S6qE_6qT">前面说到了mov指令，可以将数据送入寄存器，也可以将一个寄存器的数据送到另一个寄存器，像这样：</p><div class="highlight"><pre><code class="language-text">mov eax, 1
mov ebx, eax</code></pre></div><p data-pid="JLno4v8v">好了，这还没完，mov指令可谓是x86中花样比较多的指令了，前面的两种情形都还是比较简单的情形，今天我们来扯一下更复杂的。</p><h2>寄存器不够用了</h2><p data-pid="-DnYuYJA">现在，某个很复杂的运算让你感觉寄存器不够用了，怎么办？按照前面说的意思，要把寄存器的东西放到内存里去，把寄存器的空间腾出来，就可以了。</p><p data-pid="QvsD79Od">好的思路有了，可是，怎么把寄存器的数据丢到内存里去呢？还是使用mov指令，只是写法不同了：</p><div class="highlight"><pre><code class="language-text">mov [0x5566], eax</code></pre></div><p data-pid="cNUBcTJ5">好了，现在，请全神贯注。这条指令就是将寄存器的数据丢到内存里去。再多看几眼，免得看得不够顺眼：</p><div class="highlight"><pre><code class="language-text">mov [0x0699], eax
mov [0x0998], ebx
mov [0x1299], ecx
mov [0x1499], edx
mov [0x1999], esi</code></pre></div><p data-pid="gu-YiSrE">好了，应该已经脸熟了。</p><p data-pid="ZrAkkmIx">现在，我告诉你，最前面那个指令mov [0x5566], eax的作用：</p><p data-pid="gcSP6qJk">将eax寄存器的值，保存到编号为0x5566对应的内存里去，按照前面的说法，一个eax需要4个字节的空间才装得下，所以编号为0x5566 0x5567 0x5568 0x5569这四个字节都会被eax的某一部分覆盖掉。</p><p data-pid="inQ9mFag">好了，我们已经了解了如何将一个寄存器的值保存到内存里去，那么我怎么把它取出来呢？</p><div class="highlight"><pre><code class="language-text">mov eax, [0x0699]
mov ebx, [0x0998]
mov ecx, [0x1299]
mov edx, [0x1499]
mov esi, [0x1999]</code></pre></div><p data-pid="OcxmH8PH">反过来写就是了，比如mov eax, [0x0699]就表示把0x0699这个地址对应那片内存区域中的后4个字节取出来放到eax里面去。</p><h3>到此</h3><p data-pid="iNhZJjst">到这，我们已经学会了如何把寄存器的数据临时保存到内存里，也知道怎么把内存里的数据重新放回寄存器了。</p><h1>动手编程</h1><p data-pid="o4swSaSE">接下来，该动手操练了。先来一个题目：</p><p data-pid="5vig9u6i">假设我们现在有一个比较蛋疼的要求，就是把1和2相加，然后把结果放到内存里面，最后再把内存里的结果取出来。（好无聊的题目）</p><p data-pid="gOLR5zkH">那么按理说，我们就应该这么写代码：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov ebx, 1
    mov ecx, 2
    add ebx, ecx
    mov [0x233], ebx
    mov eax, [0x233]
    ret</code></pre></div><p data-pid="hWUB5tlZ">好了，编译运行，假如程序是danteng，那么运行结果应该是这样：</p><div class="highlight"><pre><code class="language-text">$ ./danteng ; echo $?
3</code></pre></div><p data-pid="Fp--KsRy">实际上，并不能行。程序挂了，没有输出我们想要的结果。</p><p data-pid="IP22Bnlr">这是在逗我呢？别急，按理说，前面说的都是没问题的，只是这里有另外一个问题，那就是“我们的程序运行在一个受管控的环境下，是不能随便读写内存的”。这里需要特殊处理一下，至于具体为何，后面有机会再慢慢叙述，这不是当下的重点，先照抄就是了。</p><p data-pid="uvVopGCC">程序应该改成这样才行：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov ebx, 1
    mov ecx, 2
    add ebx, ecx
    mov [sui_bian_xie], ebx
    mov eax, [sui_bian_xie]
    ret
section .data
sui_bian_xie   dw    0</code></pre></div><p data-pid="fDYpAc4-">好了这下运行，我们得到了结果：</p><div class="highlight"><pre><code class="language-text">$ ./danteng ; echo $?
3</code></pre></div><p data-pid="IxIW7PH5">好了，有了程序，咱们来梳理一下每一条语句的功能：</p><div class="highlight"><pre><code class="language-text">mov ebx, 1                   ; 将ebx赋值为1
mov ecx, 2                   ; 将ecx赋值为2
add ebx, ecx                 ; ebx = ebx + ecx
    
mov [sui_bian_xie], ebx      ; 将ebx的值保存起来
mov eax, [sui_bian_xie]      ; 将刚才保存的值重新读取出来，放到eax中
    
ret                          ; 返回，整个程序最后的返回值，就是eax中的值</code></pre></div><p data-pid="fESaEELp">好了，到这里想必你基本也明白是怎么一回事了，有几点需要专门注意的：</p><ul><li data-pid="2zTYsI8i">程序返回时eax寄存器的值，便是整个程序退出后的返回值，这是当下我们使用的这个环境里的一个约定，我们遵守便是</li></ul><p data-pid="koK6h8Wn">与前面那个崩溃的程序相比，后者有一些微小的变化，还多了两行代码</p><div class="highlight"><pre><code class="language-text">section .data
sui_bian_xie   dw    0</code></pre></div><p data-pid="N0jhi76-">第一行先不管是表示接下来的内容经过编译后，会放到可执行文件的数据区域，同时也会随着程序启动的时候，分配对应的内存。</p><p data-pid="KV6rw0co">第二行就是描述真实的数据的关键所在里，这一行的意思是开辟一块4字节的空间，并且里面用0填充。这里的dw（double word）就表示4个字节，前面那个sui_bian_xie的意思就是这里可以随便写，也就是起个名字而已，方便自己写代码的时候区分，这个sui_bian_xie会在编译时被编译器处理成一个具体的地址，我们无需理会地址具体时多少，反正知道前后的sui_bian_xie指代的是同一个东西就行了。</p><h2>疯狂的写代码</h2><p data-pid="AHqDYMX-">好了，有了这一个程序作铺垫，我们继续。趁热打铁，继续写代码，分析代码：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov ebx, [number_1]
    mov ecx, [number_2]
    add ebx, ecx
    mov [result], ebx
    mov eax, [result]
    ret
section .data
number_1      dw        10
number_2      dw        20
result        dw        0</code></pre></div><p data-pid="CJCD4i5T">好了，自己琢磨着写代码，运行程序，然后分析程序每一条指令都在干什么。还有，这个程序本身还可以精简，如果你已经发现了，那说明你老T*棒了。</p><div class="highlight"><pre><code class="language-text">global main

main:
    mov eax, [number_1]
    mov ebx, [number_2]
    add eax, ebx
    
    ret

section .data
number_1      dw        10
number_2      dw        20</code></pre></div><p data-pid="sVvrRb_4">好了，好好分析比较上面的几个程序，基本这一块就了解得差不多了。随着了解的逐渐深入，我们后续还会介绍更多更复杂，更全面的内容。</p><h1>反汇编</h1><p data-pid="3hpM2qVd">这里插播一段反汇编的讲解。引入调试器和反汇编工具，我们后续将有更多机会对程序进行深入的分析，现阶段，我们先找一个简单的程序上手，熟悉一下操作和工具。</p><p data-pid="KWfj1v7n">先安装gdb：</p><div class="highlight"><pre><code class="language-text">$ sudo apt-get install gdb -y</code></pre></div><p data-pid="85UNWeo2">然后，我们把这个程序，保存为test.asm：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov eax, 1
    mov ebx, 2
    add eax, ebx
    ret</code></pre></div><p data-pid="F2igUlTt">然后编译：</p><div class="highlight"><pre><code class="language-text">$ nasm -f elf test.asm -o test.o ; gcc -m32 test.o -o test</code></pre></div><p data-pid="-SiYRZH3">运行：</p><div class="highlight"><pre><code class="language-text">$ ./test ; echo $?
    
3</code></pre></div><p data-pid="hm8G_qbF">OK，到这里，程序是对的了。开始动刀子，使用gdb：</p><div class="highlight"><pre><code class="language-text">$ gdb ./test</code></pre></div><p data-pid="KtbnwNp-">启动之后，你会看到终端编程变成这样了：</p><div class="highlight"><pre><code class="language-text">(gdb) </code></pre></div><p data-pid="DuR6wT-4">OK，说明你成功了，接下来输入，并回车：</p><div class="highlight"><pre><code class="language-text">(gdb) set disassembly-flavor intel</code></pre></div><p data-pid="V2hiux-A">这一步是把反汇编的格式调整称为intel的格式，稍后完事儿后你可以尝试不用这个设置，看看是什么效果。好了，继续，反汇编，输入命令并回车：</p><div class="highlight"><pre><code class="language-text">(gdb) disas main
Dump of assembler code for function main:
   0x080483f0 &lt;+0&gt;: mov    eax,0x1
   0x080483f5 &lt;+5&gt;: mov    ebx,0x2
   0x080483fa &lt;+10&gt;:    add    eax,ebx
   0x080483fc &lt;+12&gt;:    ret    
   0x080483fd &lt;+13&gt;:    xchg   ax,ax
   0x080483ff &lt;+15&gt;:    nop
End of assembler dump.
(gdb) </code></pre></div><p data-pid="nbVM9Ay7">好了，整个程序就在这里被反汇编出来了，请你先仔细看一看，是不是和我们写的源代码差不多？（后面多了两行汇编，你把它们当成路人甲看待就行了，不用理它）。</p><h3>



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

