
[原文链接](https://zhuanlan.zhihu.com/p/23845369)
<div class="RichText ztext Post-RichText css-yvdm7v" options="[object Object]"><h2 data-first-child="">回顾</h2><p data-pid="5un3tMCk">前面说到过这样几个内容：</p><ul><li data-pid="IRDrPmHV">几条简单的汇编指令</li><li data-pid="GAtKJfqP">寄存器</li><li data-pid="qFkZz1x8">内存访问</li></ul><p data-pid="q2K7iLLm">对应到C语言的学习过程中，无非就是这样几个内容：</p><ul><li data-pid="G3YHF5K1">超级简单的运算</li><li data-pid="v8dfV_5c">变量</li></ul><p data-pid="EbsAdGsb">好了，到这里，我们继续接下来的话题，程序中的流程控制。</p><p data-pid="60sOFss5">文中涉及一些汇编代码，建议读者自行编程，通过动手实践来加深对程序的理解。</p><h2>顺序执行</h2><p data-pid="RXVCO-tE">首先，最简单也最好理解的程序流程，便是从前往后的顺序执行。这个非常简单，还是举出前面的例子：</p><p data-pid="-7AaawHR">现在有1000个计算题：</p><div class="highlight"><pre><code class="language-text">99+10=
32-20=
14+21=
47-9=
87+3=
86-8=
...</code></pre></div><p data-pid="WAOPgFWR">需要你一个个地从前往后计算，计算结果需要写在专门的答题卡上。当你每做完一个题，你需要继续做下一个题（这不是废话么）。</p><p data-pid="Wxahq6Zz">那么问题来了，我每次计算完一个题目，回头寻找下一个题目的时候，到底哪一个题是我接下来要计算的呢？</p><p data-pid="4MS9X5fe">你可能会说：瞄一眼答题卡就知道了呀。这就尴尬了，计算机其实是比较傻的，它可没有“瞄一眼”这样的功能。</p><p data-pid="dYiPdIY0">那这样的话，如果是自己做1000个题目，为了保证做题的时候每一个动作都不是多余的，有一个比较好的办法，就是强行在脑子里记住刚刚那个题目的位置。一会儿回头的时候，就立马知道该继续做哪个题了。</p><p data-pid="sjdFhKMB">好了，那对于计算机来说呢？前面说到，你做计算题的时候临时留在脑子里的东西，就对应CPU里寄存器的数据。寄存器就充当了临时记住一些东西的功能。那么，在这里，CPU也是用的这个套路，在内部有一个寄存器，专门用来记录程序执行到哪里了。</p><h3>CPU中的顺序执行过程</h3><p data-pid="hfg4I0k4">前面已经有了一个初步的结论，CPU里有一个寄存器专门存放“程序执行到哪里了”这样一个信息，而且这么做也是说得过去的，那就是：必须有一个东西记录当前程序执行到的位置，否则CPU执行完一条指令之后，就不知道接下来该干什么了。</p><p data-pid="QhKcnNH1">在x86体系结构的CPU里面，这个执行位置的信息，是保存在叫做eip的寄存器中的。不过很遗憾，这个寄存器比较特殊，无法通过mov指令进行修改，也就是说，这么写mov eip, 0x233是行不通的。</p><p data-pid="WdBRjjOQ">（不要问我为什么，我也不知道，这都是人做出来的东西，支不支持就看人家的心情。反正Intel的CPU做出来就是这个样子的，你可以认为，Intel在做CPU的时候压根就没支持这个功能，他们觉得做了也没什么卵用。虽然你可能觉得有这个功能不是更好么，但是实际上，有时候刻意对功能施加一些限制，可以减少程序员写代码误操作的机会，eip这个东西，很关键）</p><p data-pid="5Qj_TmnN">好了，介绍完eip的作用之后，再说一下细节的东西。在执行一条指令的时候，eip此时代表的是下一条指令的位置，eip里保存的就是下一条指令在内存中的地址。这样，CPU在执行完成一条指令之后，就直接根据eip的值，取出下一条指令，同时还要修改eip，往eip上加一个指令的长度，让它继续指向后一条指令。</p><p data-pid="XAtqpMEm">有了这样一个过程，CPU就能自动地去从前往后执行每一条指令了。而且，上述过程是在CPU中自动发生的，你写代码的时候根本不需要关心这个东西，只需要按照自己的思路从前往后写就是了。</p><p data-pid="ELlRgEtF">好了，这一段更多的是讲故事，明白CPU里面有个eip寄存器，它的功能很专一，就是用来表示程序现在执行到哪儿了。说得精确一点，eip一直都指向下一个要执行的指令，这一点是由CPU自己保证的。总之，只要CPU没坏，它就能给你保证eip的精确。</p><h2>事情没那么简单</h2><p data-pid="kd7U7seU">前面说了eip能记住程序执行的位置，那么CPU就能顺溜溜地一路走下去了。然而，世界并不是这么美好。因为：</p><div class="highlight"><pre><code class="language-text">if( a &lt; 1 ){
    // some code ...
} else if( a &gt;= 10 ) {
    // yi xie dai ma ...
}</code></pre></div><p data-pid="62Ngw4Zr">实际上有时候我们需要程序有一定的流程控制能力。就是有时候它不是老老实实按照顺序来执行的，中间可能会跳过一些代码，比如上述C代码中的a的值为100的时候。</p><p data-pid="D3TQKy_R">那么这时候怎么搞呢？照这样说，程序就得具备“修改eip”的能力了，可是前面说了，mov指令不顶用啊？</p><p data-pid="ethYCAAc">放心，那帮做CPU的人没那么傻，他们早就想好了怎么办了。他们在设计CPU的时候是这么考虑的：</p><ul><li data-pid="HnTDmM0k">更改eip和更改别的寄存器产生的效果不一样，所以应该特殊对待</li><li data-pid="cN8K1_C4">要更改有着特殊用途的eip，就用特殊的指令来完成，虽然都是在更改寄存器，但是代码写出来，表达给人的意思就不一样了</li></ul><p data-pid="_sCgKJ1Y">首先，我们需要更改eip来实现程序突然跳转的效果，进而灵活地对程序的流程进行控制。这里不得不祭出一套新的指令了：跳转指令。</p><p data-pid="Kfx5Fd3S">不说了，铺垫也都差不多了，还是直接上代码，直观体验一把，然后再扯别的。先来一份正常的代码：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov eax, 1
    mov ebx, 2
    add eax, ebx
    ret</code></pre></div><p data-pid="gejyf0rM">如果前面好好学习的话，对这个一定不陌生。还是大致解释一下吧：</p><div class="highlight"><pre><code class="language-text">eax = 1
ebx = 2
eax = eax + ebx</code></pre></div><p data-pid="0jQ-PwZW">所以，按照正常逻辑理解，最后eax为3，整个程序退出时会返回3。</p><p data-pid="feUahSzs">好的，到这里，我们来引入新的指令，通过前后对比的变化，来理解新的指令的作用：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov eax, 1
    mov ebx, 2 
    jmp gun_kai
    add eax, ebx
gun_kai:
    ret</code></pre></div><p data-pid="ZwHBnUal">这段代码相比前面的代码，多了两行：</p><div class="highlight"><pre><code class="language-text">...
    jmp gun_kai
...
gun_kai:
...    </code></pre></div><p data-pid="05mfcwcH">好了，这段代码其实没什么功能，存粹是为了演示，运行这个代码，得到的返回结果为1。</p><p data-pid="dJHKK2Q_">好了，最后的结果告诉我们，中间的那一条指令：</p><div class="highlight"><pre><code class="language-text">    add eax, ebx</code></pre></div><p data-pid="Q7X8ncOk">根本就没有执行，所以最后eax的值就是1，整个程序的返回值就是1。</p><p data-pid="mIeHChBG">好了，这里也没什么需要解释的，动手做，稍微对比分析一下就能够知道结论了。程序中出现了一条新的指令jmp，这是一个跳转指令，不解释。这里直接用一个等价的C语言来说明上述功能吧：</p><div class="highlight"><pre><code class="language-text">int main() {
    int a = 1;
    int b = 2;
    goto gun_kai;
    a = a + b;
gun_kai:
    return a;
}</code></pre></div><p data-pid="apJeyZJd">实际上，C语言中的goto语句，在编译后就是一条jmp指令。它的功能就是直接跳转到某个地方，你可以往前跳转也可以往后跳转，跳转的目标就是jmp后面的标签，这个标签在经过编译之后，会被处理成一个地址，实际上就是在往某个地址处跳转，而jmp在CPU内部发生的作用就是修改eip，让它突然变成另外一个值，然后CPU就乖乖地跳转过去执行别的地方的代码了。</p><h2>这玩意有啥用？</h2><p data-pid="qYtJuuUI">不对啊，这跳转指令能用来干啥？反正代码都直接被跳过去了，那我编程的时候干脆直接不写那几条指令不就得了么？使用跳转指令是不是有种脱了裤子放屁的感觉？</p><p data-pid="dOOcrsCP">并不是，继续。</p><h2>if在汇编里的样子</h2><p data-pid="BLR3VXAO">前面说到了跳转，但是仿佛没卵用的样子。接下来我们说这样一个C语言程序：</p><div class="highlight"><pre><code class="language-text">int main() {
    int a = 50;
    if( a &gt; 10 ) {
        a = a - 10;
    }
    return a;
}</code></pre></div><p data-pid="rQmUWWZW">这个程序，最后的返回值是40，这没什么好解释的。那对应的汇编程序呢？其实也非常简单，先直接给出代码再分析：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov eax, 50
    cmp eax, 10                         ; 对eax和10进行比较
    jle xiaoyu_dengyu_shi            ; 小于或等于的时候跳转
    sub eax, 10
xiaoyu_dengyu_shi:
    ret</code></pre></div><p data-pid="5NmjWIps">这段汇编代码很关键的地方就在于这两条陌生的指令：</p><div class="highlight"><pre><code class="language-text">    cmp eax, 10                         ; 对eax和10进行比较
    jle xiaoyu_dengyu_shi            ; 小于或等于的时候跳转</code></pre></div><p data-pid="LAegvhJL">先细细解释一下：</p><ul><li data-pid="HZIg4sxM">第一条，cmp指令，专门用来对两个数进行比较</li><li data-pid="gFfP48x-">第二条，条件跳转指令，当前面的比较结果为“小于或等于”的时候就跳转，否则不跳转</li></ul><p data-pid="uE4Zp-P7">到这里，至少上面这个程序，每一条指令都是很清楚的。只是你关心的是下面的问题：</p><ul><li data-pid="S0O8EUZP">我会写a &gt; 10的情况了，那么a &lt; 10怎么办呢？a == 10怎么办呢？a &lt;= 10怎么办呢？a &gt;= 10怎么办呢？</li></ul><p data-pid="xb_ymwJ6">凉拌炒鸡蛋。</p><p data-pid="JZV1tWiq">别急，先说套路。上面的C语言代码是这样的：</p><div class="highlight"><pre><code class="language-text">if ( a &gt; 10 ) {
    a = a - 10;
}</code></pre></div><p data-pid="5kc9VnpS">这是表示：“比较a和10，a大于10的时候，进入if块中执行减法”</p><p data-pid="KC0HEEOC">而汇编代码：</p><div class="highlight"><pre><code class="language-text">    cmp eax, 10
    jle xiaoyu_dengyu_shi
    sub eax, 10
xiaoyu_dengyu_shi:</code></pre></div><p data-pid="vZV45V0U">表示的是：“比较eax和10，eax小于等于10的时候，跳过中间的减法”</p><p data-pid="N-h_A20V">注意这里最关键的两个表述：</p><ul><li data-pid="4JncXqe-">C语言中：a大于10的时候，进入if块中执行减法</li><li data-pid="V1_JxOqh">汇编语言中：eax小于等于10的时候，跳过中间的减法</li></ul><p data-pid="V4mbw2VL">C语言和汇编语言中的条件判断，其组织的思路是刚好相反的。这就在编程的时候带来一些思考上的困难，不过这都还是小事情，实在困难你可以先画出流程图，然后对流程图进行改造，就可以了。</p><p data-pid="aty6r2XN">有了上面if的套路，接下来趁热打铁，再做一个练习：</p><div class="highlight"><pre><code class="language-text">int main() {
    int x = 1;
    if ( x &gt; 100 ) {
        x = x - 20;
    }
    x = x + 1;
    return x;
}</code></pre></div><p data-pid="cJ51Diaf">好了，这里按照前面的思路，在汇编语言里面，关键就是下面几点：</p><ul><li data-pid="34cZAjhB">对x对应的东西与100进行比较</li><li data-pid="ONd22boD">何时跳过if块中的减法</li><li data-pid="bxYBaaSg">x = x + 1是无论如何都会执行的</li></ul><p data-pid="1ZbKibDa">按照前面的代码，稍作类比，很容易地就能写出下面的代码来：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov eax, 1   
    cmp eax, 100
    jle xiao_deng_yu_100
    sub eax, 20
xiao_deng_yu_100:
    add eax, 1
    ret</code></pre></div><p data-pid="RKxAxDxI">把程序结合着前面的C代码进行对比，参考前面说的if在汇编里组织的套路，这个程序就很容易理解了。你还可以尝试把</p><div class="highlight"><pre><code class="language-text">    mov eax, 1</code></pre></div><p data-pid="HJ2f_uHY">更改为：</p><div class="highlight"><pre><code class="language-text">    mov eax, 110</code></pre></div><p data-pid="o8AOTTAF">试试程序的执行逻辑是不是发生了变化？</p><h2>再来套路</h2><p data-pid="wx7nQYDN">前面说到了if在汇编中的组织方式，接下来，问题就更加复杂了：</p><ul><li data-pid="nPPeeld0">我会写a &gt; 10的情况了，那么a &lt; 10怎么办呢？a == 10怎么办呢？a &lt;= 10怎么办呢？a &gt;= 10怎么办呢？</li></ul><p data-pid="lIbM8lHP">凉拌炒鸡蛋。</p><p data-pid="YyuJz_UE">前面实际上只提到了两个流程控制相关的指令：</p><ul><li data-pid="0GyCGaUT">jmp</li><li data-pid="9NldPivN">jle</li></ul><p data-pid="n26QX-Xn">以及一个比较指令：</p><ul><li data-pid="PXNWpy9u">cmp</li></ul><p data-pid="2HZgmCRF">专门用来对两个操作数进行比较。</p><p data-pid="oQmIPiLO">先从这里入手，总结套路。首先，这两条跳转指令是人想出来的，所以，你很容易想到，仅仅是这两条跳转指令好像还不够。其实，人家做CPU的人早也就想到了。所以，还有这样一些跳转指令：</p><div class="highlight"><pre><code class="language-text">ja 大于时跳转
jae 大于等于
jb 小于
jbe 小于等于
je 相等
jna 不大于
jnae 不大于或者等于
jnb 不小于
jnbe 不小于或等于
jne 不等于
jg 大于(有符号)
jge 大于等于(有符号)
jl 小于(有符号)
jle 小于等于(有符号)
jng 不大于(有符号)
jnge 不大于等于(有符号)
jnl 不小于
jnle 不小于等于
jns 无符号
jnz 非零
js 如果带符号
jz 如果为零</code></pre></div><p data-pid="eLMAEMWc">好了，这就是一些条件跳转指令，将它们配合着前面的cmp指令一起使用，就能够达到if语句的效果。</p><p data-pid="AOqWs0zr">What？这该不会都得记住吧？其实不用，这里面是有套路的：</p><ul><li data-pid="mrs-fPgW">首先，跳转指令的前面都是字母j</li><li data-pid="o7_NeCll">关键是j后面的的字母</li></ul><p data-pid="kSDKTnKQ">比如j后面是ne，对应的是jne跳转指令，n和e分别对应not和equal，也就是“不相等”，也就是说在比较指令的结果为“不想等”的时候，就会跳转。</p><ul><li data-pid="-qZFCOw7">a: above</li><li data-pid="KhNr7XNN">e: equal</li><li data-pid="9vdAo-Va">b: below</li><li data-pid="6_6w0dZ2">n: not</li><li data-pid="TpWp-fw2">g: greater</li><li data-pid="6Hs5g5kv">l: lower</li><li data-pid="Gd6tZ9EL">s: signed</li><li data-pid="VKS-IcTK">z: zero</li></ul><p data-pid="AFB9hHfe">好了，这里列出来了j后面的字母所对应的含义。根据这些字母的组合，和上述大概的规则，你就能清楚怎么写出这些跳转指令了。当然，这里有“有符号”和“无符号”之分，后面有机会再扯，读者也可以自行了解。</p><p data-pid="6PEAxMaG">那么，接下来，就可以写出这样的程序所对应的汇编代码了：</p><div class="highlight"><pre><code class="language-text">
int main() {
    int x = 50;
    if ( x <= 100 ) {
        x = x - 20;
    }
    if( x > 10 ) {
        x = x + 10;
    }
    x=x+3;
    return x;
}
}</code></pre></div><p data-pid="95Hy0sDb">这个程序没什么卵用，存粹是为了演示。按照前面的套路，其实写出汇编代码也就不难了：</p><div class="highlight"><pre><code class="language-text">global main

main:
    mov eax, 50
    
    cmp eax, 100
    jle lower_or_equal_100
    
lower_or_equal_100:
    sub eax, 20
    cmp eax, 10
    jg greater_10
  

greater_10:
    add eax, 10
    add eax,3
    ret

add eax,3
ret </code></pre></div><p data-pid="pfyA_pI0">至于更多可能的写法，那就可以慢慢玩了。</p><h2>if都有了，那else if和else怎么办呢？</h2><p data-pid="JGCYQAVn">这里就不再赘述了，理一下思路：</p><ul><li data-pid="9i4DmmHy">首先根据你的需要，画出整个程序的流程图</li><li data-pid="DY6DYHKo">按照流程图中的跳转关系，通过汇编表达出来</li></ul><p data-pid="mRBSxiom">也就是说，在汇编里面，实际上没有所谓的if或else的说法，只是前面为方便说明，使用了C语言作类比，实际上汇编还可以写得比C语言的判断更加灵活。</p><p data-pid="9gIbvYw2">事实上，C语言里面的几种常见的if组织结构，都有对应的汇编语言里的套路。说白了，都是套路。</p><p data-pid="Tyj5RviE">那你怎么才能知道这些套路呢？很简单，用C语言写一个简单的程序，编译后按之前文章所说的内容，使用gdb去反汇编然后就能知道这里面的具体做法了。</p><p data-pid="EE8aiqvH">下面来尝试下一下：</p><div class="highlight"><pre><code class="language-text">int main() {
    register int grade = 80;
    register int level;
    if ( grade &gt;= 85 ){
        level = 1;
    } else if ( grade &gt;= 70 ) {
        level = 2;
    } else if ( grade &gt;= 60 ) {
        level = 3;
    } else {
        level = 4;
    }
    return level;
}</code></pre></div><p data-pid="z2rDRomQ">（程序中有一个register关键字，是用来限定这个变量在编译后只能用寄存器来进行表示，方便我们进行分析。读者可以根据需要，去掉register关键字后比较一下反汇编代码有何不同。）</p><p data-pid="YLyBAY6j">这是一个很经典的多分支程序结构。先编译运行，程序返回值为2。</p><div class="highlight"><pre><code class="language-text">$ gcc -m32 grade.c -o grade 
$ ./grade ; echo $?
2</code></pre></div><p data-pid="mQbncsRt">好了，接下来，用gdb进行反汇编：</p><div class="highlight"><pre><code class="language-text">$ gdb ./grade
(gdb) set disassembly-flavor intel
(gdb) disas main</code></pre></div><p data-pid="FOYxlO0N">得到的反汇编代码如下：</p><div class="highlight"><pre><code class="language-text">Dump of assembler code for function main:
   0x080483ed &lt; +0&gt;:    push   ebp
   0x080483ee &lt; +1&gt;:    mov    ebp,esp
   0x080483f0 &lt; +3&gt;:    push   ebx
   0x080483f1 &lt; +4&gt;:    mov    ebx,0x50
   0x080483f6 &lt; +9&gt;:    cmp    ebx,0x54
   0x080483f9 &lt;+12&gt;:    jle    0x8048402 &lt;main+21&gt;
   0x080483fb &lt;+14&gt;:    mov    ebx,0x1
   0x08048400 &lt;+19&gt;:    jmp    0x804841f &lt;main+50&gt;
   0x08048402 &lt;+21&gt;:    cmp    ebx,0x45
   0x08048405 &lt;+24&gt;:    jle    0x804840e &lt;main+33&gt;
   0x08048407 &lt;+26&gt;:    mov    ebx,0x2
   0x0804840c &lt;+31&gt;:    jmp    0x804841f &lt;main+50&gt;
   0x0804840e &lt;+33&gt;:    cmp    ebx,0x3b
   0x08048411 &lt;+36&gt;:    jle    0x804841a &lt;main+45&gt;
   0x08048413 &lt;+38&gt;:    mov    ebx,0x3
   0x08048418 &lt;+43&gt;:    jmp    0x804841f &lt;main+50&gt;
   0x0804841a &lt;+45&gt;:    mov    ebx,0x4
   0x0804841f &lt;+50&gt;:    mov    eax,ebx
   0x08048421 &lt;+52&gt;:    pop    ebx
   0x08048422 &lt;+53&gt;:    pop    ebp
   0x08048423 &lt;+54&gt;:    ret  </code></pre></div><p data-pid="q1qaPOFC">篇幅有限，这里就留给读者练习分析了。其中有几个需要注意的地方：</p><ul><li data-pid="Mpvzhgc-">部分无关指令可以直接忽略掉，如：push、pop等</li><li data-pid="GmlTyiPu">跳转指令后的&lt;main+21&gt;，就对应的是反汇编指令前是&lt;+21&gt;的指令</li></ul><p data-pid="nu5j7eTS">根据上述反汇编代码，分析出程序的流程图，与C语言程序的代码进行比较。仔细分析，你应该就发现jmp指令有什么用了吧。</p><h2>状态寄存器</h2><p data-pid="XnKEPe9r">到这里，有一个问题出现了，在汇编语言里面实现“先比较，后跳转”的功能时，后面的跳转指令是怎么利用前面的比较结果的呢？</p><p data-pid="A-j84yyZ">这就涉及到另一个寄存器了。在此之前，先想一下，如果自己在脑子里思考同样的逻辑，是怎么样的？</p><ul><li data-pid="JE3CCkIh">先比较两个数</li><li data-pid="B0IJzTha">记住比较结果</li><li data-pid="wiKhwqcI">根据比较结果作出决定</li></ul><p data-pid="L_n7vvAD">好了，这里又来了一个“记住”的动作了。CPU里面也有一个专用的寄存器，用来专门“记住”这个cmp指令的比较结果的，而且，不仅是cmp指令，它还会自动记住其它一些指令的结果。这个寄存器就是：</p><div class="highlight"><pre><code class="language-text">eflags</code></pre></div><p data-pid="_adE0RlU">名为“标志寄存器”，它的作用就是记住一些特殊的CPU状态，比如前一次运算的结果是正还是负、计算过程有没有发生进位、计算结果是不是零等信息，而后续的跳转指令，就是根据eflags寄存器中的状态，来决定是否要进行跳转的。</p><p data-pid="rd8xJzni">cmp指令实际上是在对两个操作数进行减法，减法后的一些状态最终就会反映到eflags寄存器中。</p><h2>总结</h2><p data-pid="Q3BMIqVm">这回着重说到了汇编语言中与流程控制相关的内容。其中主要包括：</p><ul><li data-pid="klf95igy">eip寄存器指示着CPU接下来要执行哪里的代码</li><li data-pid="Rl6ibwWb">一系列跳转指令，跳转指令根本上就是修改了eip</li><li data-pid="7BgR9nHA">比较指令，比较指令实际上是在做减法，然后把结果的一些状态放到eflags寄存器中</li><li data-pid="kXH7aeUP">eflags寄存器的作用</li><li data-pid="gk1nzgX_">条件跳转指令也就是根据eflags中的信息来决定是否跳转</li></ul><p data-pid="1wkWuS4h">当然，这里讲述的仅仅是一部分相关的指令，带领读者对这部分内容有一个直观的认识。实际上汇编语言中与流程相关的指令不止这些，读者可自行查阅相关的资料：</p><ul><li data-pid="0LFbeUQ0">x86标志寄存器</li><li data-pid="P0YcWp3B">x86影响标志寄存器的指令</li><li data-pid="9B8yExBz">x86跳转指令</li></ul><p data-pid="SNGH8unJ">本文内容相比之前要更多一些，若想要完全理解，也需要仔细阅读，多思考、多尝试，多验证，也可以参考更多其它方面的资料。</p><p data-pid="mb6seecR">文中若有疏漏之处，欢迎指正。</p></div>
