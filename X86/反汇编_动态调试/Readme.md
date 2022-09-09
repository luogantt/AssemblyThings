```
global main

main:
		mov ebx, 1                   ; 将ebx赋值为1
		mov ecx, 2                   ; 将ecx赋值为2
		add ebx, ecx                 ; ebx = ebx + ecx
		    
		mov [sui_bian_xie], ebx      ; 将ebx的值保存起来
		mov eax, [sui_bian_xie]      ; 将刚才保存的值重新读取出来，放到eax中
		    
		ret                          ; 返回，整个程序最后的返回值，就是eax中的值

section .data
sui_bian_xie   dw    0
```

```
section .data
sui_bian_xie   dw    0
```

第一行先不管是表示接下来的内容经过编译后，会放到可执行文件的数据区域，同时也会随着程序启动的时候，分配对应的内存。

第二行就是描述真实的数据的关键所在里，这一行的意思是开辟一块4字节的空间，并且里面用0填充。这里的dw（double word）就表示4个字节，前面那个sui_bian_xie的意思就是这里可以随便写，也就是起个名字而已，方便自己写代码的时候区分，这个sui_bian_xie会在编译时被编译器处理成一个具体的地址，我们无需理会地址具体时多少，反正知道前后的sui_bian_xie指代的是同一个东西就行了。


#### 代码编译

```
nasm -f elf main.asm -o main.o
gcc -m32  main.o -o main
./main ; echo $?
```

