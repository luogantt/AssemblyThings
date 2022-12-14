

##### <font color=darkblue> 代码运行

```
sh run.sh
```
```
assembly  sum is
55
while sum is
55
goto sum is
55
```


###
[原文链接](https://zhuanlan.zhihu.com/p/23902265)
<div class="RichText ztext Post-RichText css-yvdm7v" options="[object Object]"><h2 data-first-child="">回顾</h2><p data-pid="_7qOWOrI">前面说到在汇编语言中实现类似C语言if-else if-else这样的结构，</p><p data-pid="lpjWkFAD">实际上，在汇编里面，我们并不关心if了，取而代之的是两种基本的指令：</p><ul><li data-pid="KQlN_LJq">比较</li><li data-pid="nnyzfkrz">跳转</li></ul><p data-pid="bNjI6ke-">这两种指令即可组成最基本的分支程序结构，虽然跳转指令非常多，但是我们已经有套路了，怎么跳转都不怕了。当然，在编程环境中仅有分支还不够的，我们知道C语言中除了分支结构之外，还有循环这个最基本也是最常用的形式。正好，这也是本节话题的主角。</p><p data-pid="UQGsU7zq">文中涉及一些汇编代码，建议读者自行编程，通过动手实践来加深对程序的理解。</p><h2>拆散循环结构</h2><p data-pid="Yj6QXdCc">上回说到C语言中if这样的结构，在汇编里对应的是怎么回事，实质上，这就是分支结构的程序在汇编里的表现形式。</p><p data-pid="vIUlvGiy">实际上，循环结构相比分支结构，本质上，没有多少变化，仅仅是比较合跳转指令的组合的方式与顺序有所不同，所以形成了循环。</p><p data-pid="YWTs1wlM">当然，这个说法可能稍微拗口了一点。说得简单一点，循环的一个关键特点就是：</p><ul><li data-pid="2euSS67G">程序在往回跳转</li></ul><p data-pid="wVgf1AGR">细细想，好像有道理哦，如果程序每到一个位置就往前跳转，那就是死循环，如果是在这个位置根据条件决定是否要向前跳转，那就是有条件的循环了。</p><p data-pid="fZC5SdS9">口说无凭，还是先来分析一下一个C语言的while循环：</p><p data-pid="2Y3q7TB8">(Talk is chip, show your code!)</p><div class="highlight"><pre><code class="language-text">int sum = 0;
int i = 1;
while( i &lt;= 10 ) {
    sum = sum + i;
    i = i + 1;
}</code></pre></div><p data-pid="4N_rRv_b">想必这段程序多数人都非常熟悉了，当年自己第一次学习循环的时候就碰到这个题目，脑子短路了，心里总想着这不就是一个等差数列公式么，题目却强行出现在循环一章的后面，最后结果让人大跌眼睛，这是要我老老实实像SHAB一样去加啊。</p><p data-pid="0Tg1AHY-">跑题了，先大致总结一下这个程序的关键部分到底在干什么：</p><ul><li data-pid="uXcilbjy">1. 比较i和10的大小</li><li data-pid="2T90UVSf">2. 如果i &lt;= 10则执行代码块，并回到(1)</li><li data-pid="FXEyetky">3. 如果不满足 i &lt;= 10，则跳过代码块</li></ul><p data-pid="i087ECIn">好了，按照这个逻辑，在C语言中不使用循环怎么实现？其实也非常简单：</p><div class="highlight"><pre><code class="language-text">int sum = 10;
int i = 1;
_start:
if( i &lt;= 10 ) {
    sum = sum + i;
    i = i + 1;
    goto _start;
}</code></pre></div><p data-pid="Ey1TbVJD">这还不够，我们还得做一次变形，为什么呢？回想一下前面说的分之程序在汇编里的情况：</p><div class="highlight"><pre><code class="language-text">if ( a &gt; 10 ) {
    // some code
}</code></pre></div><p data-pid="nMSHx2Ik">上述C代码，暂且成为“正宗C代码”，等价的汇编大致结构如下：</p><div class="highlight"><pre><code class="language-text">cmp eax, 10
jle out_of_block
; some code
out_of_block:</code></pre></div><p data-pid="PXHaXDiP">再等价变换回C语言，这里把这种风格叫做“山寨C代码”，实际上就是这样的：</p><div class="highlight"><pre><code class="language-text">if( a &lt;= 10 ) goto out_of_block;
// some code
out_of_block:</code></pre></div><p data-pid="RkMiJ3as">经过比较，我们可以发现“山寨C代码”和“正宗C代码”之间的一些区别：</p><ul><li data-pid="g1wwUaFd">山寨版中，if块里只需要放一条跳转语句即可</li><li data-pid="LQJ3_KO6">山寨版中，if里的条件是反过来的</li><li data-pid="nrYn9BsH">山寨版中，跳转语句的功能是跳过“正宗C代码”的if块</li></ul><p data-pid="iGm9cB5S">相当于是：不满足条件就跳过if中的语句块。</p><p data-pid="8VOOvXFF">那循环呢？咱们把循环的C等价代码做一次变换，也就是把只含有goto和if的“正宗C代码”变换为“山寨C代码”的形式：</p><div class="highlight"><pre><code class="language-text">int sum = 10;
int i = 1;
_start:
if( i &gt; 10 ) {
    goto _end_of_block;
}
sum = sum + i;
i = i + 1;
goto _start;
_end_of_block:</code></pre></div><p data-pid="Q8lwzHkQ">大致看一下流程，再对比源代码：</p><div class="highlight"><pre><code class="language-text">int sum = 0;
int i = 1;
while( i &lt;= 10 ) {
    sum = sum + i;
    i = i + 1;
}</code></pre></div><p data-pid="HfRA5sT_">自己在脑子里面模拟一遍，是不是就能发现什么了？这俩货分明就是一个东西，执行的顺序和过程完全就是一样的。</p><p data-pid="2m0sIIzw">到这里，我们的循环结构，全都被拆散成了最基本的结构，这种结构有一个关键的特点：</p><ul><li data-pid="rJeXlp1o">所有if块中都仅有一条goto语句，别的啥都没了</li></ul><p data-pid="Dz_n1h_n">到这里，本段就到位了。</p><h2>用汇编写出循环</h2><p data-pid="cUKCvRHe">前面已经介绍了“如何把一个循环拆解成只有if和goto的结构”，有了这个结构之后，其实要写出汇编就非常容易了。</p><p data-pid="G8gF38Ms">继续看山寨版的循环：</p><div class="highlight"><pre><code class="language-text">int sum = 10;
int i = 1;
_start:
if( i &gt; 10 ) {
    goto _end_of_block;
}
sum = sum + i;
i = i + 1;
goto _start;
_end_of_block:</code></pre></div><p data-pid="QhmKTf44">其实，稍微仔细一点就能发现，把这玩意儿写成汇编，就是逐行翻译就完事儿了。动手：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov eax, 0
    mov ebx, 1
_start:
    cmp ebx, 10
    jg _end_of_block
    add eax, ebx
    add ebx, 1
    jmp _start
_end_of_block:
    ret</code></pre></div><p data-pid="QCcXzkOz">这里面其实有一个套路：</p><ul><li data-pid="oWv44gk8">单条goto语句可以直接用jmp语句替代</li><li data-pid="vdocaOJ9">if和goto组合的语句块可以用cmp和j*指令的组合替代</li></ul><p data-pid="sbn-Nh9d">最后，其它语句该干啥干啥。</p><p data-pid="f-29S02v">这？竟然？就？用汇编？写出？循环？来了？</p><p data-pid="h5mueEX-">嗯，是的。不需要任何一个新的指令，全都是前面提及过的基本指令，只是套路不一样了而已。</p><p data-pid="YYxJYFN2">其实这就是一个套路，稍微总结一下就能发现，一个将while循环变换为汇编的过程如下：</p><ul><li data-pid="1eKGMwgr">将while循环拆解成只有if和goto的形式</li><li data-pid="iytyRvcm">将if形式的语句拆解成if块中仅有一行goto语句的形式</li><li data-pid="KPRiPyYB">从前往后逐行翻译成汇编语言</li></ul><h2>其它循环呢？</h2><p data-pid="xf25RSwT">那while循环能够搞定了，其它类型的呢？do-while循环、for循环呢？</p><p data-pid="DExAZmYv">其实，在C语言中，这三种循环之间都是可以相互变换的，也就是说for循环可以变形成为while循环，while循环也可以变成for循环。举个例子：</p><div class="highlight"><pre><code class="language-text">int i = 1;
int sum = 0;
for(i = 0; i &lt;= 10; i ++) {
    sum = sum + i;
}
int sum = 0;
int i = 1;
while( i &lt;= 10 ) {
    sum = sum + i;
    i = i + 1;
}</code></pre></div><p data-pid="vTfVebu1">上述两个片段的代码，其实就是等价的，仅仅是形式不同。只是有的循环思路用for循环写出来好看一些，有的思路用while循环写出来好看一些，别的没什么本质区别，经过编译器一倒腾之后，就更没有任何区别了。</p><h2>总结</h2><p data-pid="mihLG2nb">在汇编中，分支和循环结构，都是通过两类基本的指令实现的：</p><ul><li data-pid="GKV7JrZX">比较</li><li data-pid="xFpcfYZh">跳转</li></ul><p data-pid="oSt4-BxP">只是，分支结构的程序中，所有的跳转目标都是往后，程序一去不复返。而循环结构中，程序会根据条件往前跳转，跳回去执行已经执行过的代码，在绕圈圈，就成循环了。到汇编层面，本质上，没啥区别。</p><p data-pid="GBhEFmA4">好了，汇编语言中的流程控制，基本就算完事儿了，实际上，在汇编语言中，抓住根本的东西就行了，剩下的就是靠脑子想象了。</p><p data-pid="40X5ggP_">文中若有疏漏之处，欢迎指正。</p></div>
