CFLAGS=-std=c99 -fasm
INCLUDEFLAGS=-I"../include"

all:
	as irq.s -o irq.o
	gcc $(CFLAGS) $(INCLUDEFLAGS) -c pic.c -o pic.o