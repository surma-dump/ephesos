[BITS 16]

jmp 1000h:start
nop

start:
	mov ax, cs
	mov ds, ax
	mov es, ax
	
	;disable pic
	mov byte	al, 0xFF
	out byte	0x21, al
	nop
	out byte	0xA1, al
	
	;Load the gdt
	cli
	lgdt [mygdt]
	
	;activate PM
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	jmp to_pmode

to_pmode:   
	;jump to "in_pmode.asm"
	db 0x66
	db 0xEA            ;Jmp to:
	dd 0x10200        ;<offset>
	dw 0000000000001000b    ;<selector> 
	
alignb 2	
mygdt:
	gdtlimit	dw 32
	gdtbase1	dw gdt_start
	gdtbase2	dw 0x1

alignb 2
gdt_start:
	nulldescriptor		times 8 db 0
	;kerneldescriptor: 	
	;			ksegsize 	dw 0xFFFF		;4 GiB segsize, see also the first 4 bits of ksegmisc
	;			ksegbase1 	dw 0x0000		;
	;			ksegbase2	db 0x00			;
	;			
	;			;-------------------_________Present Flag 1: present, 0: non-present
	;			;------------------/ ________Descriptor Privileg Level, 00, 01, 10, 11
	;			;------------------|/  ______Segment-bit 1: Memory Segment, 0: other segment type
	;			;------------------|| / _____Segment type 000: data-r, 001: data-rw, 010 reserved, 011: expand-down, 100 code-x, 101: code-rx, 110: code-x, 111: code-ax
	;			;------------------|| |/   __Access bit, set by the CPU
	;			;------------------|| ||  /
	;			;------------------|| ||  |
	;			;------------------|| ||\ |
	;			;------------------||\||\\|
	;			ksegacctype 	db 10011000b
	;			;-------------------_________Granularity bit 0: max. segsize=1MB, 1: max. segsize=4GB
	;			;------------------/ ________D/B-bit. 0: 286 segment, 1: 386+ segment
	;			;------------------|/ _______reserved
	;			;------------------||/ ______user-defined
	;			;------------------|||/ _____size: bits 16-19
	;			;------------------||||/
	;			;------------------|||||\
	;			;------------------|||||\\
	;			;------------------|||||\\\
	;			ksegmisc 	db 11001111b
	;			ksegbase3	db 0x00
	;
	kerneldescriptor:
			dw 0xFFFF
			dw 0
			dw 0x9A00
			dw 0x00CF			
	vramdescriptor:
			dw 0xFFFF
			dw 0
			dw 0x9200
			dw 0x00CF
	;vramdescriptor:
	;			vrsegsize 	dw 0xFFFF		;4 GiB segsize, see also the first 4 bits of ksegmisc
	;			vrsegbase1 	dw 0x0000		;
	;			vrsegbase2	db 0x00			;
	;			
	;			;-------------------_________Present Flag 1: present, 0: non-present
	;			;------------------/ ________Descriptor Privileg Level, 00, 01, 10, 11
	;			;------------------|/  ______Segment-bit 1: Memory Segment, 0: other segment type
	;			;------------------|| / _____Segment type 000: data-r, 001: data-rw, 010 reserved, 011: expand-down, 100 code-x, 101: code-rx, 110: code-x, 111: code-ax
	;			;------------------|| |/   __Access bit, set by the CPU
	;			;------------------|| ||  /
	;			;------------------|| ||  |
	;			;------------------|| ||\ |
	;			;------------------||\||\\|
	;			vrsegacctype 	db 10010010b
	;			;-------------------_________Granularity bit 0: max. segsize=1MB, 1: max. segsize=4GB
	;			;------------------/ ________D/B-bit. 0: 286 segment, 1: 386+ segment
	;			;------------------|/ _______reserved
	;			;------------------||/ ______user-defined
	;			;------------------|||/ _____size: bits 16-19
	;			;------------------||||/
	;			;------------------|||||\
	;			;------------------|||||\\
	;			;------------------|||||\\\
	;			vrsegmisc 	db 11001111b
	;			vrsegbase3	db 0x00
				
	stackdescriptor:
				stacksegsize 	dw 0xFFFF		;4 GiB segsize, see also the first 4 bits of ksegmisc
				stacksegbase1 	dw 0x0000		;
				stacksegbase2	db 0x09			;
				
				;-------------------_________Present Flag 1: present, 0: non-present
				;------------------/ ________Descriptor Privileg Level, 00, 01, 10, 11
				;------------------|/  ______Segment-bit 1: Memory Segment, 0: other segment type
				;------------------|| / _____Segment type 000: data-r, 001: data-rw, 010 reserved, 011: expand-down, 100 code-x, 101: code-rx, 110: code-x, 111: code-ax
				;------------------|| |/   __Access bit, set by the CPU
				;------------------|| ||  /
				;------------------|| ||  |
				;------------------|| ||\ |
				;------------------||\||\\|
				stacksegacctype db 10010010b
				;-------------------_________Granularity bit 0: max. segsize=1MB, 1: max. segsize=4GB
				;------------------/ ________D/B-bit. 0: 286 segment, 1: 386+ segment
				;------------------|/ _______reserved
				;------------------||/ ______user-defined
				;------------------|||/ _____size: bits 16-19
				;------------------||||/
				;------------------|||||\
				;------------------|||||\\
				;------------------|||||\\\
				stacksegmisc 	db 11001111b
				stacksegbase3	db 0x00


times 512-($-$$) db 0