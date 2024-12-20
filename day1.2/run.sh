#!/bin/bash
as -o compute_distance.o compute_distance.s
g++ -c -o file.o file.c++ -g
g++ -o day1 file.o compute_distance.o -g
./day1