[BITS 32]

jmp in_pm
nop
db "IN_PM"	
in_pm:
	;create the selector in ax (we want to select the second entry of the gdt as ds)
	mov ax, 0000000000010000b
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	;mov ax, 0000000000010000b
	;mov bp, ax
	
	;mov ax, 0000000000010000b
	;mov es, ax
	
	;create the selector in ax (we want to select the second entry of the gdt as ss)
	mov ax, 0000000000010000b
	mov ss, ax
	mov esp, 0x1000000
	
	mov eax, 0xB8000
	mov ecx, 1024
	
	mov edx, 0x10E00
writechar:
	mov byte bl, [0x10800];[edx]
	mov byte [eax], bl;'P' ;0x07
	inc eax
	mov byte [eax], 0x41
	inc  eax
	inc edx
	
	loop writechar
	call start_c
	;jmp 0x400

times 512-($-$$) db 0
start_c: