global main

main:
    mov eax, 50
    cmp eax, 10                         ; 对eax和10进行比较
    jle xiaoyu_dengyu_shi            ; 小于或等于的时候跳转
    sub eax, 10
xiaoyu_dengyu_shi:
    ret
