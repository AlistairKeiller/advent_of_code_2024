#!/bin/bash
as -o asm.o asm.s -g
g++ -c -o file.o file.c++ -g
g++ -o asm file.o asm.o -g
./asm