#!/bin/bash

nasm -f elf first.asm -o first.o
gcc -m32 first.o -o first

./first ; echo $?
