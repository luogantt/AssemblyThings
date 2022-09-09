global main

main:
    mov eax, 1
    
    cmp eax, 100
    jle xiao_deng_yu_100
    sub eax, 20
    
xiao_deng_yu_100:
    add eax, 1
    ret
