.section .data
		
.section .text
.globl asmtestfunc
.globl interrupt0

asmtestfunc:
	movb $0x43, %al
	movb %al, 0xB8000
        ret
	
.align 8
interrupt0:
	pusha
	push %gs
	push %fs
	push %es
	push %ds
	
	movb $0x43, %al
	movb %al, 0xB8002
	
	pop %ds
	pop %es
	pop %fs
	pop %gs
	popa
	iret




