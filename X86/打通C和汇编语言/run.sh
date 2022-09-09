#!/bin/bash

gcc -m32 test01.c -o test01
nasm -f elf test02.asm -o test02.o
gcc -m32 -fno-lto test02.o -o test02
ls
