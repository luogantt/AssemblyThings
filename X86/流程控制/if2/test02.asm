global main

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
ret 
