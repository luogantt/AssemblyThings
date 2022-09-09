
<div class="RichText ztext Post-RichText css-yvdm7v" options="[object Object]"><h1 data-first-child="">汇编语言入门一：环境准备</h1><p data-pid="6WyLmaqe">现阶段，找个方便好使的编程环境还是比较蛋疼的，对于部分想过瘾或者想从学习实践中学习的小伙伴来说，略显蛋疼。不过，仔细琢磨，还是能够自己折腾出一个好用的环境来的。开搞。</p><h2>环境</h2><ul><li data-pid="8jj8MLww">Ubuntu</li><li data-pid="DIeEU5cC">gcc/nasm</li></ul><p data-pid="POuvOuI4">也就是说，你先安装一个能正常使用的Ubuntu再说吧，然后顺便熟悉一些相关的概念和操作。</p><p data-pid="LLQtCEpL">后面若没有特殊说明，那我们讨论的问题都是在这个软件环境下。</p><h3>环境检查</h3><p data-pid="8IfJsyxS">先打开终端，安装所需软件（注意$开头的才是命令，并且$并不属于命令的一部分）：</p><div class="highlight"><pre><code class="language-text">$ sudo apt-get install gcc nasm vim gcc-multilib -y</code></pre></div><p data-pid="TIfSUreH">在终端中分别执行which nasm和which gcc，得到如下结果，则表示环境已经安装完毕。</p><div class="highlight"><pre><code class="language-text">$ which nasm
/usr/bin/nasm
$ which gcc
/usr/bin/gcc</code></pre></div><h2>开始第一个程序</h2><p data-pid="889BWkdo">在汇编语言环境下，我们先别急着搞什么Hello World，在这里要打印出Hello World还不是一个简单的事情，这也算是初入汇编比较让人不解的地方，成天都在扯什么寄存器寻址啥的，说好的变量分支循环函数呢？</p><p data-pid="_cvxHuhM">别说话，先按照我的套路把环境配好，程序跑起来了再说。注意，不是Hello World。先亮出第一个程序的C语言等价代码：</p><div class="highlight"><pre><code class="language-text">int main() {
    return 0;
}</code></pre></div><p data-pid="wdPAYQyp">不好意思，大括号没换行。你以为接下来我要gcc -S吗？Too naive。我这可是正宗手工艺，非机械化生产。</p><p data-pid="x3SkDtYu">说正事，先一股脑啥都不知道地把代码敲完，跑起来再说：</p><p data-pid="s4kqfudP">首先准备个文件，暂且叫做first.asm吧，然后把下面的代码搞进去：</p><div class="highlight"><pre><code class="language-text">global main
main:
    mov eax, 0
    ret</code></pre></div><p data-pid="w7UAMUXz">好了程序写完了，你能感受到这里的0就是上面C代码里的0，说明你有学习汇编的天赋。</p><p data-pid="VZbEH5lW">OK接下来就要编译运行了。来一堆命令先：</p><div class="highlight"><pre><code class="language-text">$ nasm -f elf first.asm -o first.o
$ gcc -m32 first.o -o first</code></pre></div><p data-pid="3SBInaJv">这下，程序就编译好了，像这样：</p><div class="highlight"><pre><code class="language-text">$ ls
first  first.asm  first.o</code></pre></div><p data-pid="HvP5k7cW">好了我们运行一下：</p><div class="highlight"><pre><code class="language-text">$ ./first ; echo $?</code></pre></div><p data-pid="RQEsm4RX">别问我为何上面的命令后面多了一串奇怪的代码，你自己把它删掉之后再看就能猜出来是干啥的了。如果还有疑惑，可以再次做实验确认，比如把代码里的0改成1。变成这样：</p><div class="highlight"><pre><code class="language-text">global main

main:
    mov eax, 1
    ret</code></pre></div><p data-pid="8A_L8Dvw">再按照同样的套路来编译运行：</p><div class="highlight"><pre><code class="language-text">$ nasm -f elf first.asm -o first.o
$ gcc -m32 first.o -o first
$ ./first ; echo $?
1</code></pre></div><p data-pid="DOc1nGut">OK，咱们的环境准备工作大功告成，后面再细说该怎么搞事情（心情好的话还有ARM版的哦，准备好ARM环境或者买个树莓派吧）。</p></div>
