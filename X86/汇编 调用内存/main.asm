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

