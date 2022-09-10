#!/bin/bash

nasm -f elf main.asm -o main.o
gcc -m32  main.o -o main

echo "assembly  sum is "
./main ; echo $?

gcc -o  main1 main1.c 
echo "while sum is "
./main1 ; echo $?



gcc -o  goto  goto.c 
echo "goto sum is "
./goto ; echo $?
