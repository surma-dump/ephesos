[BITS 32]

jmp in_pm
nop
	
in_pm:
	;create the selector in ax (we want to select the second entry of the gdt as ds)
	mov ax, 0000000000010000b
	mov ds, ax
	
	;create the selector in ax (we want to select the third entry of the gdt as ss)
	mov ax, 0000000000011000b
	mov ss, ax
	mov sp, 0
	
	mov eax, 0xB8000
	mov ecx, 100
	
writechar:
	mov byte [eax], 'P' ;0x07
	inc eax
	mov byte [eax], 0x41
	inc  eax
	
	loop writechar
hang:
	jmp hang
	
times 4096 db 0