

|  | text	   |data	  |  bss	  |  dec	    |hex	|filename|sum
  |--|--|--|--|--|--|--|--|
||   1366	|   4616	|   4032	  |10014	 |  271e|	main|21184
||   1366	|   8616	|      8	|   9990	|   2706	|main1|25184
|变化main1-main|   0	|   4000	|      -4024	|   -24	|   -24	||4000

bss 段不占磁盘空间


![在这里插入图片描述](https://img-blog.csdnimg.cn/b970375dbcfe4f1581ec8b143ba1d35f.jpeg#pic_center)



[原文链接](https://blog.csdn.net/JMW1407/article/details/108185440?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~Rate-1-108185440-blog-69307890.pc_relevant_default&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~Rate-1-108185440-blog-69307890.pc_relevant_default&utm_relevant_index=1)

<div class="toc">
 <h3><a name="t0"></a>操作系统的程序<a href="https://so.csdn.net/so/search?q=%E5%86%85%E5%AD%98&amp;spm=1001.2101.3001.7020" target="_blank" class="hl hl-1" data-report-click="{&quot;spm&quot;:&quot;1001.2101.3001.7020&quot;,&quot;dest&quot;:&quot;https://so.csdn.net/so/search?q=%E5%86%85%E5%AD%98&amp;spm=1001.2101.3001.7020&quot;,&quot;extra&quot;:&quot;{\&quot;searchword\&quot;:\&quot;内存\&quot;}&quot;}" data-tit="内存" data-pretit="内存">内存</a>结构</h3>
 <ul><li><a href="#1_1" target="_self">1、操作系统的程序内存结构</a></li><li><ul><li><a href="#11_2" target="_self">1.1、程序编译运行过程</a></li><li><a href="#12_6" target="_self">1.2、程序的内存分布</a></li><li><a href="#13databss_27" target="_self">1.3、.data和.bss分开的理由</a></li><li><a href="#14_154" target="_self">1.4、程序的指令和数据分开原因：</a></li></ul>
  </li><li><a href="#_169" target="_self">参考</a></li></ul>
</div>
<p></p> 
<h1><a name="t1"></a><a id="1_1"></a>1、操作系统的程序内存结构</h1> 
<h2><a name="t2"></a><a id="11_2"></a>1.1、程序编译运行过程</h2> 
<p>源代码（source coprede）→<a href="https://so.csdn.net/so/search?q=%E9%A2%84%E5%A4%84%E7%90%86&amp;spm=1001.2101.3001.7020" target="_blank" class="hl hl-1" data-report-click="{&quot;spm&quot;:&quot;1001.2101.3001.7020&quot;,&quot;dest&quot;:&quot;https://so.csdn.net/so/search?q=%E9%A2%84%E5%A4%84%E7%90%86&amp;spm=1001.2101.3001.7020&quot;,&quot;extra&quot;:&quot;{\&quot;searchword\&quot;:\&quot;预处理\&quot;}&quot;}" data-tit="预处理" data-pretit="预处理">预处理</a>器（processor）→编译器（compiler）→汇编程序（assembler）→目标程序（object code）→链接器（Linker）→可执行程序（executables）<br> <img src="https://img-blog.csdnimg.cn/20200729212644903.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0pNVzE0MDc=,size_16,color_FFFFFF,t_70" alt="在这里插入图片描述"><br> 分配程序执行所需的栈空间、代码段、静态存储区、映射堆空间地址等，操作系统会创建一个进程结构体来管理进程，然后将进程放入就绪队列，等待CPU调度运行。<code>参考1.2</code></p> 
<h2><a name="t3"></a><a id="12_6"></a>1.2、程序的内存分布</h2> 
<p><img src="https://img-blog.csdnimg.cn/20200729205246150.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0pNVzE0MDc=,size_16,color_FFFFFF,t_70" alt="在这里插入图片描述"></p> 
<ul><li>1、<code>代码段(.text)</code>，也称<code>文本段(TextSegment)</code>，存放着<code>程序的机器码</code>和<code>只读数据</code>，可执行指令就是从这里取得的。如果可能，系统会安排好相同程序的多个运行实体共享这些实例代码。这个段在内存中一般被标记为只读，任何对该区的写操作都会导致段错误<code>（Segmentation Fault）</code>。</li><li><code>2、数据段，</code>包括已<code>初始化的数据段(.data)</code>和<code>未初始化的数据段（.bss）</code>， 
  <ul><li>data：用来存放保存全局的和静态的已初始化变量，</li><li>bss：后者用来保存全局的和静态的未初始化变量。数据段在编译时分配。</li></ul> </li><li><code>3、堆栈段分为堆和栈：</code> 
  <ul><li><code>堆（Heap）</code>：用来存储程序运行时分配的变量。 
    <ul><li>堆的大小并不固定，可动态扩张或缩减。其分配由<code>malloc()、new()</code>等这类实时内存分配函数来实现。</li><li>当进程调用<code>malloc</code>等函数分配内存时，新分配的内存就被动态添加到堆上（堆被扩张）；</li><li>当利用<code>free</code>等函数释放内存时，被释放的内存从堆中被剔除（堆被缩减）</li><li>堆的内存释放由应用程序去控制，通常一个new()就要对应一个delete()，如果程序员没有释放掉，那么在程序结束后操作系统会自动回收。</li></ul> </li><li><code>栈（Stack）</code>是一种用来存储函数调用时的<code>临时信息</code>的结构，如<code>函数调用所传递的参数</code>、<code>函数的返回地址</code>、<code>函数的局部变量</code>等。在程序运行时由编译器在需要的时候分配，在不需要的时候自动清除。 
    <ul><li>栈的特性: 最后一个放入栈中的物体总是被最先拿出来，这个特性通常称为先进后出(FILO)队列。</li><li>栈的基本操作： PUSH操作：向栈中添加数据，称为压栈，数据将放置在栈顶；</li><li>POP操作：POP操作相反，在栈顶部移去一个元素，并将栈的大小减一，称为弹栈。</li></ul> </li></ul> </li></ul> 
<p><strong>堆和栈的区别：</strong><br> <img src="https://img-blog.csdnimg.cn/20200729211334930.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0pNVzE0MDc=,size_16,color_FFFFFF,t_70" alt="在这里插入图片描述"></p> 
<h2><a name="t4"></a><a id="13databss_27"></a>1.3、.data和.bss分开的理由</h2> 
<p><mark>1、首先介绍各段的关系：</mark></p> 
<ul><li><code>.text</code> 部分是编译后程序的主体，也就是程序的机器指令。</li><li><code>.data 和 .bss</code> 保存了程序的全局变量，.data保存有初始化的全局变量，.bss保存只有声明没有初始化的全局变量。</li><li><code>text和data段</code>都在可执行文件中（在嵌入式系统里一般是固化在镜像文件中），由系 统从可执行文件中加载；</li><li><code>bss段</code>不在可执行文件中，由系统初始化。</li></ul> 
<p><mark>2、.bss的简单说明</mark></p> 
<p>BSS 是“Block Started by Symbol”的缩写，意为“以符号开始的块”。<code>BSS是Unix链接器产生的未初始化数据段</code>。<br> <code>BSS段的变量只有名称和大小却没有值</code>。此名后来被许多文件格式使用，包括PE。“以符号开始的块” 指的是<a href="https://so.csdn.net/so/search?q=%E7%BC%96%E8%AF%91%E5%99%A8&amp;spm=1001.2101.3001.7020" target="_blank" class="hl hl-1" data-report-click="{&quot;spm&quot;:&quot;1001.2101.3001.7020&quot;,&quot;dest&quot;:&quot;https://so.csdn.net/so/search?q=%E7%BC%96%E8%AF%91%E5%99%A8&amp;spm=1001.2101.3001.7020&quot;,&quot;extra&quot;:&quot;{\&quot;searchword\&quot;:\&quot;编译器\&quot;}&quot;}" data-tit="编译器" data-pretit="编译器">编译器</a>处理未初始化数据的地方。BSS节不包含任何数据，只是简单的维护开始和结束的地址，以便内存区能在运行时被有效地清零。BSS节在应用程序 的二进制映象文件中并不存在。</p> 
<p><mark>3、将.data和.bss分开的理由是为了节约磁盘空间，.bss不占实际的磁盘空间，为什么.bss不占磁盘空间呢？</mark></p> 
<pre data-index="0" class="prettyprint"><code class="prism language-csharp has-numbering" onclick="mdcp.copyCode(event)" style="position: unset;"><span class="token preprocessor property">#include &lt;stdio.h&gt;</span>
<span class="token keyword">int</span> a<span class="token punctuation">[</span><span class="token number">1000</span><span class="token punctuation">]</span><span class="token punctuation">;</span>
<span class="token keyword">int</span> b<span class="token punctuation">[</span><span class="token number">1000</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token punctuation">{<!-- --></span><span class="token number">1</span><span class="token punctuation">}</span><span class="token punctuation">;</span>
<span class="token keyword">int</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token punctuation">)</span>
<span class="token punctuation">{<!-- --></span>
    <span class="token function">printf</span><span class="token punctuation">(</span><span class="token string">"123\n"</span><span class="token punctuation">)</span><span class="token punctuation">;</span>
    <span class="token keyword">return</span> <span class="token number">0</span><span class="token punctuation">;</span>
<span class="token punctuation">}</span>

<p>这里编写了一个test.c文件，gcc编译<code>gcc test.c -o test</code>之后，使用<code>ls -l test</code> 命令就可以得到可执行文件的信息，文件的大小为<code>12696字节</code></p> 
<pre data-index="1" class="prettyprint"><code class="prism language-csharp has-numbering" onclick="mdcp.copyCode(event)" style="position: unset;"> ls <span class="token operator">-</span>l test
<span class="token operator">-</span>rwxrwxr<span class="token operator">-</span>x <span class="token number">1</span> xxx xxx <span class="token number">12696</span> <span class="token class-name">Dec</span>  <span class="token number">1</span> <span class="token number">01</span><span class="token punctuation">:</span><span class="token number">04</span> test

size test
   text    data     bss     dec     hex filename
   <span class="token number">1174</span>    <span class="token number">4568</span>    <span class="token number">4032</span>    <span class="token number">9774</span>    <span class="token number">262</span>e test
 
<p>接着我们修改源程序：</p> 
<pre data-index="2" class="prettyprint"><code class="prism language-csharp has-numbering" onclick="mdcp.copyCode(event)" style="position: unset;"><span class="token preprocessor property">#include &lt;stdio.h&gt;</span>
<span class="token keyword">int</span> a<span class="token punctuation">[</span><span class="token number">1000</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token punctuation">{<!-- --></span><span class="token number">1</span><span class="token punctuation">}</span><span class="token punctuation">;</span>
<span class="token keyword">int</span> b<span class="token punctuation">[</span><span class="token number">1000</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token punctuation">{<!-- --></span><span class="token number">1</span><span class="token punctuation">}</span><span class="token punctuation">;</span>
<span class="token keyword">int</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token punctuation">)</span>
<span class="token punctuation">{<!-- --></span>
    <span class="token function">printf</span><span class="token punctuation">(</span><span class="token string">"123\n"</span><span class="token punctuation">)</span><span class="token punctuation">;</span>
    <span class="token keyword">return</span> <span class="token number">0</span><span class="token punctuation">;</span>
<span class="token punctuation">}</span>

<p>同样<code>ls -l test</code></p> 
<pre data-index="3" class="prettyprint"><code class="prism language-csharp has-numbering" onclick="mdcp.copyCode(event)" style="position: unset;"> ls <span class="token operator">-</span>l test         
<span class="token operator">-</span>rwxrwxr<span class="token operator">-</span>x <span class="token number">1</span> xxx xxx <span class="token number">16696</span> <span class="token class-name">Dec</span>  <span class="token number">1</span> <span class="token number">01</span><span class="token punctuation">:</span><span class="token number">09</span> test

size test
   text    data     bss     dec     hex filename
   <span class="token number">1174</span>    <span class="token number">8568</span>       <span class="token number">8</span>    <span class="token number">9750</span>    <span class="token number">2616</span> test

<ul><li>可以看到大小从12696变成了16696，与之前相比，该文件占据的大小涨了4000字节，这不就是我们的数组a[1000]的大小吗？</li><li>我们所在的改动<code>仅仅是初始化了a[1000]</code>，让这个数组的所在段从<code>.bss段</code>改到了<code>.data段</code>。</li><li>通过<code>size test</code>命令查看bss段的大小也减小了。这就证明了<code>.bss段中的数据并没有占据磁盘空间</code>，从而<code>节约了磁盘的空间。</code></li></ul> 
<p>linux环境下的c语言，初始值为零和没有赋初始值的变量放在BSS段，因为这些值都是零，所以就不需要放到文件里面，等程序加载的时候再赋值就好了。</p> 
<p><strong>int a[1000]既然不占据实际的磁盘空间(是指不占据应该分配的内存大小)，那么它的大小和符号存在哪呢？</strong></p> 
<ul><li>.bss段占据的大小存放在ELF文件格式中的段表(Section Table)中，段表存放了各个段的各种信息，比如段的名字、段的类型、段在elf文件中的偏移、段的大小等信息。我们可以通过命令<code>readelf -S test</code>来查看test可执行文件的段表。</li><li>.bss不占据实际的磁盘空间，只在段表中记录大小，在符号表中记录符号。当文件加载运行时，才分配空间以及初始化</li></ul> 
<pre data-index="4" class="prettyprint"><code class="prism language-cpp has-numbering" onclick="mdcp.copyCode(event)" style="position: unset;">$ readelf <span class="token operator">-</span>S test<span class="token punctuation">.</span>o
There are <span class="token number">13</span> section headers<span class="token punctuation">,</span> starting at offset <span class="token number">0x2d0</span><span class="token operator">:</span>
Section Headers<span class="token operator">:</span>
  <span class="token punctuation">[</span>Nr<span class="token punctuation">]</span> Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  <span class="token punctuation">[</span> <span class="token number">0</span><span class="token punctuation">]</span>                   <span class="token constant">NULL</span>             <span class="token number">0000000000000000</span>  <span class="token number">00000000</span>
       <span class="token number">0000000000000000</span>  <span class="token number">0000000000000000</span>           <span class="token number">0</span>     <span class="token number">0</span>     <span class="token number">0</span>
  <span class="token punctuation">[</span> <span class="token number">1</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>text             PROGBITS         <span class="token number">0000000000000000</span>  <span class="token number">00000040</span>
       <span class="token number">0000000000000017</span>  <span class="token number">0000000000000000</span>  AX       <span class="token number">0</span>     <span class="token number">0</span>     <span class="token number">1</span>
  <span class="token punctuation">[</span> <span class="token number">2</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>rela<span class="token punctuation">.</span>text        RELA             <span class="token number">0000000000000000</span>  <span class="token number">00000220</span>
       <span class="token number">0000000000000030</span>  <span class="token number">0000000000000018</span>   I      <span class="token number">10</span>     <span class="token number">1</span>     <span class="token number">8</span>
  <span class="token punctuation">[</span> <span class="token number">3</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>data             PROGBITS         <span class="token number">0000000000000000</span>  <span class="token number">00000057</span>
       <span class="token number">0000000000000000</span>  <span class="token number">0000000000000000</span>  WA       <span class="token number">0</span>     <span class="token number">0</span>     <span class="token number">1</span>
  <span class="token punctuation">[</span> <span class="token number">4</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>bss              NOBITS           <span class="token number">0000000000000000</span>  <span class="token number">00000057</span>
       <span class="token number">0000000000000000</span>  <span class="token number">0000000000000000</span>  WA       <span class="token number">0</span>     <span class="token number">0</span>     <span class="token number">1</span>
  <span class="token punctuation">[</span> <span class="token number">5</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>rodata           PROGBITS         <span class="token number">0000000000000000</span>  <span class="token number">00000057</span>
       <span class="token number">0000000000000010</span>  <span class="token number">0000000000000000</span>   A       <span class="token number">0</span>     <span class="token number">0</span>     <span class="token number">1</span>
  <span class="token punctuation">[</span> <span class="token number">6</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>comment          PROGBITS         <span class="token number">0000000000000000</span>  <span class="token number">00000067</span>
       <span class="token number">000000000000002</span>a  <span class="token number">0000000000000001</span>  MS       <span class="token number">0</span>     <span class="token number">0</span>     <span class="token number">1</span>
  <span class="token punctuation">[</span> <span class="token number">7</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>note<span class="token punctuation">.</span>GNU<span class="token operator">-</span>stack   PROGBITS         <span class="token number">0000000000000000</span>  <span class="token number">00000091</span>
       <span class="token number">0000000000000000</span>  <span class="token number">0000000000000000</span>           <span class="token number">0</span>     <span class="token number">0</span>     <span class="token number">1</span>
  <span class="token punctuation">[</span> <span class="token number">8</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>eh_frame         PROGBITS         <span class="token number">0000000000000000</span>  <span class="token number">00000098</span>
       <span class="token number">0000000000000038</span>  <span class="token number">0000000000000000</span>   A       <span class="token number">0</span>     <span class="token number">0</span>     <span class="token number">8</span>
  <span class="token punctuation">[</span> <span class="token number">9</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>rela<span class="token punctuation">.</span>eh_frame    RELA             <span class="token number">0000000000000000</span>  <span class="token number">00000250</span>
       <span class="token number">0000000000000018</span>  <span class="token number">0000000000000018</span>   I      <span class="token number">10</span>     <span class="token number">8</span>     <span class="token number">8</span>
  <span class="token punctuation">[</span><span class="token number">10</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>symtab           SYMTAB           <span class="token number">0000000000000000</span>  <span class="token number">000000</span>d0
       <span class="token number">0000000000000120</span>  <span class="token number">0000000000000018</span>          <span class="token number">11</span>     <span class="token number">9</span>     <span class="token number">8</span>
  <span class="token punctuation">[</span><span class="token number">11</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>strtab           STRTAB           <span class="token number">0000000000000000</span>  <span class="token number">000001f</span><span class="token number">0</span>
       <span class="token number">000000000000002</span>b  <span class="token number">0000000000000000</span>           <span class="token number">0</span>     <span class="token number">0</span>     <span class="token number">1</span>
  <span class="token punctuation">[</span><span class="token number">12</span><span class="token punctuation">]</span> <span class="token punctuation">.</span>shstrtab         STRTAB           <span class="token number">0000000000000000</span>  <span class="token number">00000268</span>
       <span class="token number">0000000000000061</span>  <span class="token number">0000000000000000</span>           <span class="token number">0</span>     <span class="token number">0</span>     <span class="token number">1</span>
Key to Flags<span class="token operator">:</span>
  W <span class="token punctuation">(</span>write<span class="token punctuation">)</span><span class="token punctuation">,</span> A <span class="token punctuation">(</span>alloc<span class="token punctuation">)</span><span class="token punctuation">,</span> X <span class="token punctuation">(</span>execute<span class="token punctuation">)</span><span class="token punctuation">,</span> M <span class="token punctuation">(</span>merge<span class="token punctuation">)</span><span class="token punctuation">,</span> S <span class="token punctuation">(</span>strings<span class="token punctuation">)</span><span class="token punctuation">,</span> I <span class="token punctuation">(</span>info<span class="token punctuation">)</span><span class="token punctuation">,</span>
  L <span class="token punctuation">(</span>link order<span class="token punctuation">)</span><span class="token punctuation">,</span> O <span class="token punctuation">(</span>extra OS processing required<span class="token punctuation">)</span><span class="token punctuation">,</span> G <span class="token punctuation">(</span>group<span class="token punctuation">)</span><span class="token punctuation">,</span> T <span class="token punctuation">(</span>TLS<span class="token punctuation">)</span><span class="token punctuation">,</span>
  C <span class="token punctuation">(</span>compressed<span class="token punctuation">)</span><span class="token punctuation">,</span> x <span class="token punctuation">(</span>unknown<span class="token punctuation">)</span><span class="token punctuation">,</span> o <span class="token punctuation">(</span>OS specific<span class="token punctuation">)</span><span class="token punctuation">,</span> E <span class="token punctuation">(</span>exclude<span class="token punctuation">)</span><span class="token punctuation">,</span>
  l <span class="token punctuation">(</span>large<span class="token punctuation">)</span><span class="token punctuation">,</span> p <span class="token punctuation">(</span>processor specific<span class="token punctuation">)</span>

<ul><li>其中，.rela.text是针对.text段的重定位表，链接器在处理目标文件时，需要对目标文件中的某些部位进行重定位，即代码段和数据段那些对绝对地址的引用的位置，这些重定位的信息都会放在.rela.text中，.rel开头的都是用于重定位。</li><li>LINK表示符号表的下标，INFO表示它作用于哪个段，值是相应段的下标。</li><li>字符串表(.strtab)：保存普通字符串，比如符号名字。</li><li>段表字符串表(.shstrtab)：保存段表中用到的字符串，比如段名。</li><li>ELF文件头和段表都有各自的结构体，这里不列举，只需要知道它里面存储的是什么东西就好。</li></ul> 
<p><mark>总结：为什么需要.bss段？</mark></p> 
<p><strong>1、.data部分：</strong></p> 
<ul><li>数据部分包含初始化的数据项的数据定义。初始化数据是在程序开始运行之前具有值的数据。这些值是可执行文件的一部分。当将可执行文件加载到内存中以供执行时，它们会加载到内存中。</li><li>定义的初始化数据项越多，可执行文件将越大，并且在运行它时将其从磁盘加载到内存所需的时间也越长。</li></ul> 
<p><strong>2、 .bss部分：</strong></p> 
<ul><li>在程序开始运行之前，并非所有数据项都需要具有值。例如，当您从磁盘文件中读取数据时，需要有一个放置数据的位置，以便将数据从磁盘中导入。程序的.bss部分中定义了类似的数据缓冲区。您为缓冲区留出了一定数量的字节，并为缓冲区指定了名称</li><li>.data节中定义的数据项与.bss节中定义的数据项之间存在至关重要的区别：.data节中的数据项增加了可执行文件的大小。.bss部分中的数据项没有</li></ul> 
<h2><a name="t5"></a><a id="14_154"></a>1.4、程序的指令和数据分开原因：</h2> 
<ul><li> <p>1、一方面是当程序被装载后，<code>数据和指令分别被映射到两个虚存区域</code>。由于<code>数据区域对于进程来说是可读写的</code>，而<code>指令区域对于进程来说是只读的</code>，所以这两个虚存区域的权限可以被分别设置成可读写和只读。这样可以<code>防止程序的指令被有意或无意地改写。</code></p> </li><li> <p>2、另外一方面是对于现代的CPU来说，它们有着极为强大的缓存（Cache）体系。指令区和数据区的分离有利于提高程序的局部性。现代CPU的缓存一般都被设计成数据缓存和指令缓存分离，所以程序的指令和数据被分开存放对CPU的缓存命中率提高有好处。</p> </li><li> <p>3、，其实也是最重要的原因，就是当系统中运行着多个该程序的副本时，它们的指令都是一样的，所以内存中只须要保存一份改程序的指令部分。对于指令 这种只读的区域来说是这样，对于其他的只读数据也一样，比如很多程序里面带有的图标、图片、文本等资源也是属于可以共享的。当然每个副本进程的数据区域是不一样的，它们是进程私有的。不要小看这个共享指令的概念，它在现代的操作系统里面占据了极为重要的地位，特别是在有动态链接的系统中，可以节省大量的内存。比如我们常用的Windows Internet Explorer 7.0运行起来以后，它的总虚存空间为112 844 KB，它的私有部分数据为15 944 KB，即有96 900 KB的空间是共享部分。如果系统中运行了数百个进程，可以想象共享的方法来节省大量空间。关于内存共享的更为深入的内容我们将在装载这一章探讨。</p> 
  <ul><li>简单来说就是：代码段是可以共享的，数据段是私有的，当运行多个程序的副本时，只需要保存一份代码段部分。</li></ul> </li></ul> 
<h1><a name="t6"></a><a id="_169"></a>参考</h1> 
<p>1、https://www.zhihu.com/search?type=content&amp;q=.data%E5%92%8C.bss<br> 2、https://zhuanlan.zhihu.com/p/145263213</p>
                </div>
