<div class="RichText ztext Post-RichText css-yvdm7v" options="[object Object]"><p data-first-child="" data-pid="XUXJ9EUT">最近忙了一阵，好几天没更了，不好意思，我来晚了。</p><p data-pid="T6FAU0PH">转入正题，当在汇编中进行函数调用，是一种什么样的体验？</p><h1>想象</h1><p data-pid="6AXRexKL">想象你在计算一个非常复杂的数学题，在算到一半的时候，你需要一个数据，而这个数据需要套用一个比较复杂的公式才能算出来，怎么办？</p><p data-pid="Msv9QrVr">你不得不把手中的事情停下来，先去套公式、代入数值然后...最后，算出结果来了。</p><p data-pid="NjCD8e3g">这时候你继续开始攻克这个困难题目的剩下部分。</p><h2>用脑子想</h2><p data-pid="uOtC9-k7">刚刚说的这个过程，可能有点小问题，尤其是对脑子不太好使的人来说。想象你做题目做到一半的时候，记忆力已经有点不好使了，中间突然停下来去算一个复杂的公式，然后回来，诶？我刚刚算到哪了？我刚刚想到哪了？我刚刚算了些什么结果？</p><p data-pid="w3xtiK2M">在你工作切换的时候，很容易回头来就忘记了刚刚做的部分事情。这时候，为了保证你套完复杂的公式，把结果拿回来继续算题目的时候不会出差错，你需要把刚才计算题目过程中的关键信息写在纸上。</p><h2>用CPU想</h2><p data-pid="sl0eHDmB">刚刚去套用一个复杂的公式计算某个数据的情景，就类似在计算机里进行函数调用的情景。</p><p data-pid="j4RNIgt8">程序需要一个结果，这个结果需要通过一个比较复杂的过程进行计算。这时候，编程人员会考虑将这个独立的复杂过程提取为单独的函数。</p><p data-pid="Lxyxlyad">而在发生函数调用的时候，CPU就像是先暂停当前所做的事情，转去做那个复杂的计算，算完了之后又跳回来继续整个计算。就像你做题的过程中去套了一个公式计算数据一样。</p><p data-pid="KiZQjkqX">但是在去套用公式之前，你需要做一些准备。首先，默默记下现在这个题目算到哪一步了，一会套完公式回来接着做；默默记下现在计算出来的一些结果，一会可能还会用到；套用公式需要些什么数据，先记下来，代公式的时候直接代入计算，算出来的结果也需要记在脑子里，回头需要使用。</p><p data-pid="s0Sg6qzk">在CPU里面，也需要这几个过程。</p><p data-pid="PmGQmbCY">第一个，记下自己现在做事情做到哪里了，一会儿套完公式回来接着做，这也就是CPU在进行函数调用时的现场保存操作，CPU也需要记下自己当前执行到哪里了。</p><p data-pid="utbkLFlp">默默记下一些在套用公式的时候需要用到的数据，然后去套公式了。这也就是程序中在调用函数的时候进行参数传递的过程。</p><p data-pid="vSKTHy4E">然后开始执行函数，等函数执行完了，就需要把结果记下来，回去继续刚才要用到数据的那个地方继续算。这也就是函数调用后返回的动作，这个记下的结果就是返回值。</p><h1>开撸</h1><p data-pid="s9vTF2KH">说了那么多故事，那么函数调用要干些啥应该就说清楚了。总结一下大概就这么几个事：</p><ul><li data-pid="in29fY0A">保存现场（一会好回来接着做）</li><li data-pid="nD-AccLZ">传递参数（可选，套公式的时候需要些什么数据）</li><li data-pid="_xLcyUQK">返回（把计算结果带回来，接着刚才的事）</li></ul><p data-pid="12nQAfXr">到这里，我们先来一个事例代码，就着代码去发现函数调用中的套路：</p><div class="highlight"><pre><code class="language-text">global main
eax_plus_1s:
    add eax, 1
    ret
ebx_plus_1s:
    add ebx, 1
    ret
main:
    mov eax, 0
    mov ebx, 0
    call eax_plus_1s
    call eax_plus_1s
    call ebx_plus_1s
    add eax, ebx
    ret</code></pre></div><p data-pid="0632XWlw">首先，运行程序，得到结果：3。</p><p data-pid="B_C1HRx8">上面的代码其实也比较简单，先从主干main这个地方梳理：</p><ul><li data-pid="fffrjgoy">让eax和ebx的值都为0</li><li data-pid="QeLQZOzA">调用eax_plus_1s，再调用eax_plus_1s</li><li data-pid="n273EHDP">调用ebx_plus_1s</li><li data-pid="EyXQz9Sn">执行eax = eax + ebx</li></ul><p data-pid="xcGUTYxm">上述的两个函数也非常简单，分别就是给eax和ebx加了1。所以，这个程序其实也就是换了个花样给寄存器增加1而已，纯粹演示。</p><p data-pid="Wc3OXIG6">这里出现了一个陌生指令call，这个指令是函数调用专用的指令，从程序的行为上看应该是让程序的执行流程发生跳转。前面说到了跳转指令jmp，这里是call，这两个指令都能让CPU的eip寄存器发生突然变化，然后程序就一下子跳到别的地方去了。但是这两个有区别：</p><blockquote data-pid="vZPgGF6Z"><p data-pid="bIq_rvO4">很简单，jmp跳过去了就不知道怎么回来了，而通过call这种方式跳过去后，是可以通过ret指令直接回来的</p></blockquote><p data-pid="0otEOzAY">那这是怎么做到的呢？</p><blockquote data-pid="Gxd5gc-W"><p data-pid="1pFKmOFl">其实，在call指令执行的时候，CPU进行跳转之前还要做一个事情，就是把eip保存起来，然后往目标处跳。当遇到ret指令的时候，就把上一次call保存起来的eip恢复回来，我们知道eip直接决定了CPU会执行哪里的代码，当eip恢复的时候，就意味着程序又会到之前的位置了。</p></blockquote><p data-pid="ozGRsva-">一个程序免不了有很多次call，那这些eip的值都是保存到哪里的呢？</p><blockquote data-pid="BLm3M3eV"><p data-pid="86vhV8Ab">有一个地方叫做“栈(stack)”，是程序启动之前，由操作系统指定的一片内存区域，每一次函数调用后的返回地址都存放在栈里面</p></blockquote><p data-pid="5MSkg8Pi">好了，我们到这里，就明白了函数调用大概是怎么回事了。总结起来就是：</p><ul><li data-pid="pQ29xAl9">本质上也是跳转，但是跳到目标位置之前，需要保存“现在在哪里”的这个信息，也就是eip</li><li data-pid="WmFY1SRw">整个过程由一条指令call完成</li><li data-pid="MHA5_KZu">后面可以用ret指令跳转回来</li><li data-pid="Uz5l6JFk">call指令保存eip的地方叫做栈，在内存里，ret指令执行的时候是直接取出栈中保存的eip值，并恢复回去达到返回的效果</li></ul><h1>何为栈？</h1><p data-pid="zLbnGUik">前面说到call指令会先保存eip的值到栈里面，然后就跳转到目标函数中去了。</p><p data-pid="0kA74SLq">这都好说，但是，如果是我在函数里面调用了一个函数，在这个函数里面又调用了一个函数，这个eip是怎么保存来保证每一次都能正确的跳回来呢？</p><p data-pid="FNdHiB0p">好的，这个问题才是关键，这也说到了栈这样一个东西，我们先来设想一些场景，结合实际代码理解一下CPU所对应的栈。</p><p data-pid="iKv7rk1M">首先，这个栈和数据结构中的栈是不一样的。数据结构中的栈是通过编程语言来形成程序执行逻辑上的栈。而这里的栈，是CPU内硬件实现的栈。当然了，两者在逻辑上都差不多的。</p><p data-pid="e2ygiMi3">在这里，先回想一下数据结构中基于数组实现的栈。里面最关键的就是需要一个栈顶指针（或者是一个索引、下标），每次放东西入栈，就将指针后移，每一次从栈中取出东西来，就将指针前移。</p><p data-pid="4W4x7CUg">到这里，我们先从逻辑上分析下CPU在发生函数调用的过程中是如何使用栈的。</p><p data-pid="o-P3c1K-">假设现在程序处在一个叫做level1的位置，并调用了函数A，在调用的跳转发生之前，会将当前的eip保存起来，这时候，栈里面就是这样的：</p><div class="highlight"><pre><code class="language-text">----------    &lt;=   top
  level1
----------</code></pre></div><p data-pid="zY7jPSdg">现在，程序处在level2的位置，又调用了函数B，同样，也会保存这次的eip进去：</p><div class="highlight"><pre><code class="language-text">----------    &lt;=   top
  level2
----------
  level1
----------</code></pre></div><p data-pid="4sWvx9xw">再来，程序这次处在level3，调用了C函数，这时候，整个栈就是这样的：</p><div class="highlight"><pre><code class="language-text">----------    &lt;=   top
  level3
----------
  level2
----------
  level1
----------</code></pre></div><p data-pid="DaUs5UUh">好了，这下程序执行到了ret，会发生什么事，是不是就回到level3了？在level3中再次执行ret，是不是就回到level2了？以此类推，最终，程序就能做到一层层的函数调用和返回了。</p><h2>实际的CPU中</h2><p data-pid="x5PvvcIU">在实际的CPU中，上述的栈顶top也是由一个寄存器来记录的，这个寄存器叫做esp(stack pointer)，每次执行call指令的时候。</p><p data-pid="4X4but9M">这里还有一个小细节，在x86的环境下，栈是朝着低地址的方向伸长的。什么意思呢？每一次有东西入栈，那么栈顶指针就会递减一个单位，每一次出栈，栈顶指针就会相应地增加一个单位（和数据结构中一般的做法是相反的）。至于为什么会这样，我也不知道。</p><p data-pid="yV0MmfP1">eip在入栈的时候，大致就相当于执行了这样一些指令：</p><div class="highlight"><pre><code class="language-text">sub esp, 4
mov dword ptr[esp], eip</code></pre></div><p data-pid="90zMu3Gk">翻译为C语言就是（假如esp是一个void*类型的指针）：</p><div class="highlight"><pre><code class="language-text">esp = (void*)( ((unsigned int)esp) - 4 )
*( (unsigned int*) esp ) = (unsigned int) eip</code></pre></div><p data-pid="fn53HkiK">也就是esp先移动，然后再把eip的值写入到esp指向的内存中。那么，ret执行的时候该干什么，也就非常的清楚了吧。无非就是上述过程的逆过程。</p><p data-pid="9gTQ0msv">同时，eip寄存器的长度为32位，即4字节，所以每一次入栈出栈的单位大小都是4字节。</p><h2>动手</h2><p data-pid="7FSyujLK">没有代码，说个锤子。先来一个简单的程序：</p><div class="highlight"><pre><code class="language-text">global main
eax_plus_1s:
    add eax, 1
    ret
main:
    mov eax, 0
    call eax_plus_1s
    ret</code></pre></div><p data-pid="bL233SxY">这个程序中只有一个函数调用，但不影响我们分析。先编译，得到一个可执行文件，这里先起名为plsone。</p><p data-pid="CI1HDEgG">然后载入gdb进行调试，进行反汇编：</p><div class="highlight"><pre><code class="language-text">$ gdb ./plsone
(gdb) disas main
Dump of assembler code for function main:
   0x080483f4 &lt;+0&gt;: mov    $0x0,%eax
   0x080483f9 &lt;+5&gt;: call   0x80483f0 &lt;eax_plus_1s&gt;
   0x080483fe &lt;+10&gt;:    ret    
   0x080483ff &lt;+11&gt;:    nop
End of assembler dump.</code></pre></div><p data-pid="BpB0mxgK">好了，找到反汇编中&lt;+5&gt;所在那一行，对应着的指令是call 0x80483f0，这个指令的地址为：0x080483f9（不同的环境有所不同，根据实际情况来）。按照套路，在这个call指令处打下一个断点，然后运行程序。</p><div class="highlight"><pre><code class="language-text">(gdb) b *0x080483f9 
Breakpoint 1 at 0x80483f9
(gdb) run
Starting program: /home/vagrant/code/asm/07/plsone 

Breakpoint 1, 0x080483f9 in main ()
(gdb)</code></pre></div><p data-pid="kSoQN-AS">好了，程序执行到断点处，停下来了。再来看反汇编，这次有一个小箭头指向当前的断点了：</p><div class="highlight"><pre><code class="language-text">(gdb) disas main
Dump of assembler code for function main:
   0x080483f4 &lt;+0&gt;: mov    $0x0,%eax
=&gt; 0x080483f9 &lt;+5&gt;: call   0x80483f0 &lt;eax_plus_1s&gt;
   0x080483fe &lt;+10&gt;:    ret    
   0x080483ff &lt;+11&gt;:    nop
End of assembler dump.</code></pre></div><p data-pid="w3vM24_p">接下来，做这样一个事情，看看现在eip的值是多少：</p><div class="highlight"><pre><code class="language-text">(gdb) info register eip
eip            0x80483f9    0x80483f9 &lt;main+5&gt;</code></pre></div><p data-pid="698Awj5N">正好指向这个函数调用指令。这里的call指令还没执行，现在的CPU处在上一条指令刚执行完毕的状态。前面说过，CPU中的eip总是指向下一条会执行的指令。在这里，珍惜机会，我们把想看的东西全都看个遍吧：</p><ul><li data-pid="5DWjZnq7">esp的值，这个很关键</li></ul><div class="highlight"><pre><code class="language-text">(gdb) info register esp
esp            0xffffd6ec   0xffffd6ec</code></pre></div><ul><li data-pid="BLFrFs9B">esp所指向的栈顶的东西</li></ul><div class="highlight"><pre><code class="language-text">(gdb) p/x *(unsigned int*)$esp
$1 = 0xf7e40ad3</code></pre></div><p data-pid="iSD-HUCj">该看的都看过了，让程序走吧，让它先执行完了call指令，我们再回头看看什么情况：</p><div class="highlight"><pre><code class="language-text">(gdb) stepi
0x080483f0 in eax_plus_1s ()</code></pre></div><p data-pid="ZYr6uXp1">根据提示，程序现在已经执行到函数里面去了。可以直接反汇编看看：</p><div class="highlight"><pre><code class="language-text">(gdb) disas
Dump of assembler code for function eax_plus_1s:
=&gt; 0x080483f0 &lt;+0&gt;: add    $0x1,%eax
   0x080483f3 &lt;+3&gt;: ret    
End of assembler dump.</code></pre></div><p data-pid="-TPguAB_">现在正等着执行那条加法指令呢。别急，现在函数调用已经发生了，再来看看上面我们看过的一些东西：</p><ul><li data-pid="1McPTQMz">esp的值，这个很关键</li></ul><div class="highlight"><pre><code class="language-text">(gdb) info register esp
esp            0xffffd6e8   0xffffd6e8</code></pre></div><p data-pid="GwyXG-so">看到了，上次查看esp的时候是0xffffd6ec，进入函数后的esp值是0xffffd6e8。少了个4。</p><p data-pid="5_9PZ2Gw">实际上这就是eip被保存到栈里去了，CPU的栈的伸长方向是朝着低地址一侧的，所以每次入栈，esp都会减少一个单位，也就是4。</p><ul><li data-pid="fb19u00I">esp所指向的栈顶的东西</li></ul><div class="highlight"><pre><code class="language-text">(gdb) p/x *(unsigned int*)$esp
$2 = 0x80483fe</code></pre></div><p data-pid="bxCMXe9z">这次，我们看看栈顶到底是个什么东西，打印出来0x80483fe这么一个玩意儿，这是蛤玩意儿？别急，回头看看main函数的反汇编：</p><div class="highlight"><pre><code class="language-text">(gdb) disas main
Dump of assembler code for function main:
   0x080483f4 &lt;+0&gt;: mov    $0x0,%eax
   0x080483f9 &lt;+5&gt;: call   0x80483f0 &lt;eax_plus_1s&gt;
   0x080483fe &lt;+10&gt;:    ret    
   0x080483ff &lt;+11&gt;:    nop
End of assembler dump.</code></pre></div><p data-pid="vu65kxKs">在里面找找0x80483fe呢？刚好在&lt;+10&gt;所在的那一行。这不就是函数调用指令处的后一条指令吗？</p><p data-pid="cfPU3p6o">对的，也就是说，一会函数返回的时候，就会到&lt;+10&gt;这个地方来。也就是在执行了eax_plus_1s函数里的ret之后。</p><p data-pid="gpuchgAb">是不是和前面描述的过程一模一样？</p><p data-pid="dsHHC4Tq">好了，到这里，探究汇编中的函数调用的过程和方法基本就有了，读者可以根据需要自行编写更加奇怪的代码，结合gdb，来探究更多你自己所好奇的东西。</p><p data-pid="kGkiM_RR">附加一个代码，自己玩耍试试（在自己的环境中玩耍哦）：</p><div class="highlight"><pre><code class="language-text">global main
hahaha:
    call hehehe
    ret
hehehe:
    call hahaha
    ret
main:
    call hahaha
    ret</code></pre></div><h1>总结</h1><p data-pid="rIw5Ibdy">这回，我们说到这样一些东西：</p><ul><li data-pid="hzQE4OK5">汇编中发生函数调用相关的指令call和ret</li><li data-pid="kBofnlWq">call指令会产生跳转动作，与jmp不同的是，call之后可以通过ret指令跳回来</li><li data-pid="Vm5EqJJS">call和ret的配合是依靠保存eip的值到栈里，返回时恢复eip实现的</li><li data-pid="z9gth1oh">esp记录着当前栈顶所在的位置，每次call和ret执行都会伴随着入栈和出栈，也就是esp会发生变化</li></ul><p data-pid="vmXPIz5y">函数调用最基本的”跳转“和”返回“就这么回事了，下回咱们继续分析”函数调用中的参数传递、返回值和状态“相关的问题。</p><p data-pid="nT_kwLZ2">文中若有疏漏或是不当之处，欢迎指正。</p></div>
