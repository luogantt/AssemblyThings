<div class="RichText ztext Post-RichText css-yvdm7v" options="[object Object]"><p data-first-child="" data-pid="hxrY__Qq">上回说到，咱们把环境搭好了，可以开始玩耍汇编了。</p><h2>寄存器是啥玩意儿？</h2><p data-pid="tkiyQD_2">开始学C的时候，有没有一种感觉，变量？类型？我可是要改变世界的男人，怎么就成天在跟i++较劲啊？这黑框程序还只能用来算数学，跟说好的不一样呢？？？想必后来，见得多了，你的想法也不那么幼稚了吧。</p><p data-pid="4x7w_1--">好了，接下来汇编也会给你同样一种感觉的。啥玩意儿？寄存器？寻址？说好的变量类型循环函数呢？。</p><p data-pid="nl-OKhP7">好了，我想先刻意避开这些晦涩难懂的东西，找到感觉了，再回头来研究条条框框。在此先把基本的几个简单的东西弄熟练，过早引入太多概念容易让人头昏眼花。</p><p data-pid="kbpgyaR2">这里就说寄存器，通俗地来解释一下。回到上小学的时候，现在有一大堆计算题：</p><div class="highlight"><pre><code class="language-text">99+10=
32-20=
14+21=
47-9=
87+3=
86-8=
...</code></pre></div><p data-pid="uNEvNPfM">正常来讲，要算出这个么多题目，你需要一支笔，一边计算的同时一边把结果写下来。</p><p data-pid="aOctUrrw">好了，到这里，我就来做个类比，助你大致理解寄存器是干啥用的。首先，我们把CPU和大脑做一个类比。</p><p data-pid="AEX_PyFf">你在纸上进行计算的时候，需要不断往纸上写下计算结果，一边在脑子里进行计算。大致过程就像：</p><div class="highlight"><pre><code class="language-text">1. 在纸上找一个题目，先看清两个数字，并迅速记下来
2. 在脑子里对这两个数字进行计算，计算出的结果也是记在脑子里的
3. 将计算结果写在纸上，继续做下一个题目</code></pre></div><p data-pid="kqmm4pK-">好了，这个过程就和计算机执行的过程有几分相似。草稿纸就相当于是个内存，脑子就是CPU。</p><p data-pid="0NQQDjCJ">在计算的时候，你需要知道计算的两个数字，而且还得知道是做什么运算，这些信息都是从草稿纸上看见之后，短暂记忆在脑子里的。</p><p data-pid="ETu_msZf">CPU在计算的时候也是一样，需要知道要计算的数据是什么，还得知道是做什么运算，这些信息也需要临时保存在CPU的某个地方。这个地方就是寄存器。</p><p data-pid="HB4M4bsF">好了到这里，不知道你有没有看明白？也就是说CPU里头的寄存器的作用，就像我们在做计算的时候会临时在脑子里记住数字一样。当然你的脑子能记住不止一个数据，CPU也不止一个寄存器。</p><h2>为啥C语言里没有说这些？</h2><p data-pid="XOcVFJSy">就是因为写汇编语言的时候，要在有限的寄存器情况下，编写复杂的程序，还要考虑灵活性、性能、正确性等等乱七八糟的问题，对于程序员是一个超级大的负担。</p><p data-pid="sFhRLpb9">因此有人专门发明了许多更方便好用的“高级语言”，然后还专门写了个配套的程序能够把用这个“高级语言”写的东西翻译成汇编语言，再将汇编语言翻译成机器能执行的指令。其中之一就是C语言。也就是C语言发明出来就是奔着比汇编语言好用的目标去的。所以啊，相比汇编这种繁琐复杂的编程方式，高级语言不知道高级到哪里去了。</p><h3>那学习汇编语言有用吗？</h3><p data-pid="pDrFGPAG">没有。</p><h2>开始一顿乱写</h2><p data-pid="b3u7uMY2">好了，先介绍个程序，运行完了能够开心一下：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov eax, 1
    mov ebx, 2
    add eax, ebx
    ret</code></pre></div><p data-pid="zqUYzyfd">老套路，保存成文件，比如叫做nmb.asm，然后编译运行：</p><div class="highlight"><pre><code class="language-text">$ nasm -f elf nmb.asm -o nmb.o
$ gcc -m32 nmb.o -o nmb
$ ./nmb ; echo $?
3</code></pre></div><p data-pid="MIlylDaa">如果你能看出来这里面的端倪，说明你是一个聪明伶俐的天才。不就是做了个算术题1+2=3么。</p><p data-pid="PR_zdOih">好了我们来看一下这个程序。里面的eax就是指代的寄存器。同理ebx也是一个寄存器。也就是这个CPU在做计算题的时候至少能够记住两个数字，实际上，它有更多寄存器，稍后再慢慢说。</p><p data-pid="DJxfBkNJ">OK。既然找到一些感觉了，就继续胡乱地拍出一大堆程序来先玩个够吧：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov eax, 1
    add eax, 2
    add eax, 3
    add eax, 4
    add eax, 5
    ret</code></pre></div><div class="highlight"><pre><code class="language-text">global main
main:
    mov eax, 1
    mov ebx, 2
    mov ecx, 3
    mov edx, 4
    add eax, ebx
    add eax, ecx
    add eax, edx
    ret</code></pre></div><p data-pid="VG9GJO9H">至于这两个程序是什么结果，你自己玩吧。不动手练练怎么学得好。</p><h2>指令</h2><p data-pid="omPn1-WE">指令就像是你发给CPU的一个个命令，你让它做啥它就做啥。当然了，前提是CPU得支持对应的功能，CPU是没有“吃饭”功能的，你也写不出让它”吃饭“的指令来。</p><p data-pid="QGMfpsOJ">前面我们共用到了三个指令：分别是mov、add、ret。</p><p data-pid="T1BcwqDZ">我来逐个解释这些指令：</p><ul><li data-pid="wJa8Qm3H">mov</li></ul><p data-pid="L8AajpUA">数据传送指令，我们可以像下面这样用mov指令，达到数据传送的目的。</p><div class="highlight"><pre><code class="language-text">mov eax, 1          ; 让eax的值为1（eax = 1）
mov ebx, 2          ; 让ebx的值为2（ebx = 2）
mov ecx, eax        ; 把eax的值传送给ecx（ecx = eax）</code></pre></div><ul><li data-pid="1q2xizAc">add</li></ul><p data-pid="6JfgfYhk">加法指令</p><div class="highlight"><pre><code class="language-text">add eax, 2          ; eax = eax + 2
add ebx, eax        ; ebx = ebx + eax</code></pre></div><ul><li data-pid="vtX0C0JJ">ret</li></ul><p data-pid="pZLRbq-I">返回指令，类似于C语言中的return，用于函数调用后的返回（后面细说）。</p><h3>为啥指令长得这么丑？和我想的不一样？</h3><p data-pid="T_gkMHjF">首先，CPU里是一坨电路，有的功能对于人来说可能很简单，但是对于想要用电路来实现这个功能的人来说，就不一定简单了。这是需要明白的第一个道理。</p><p data-pid="3oVzrIyT">所以啊，这长得丑是有原因的。其中一个原因就是，某些长的漂亮的功能用电路实现起来超级麻烦，所以干脆设计丑一点，反正到时候这些古怪的指令能够组合出我想要的功能，也就足够了。</p><p data-pid="TBgk4nTM">所以，汇编语言蛋疼就在这些地方：</p><ul><li data-pid="Rm6N7Hks">为了迁就电路的设计，很多指令不一定会按照朴素的思维方式去设计</li><li data-pid="E0pGaOR_">需要知道CPU的工作原理，否则都不知道该怎么组织程序</li><li data-pid="X3rM9AQ2">程序复杂之后，连我自己都看不懂了，虽然能够运行得到正确的结果</li><li data-pid="mWDCszhk">...</li></ul><p data-pid="AWLwP0fF">按道理，随着技术的发展，指令应该越来越好看，越来越符合人的思考方式才对啊。然而，世事难料，自从出现了高级语言，多数编程场景下，已经不需要关心指令和寄存器到底长啥样了，这个事情已经由编译器代劳了，99%甚至更多的程序员不需关心寄存器和指令了。所以，长得不好看就算了，反正也没什么人看。</p><p data-pid="pFVHKWha">好了，按照前面的介绍，接下来再继续了解一些东西：</p><h3>更多指令、更多寄存器</h3><ul><li data-pid="cCtDL7Rs">sub</li></ul><p data-pid="HquoKSye">减法指令（用法和加法指令类似）</p><div class="highlight"><pre><code class="language-text">sub eax, 1              ; eax = eax - 1
sub eax, ecx            ; eax = eax - ecx</code></pre></div><p data-pid="qvM4ZtVv">乘法和除法、以及更多的运算，这里就不再介绍了，这里的重点是为汇编学习带路。</p><ul><li data-pid="-wqaGHjx">更多寄存器</li></ul><p data-pid="ETxedzhb">除了前面列举的eax、ebx、ecx、edx之外，还有一些寄存器：</p><div class="highlight"><pre><code class="language-text">esi
edi
ebp</code></pre></div><p data-pid="NrR4wWJr">其中eax、ebx、ecx、edx这四个寄存器是通用寄存器，可以随便存放数据，也能参与到大多数的运算。而余下的三个多见于一些访问内存的场景下，不过，目前，你还是可以随便抓住一个就拿来用的。</p><h2>总结</h2><p data-pid="FwCdM4BT">到这里，赶紧根据前面了解的东西，多写几遍吧，加深一下印象。</p><p data-pid="1l1uux7O">前面说的学习汇编没用，是瞎说的。学习汇编有用，后面想起来了再说。</p></div>
