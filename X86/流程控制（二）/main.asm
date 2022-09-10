global main

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
    ret
