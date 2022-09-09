#!/bin/bash

gcc -m32 main.c -o main
nasm -f elf test02.asm -o test02.o
gcc -m32 -fno-lto test02.o -o test02

echo "run main.c "
./main ; echo $?

echo "run  test02.asm"
./test02 ; echo $?
