#!/bin/bash

gcc -g main.c -o main

gcc -g main1.c -o main1

echo "查看 main 文件的大小..."
ls -l main
echo "查看 main1 文件的大小..."
ls -l main1

echo "size main..."
size main
echo "size main..."
size main1
