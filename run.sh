#!/bin/bash

bison -t --debug -dy bison.y
flex flex.l

gcc lex.yy.c y.tab.c -o exec
./exec

nasm -f elf32 out.asm
gcc -m32 out.o -o out

