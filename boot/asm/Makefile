CFLAGS=-std=c99 -fasm
INCLUDEFLAGS=-I"include"

START_TEXT=0x10400
START_DATA=0x10C00
START_BSS=0x11000

LDFLAGS=-Ttext $(START_TEXT) -Tdata $(START_DATA) -Tbss $(START_BSS)

all:
	rm -f ../../bin/boot.bin ../../bin/loader.bin ../../bin/stage2.bin ../../bin/in_pmode.bin ../../bin/cmain.bin *.o
	nasm loader.asm -o ../../bin/loader.bin
	nasm stage2.asm -o ../../bin/stage2.bin
	nasm in_pmode.asm -o ../../bin/in_pmode.bin
	
	gcc $(CFLAGS) $(INCLUDEFLAGS) -c main.c
	gcc $(CFLAGS) $(INCLUDEFLAGS) -c console.c
	gcc $(CFLAGS) $(INCLUDEFLAGS) -c idt.c
	cd irq && make
		
	ld -o main $(LDFLAGS) -e main main.o ./irq/*.o console.o idt.o
	objcopy  -S -O binary main ../../bin/cmain.bin
	../../tools/copy2gether/copy2gether -paddend 524288 0 ../../bin/boot.bin ../../bin/loader.bin ../../bin/stage2.bin ../../bin/in_pmode.bin ../../bin/cmain.bin > /dev/null