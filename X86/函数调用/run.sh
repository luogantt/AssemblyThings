#!/bin/bash

nasm -f elf main.asm -o main.o
gcc -m32  main.o -o plsone
./plsone ; echo $?

