[BITS 16]
[ORG 0]
jmp 0x7C0:start
nop

start:
	mov ax, cs
	mov ds, ax
	mov es, ax
	
	cli 			;Interrupts deaktivieren
	mov ax, 0x9000		;Stackadresse in ax schieben
	mov ss, ax		;Stack festlegen
	mov sp, 0		;Stackpointer auf 0
	sti
		
	mov si, loadmsg
	call putstr

	mov si, secload
	call putstr

floppy_reset:
	mov ah, 0x00		; Interrupt 13h Funktion zum Reset des Diskettenlaufwerks auswaehlen
	int 0x13		; Reset Diskettenlaufwerk
	jc floppy_reset	; Wenn CFlag gesetzt ist ein Fehler aufgetreten

	mov si, success_drivereset
	call putstr

;Arguments: dh: HEAD, cl: SECTOR, al: NUMSECTS, es: SEGMENT, bx: OFFSET
	mov ax, 1000h
	mov es, ax		; Ort, wo Kernel hingeladen wird
	mov al, 0x01		; Anzahl der zu lesenden Sektoren
	
	mov cl, 0x02		; Start Sektor	
	mov bx, 0x00		; Offset, an dem begonnen werden soll, den Kernel hinzuladen
	mov dh, 0x00		; Kopf Nummer
	call read_sect		; Sektor einlesen
	
;	mov bx, 0
;	read_next:
;		cmp byte [acthead], 0
;		jne prhd1
;			mov si, msg_head0
;			jmp prend
;		prhd1:
;			mov si, msg_head1
;		prend:
;			call putstr
;		cmp byte [readblocks], 0
;		je read_exit			;no more blocks to read -> exit
;		
;		mov al, 1			;number of sectors to read
;		mov cl, [actsect]
;		mov dh, [acthead]
;		call read_sect
;		
;		cmp byte [acthead], 0
;		je head1
;		head0:
;			mov byte [acthead], 0
;			inc byte [actsect]
;			jmp head_end
;		head1:
;			mov byte [acthead], 1
;		head_end:
;		
;		dec byte [readblocks]
;		mov ax, es
;		add ax, 0x20
;		mov es, ax
;		mov ah, 2
;		;add bx, 512
;		jmp read_next
		
;	read_exit:
	
;		mov si, msg_blocks_loaded
;		call putstr
	
	;mov cl, 0x02
 	;add bx, 512
	;mov dh, 1
	;call read_sect
	
	mov cl, 0x03
	add bx, 512
	mov dh, 0
	call read_sect
	
	;mov cl, 0x03
	;add bx, 512
	;mov dh, 1
	;call read_sect
	
	mov cl, 0x04
	add bx, 512
	mov dh, 0
	call read_sect
	
	;mov cl, 0x04
	;add bx, 512
	;mov dh, 1
	;call read_sect
	
	mov cl, 0x05
	add bx, 512
	mov dh, 0
	call read_sect
	
	;mov cl, 0x05
	;add bx, 512
	;mov dh, 1
	;call read_sect
	
	mov cl, 0x06
	add bx, 512
	mov dh, 0
	call read_sect
	
	;mov cl, 0x06
	;add bx, 512
	;mov dh, 1
	;call read_sect
	
	mov cl, 0x07
	add bx, 512
	mov dh, 0
	call read_sect
	
	;mov cl, 0x07
	;add bx, 512
	;mov dh, 1
	;call read_sect
	
	mov cl, 0x08
	add bx, 512
	mov dh, 0
	call read_sect
	
	;mov cl, 0x08
	;add bx, 512
	;mov dh, 1
	;call read_sect
	
	mov cl, 0x09
	add bx, 512
	mov dh, 0
	call read_sect
	
	;mov cl, 0x0A
	;add bx, 512
	;mov dh, 1
	;call read_sect
	
	mov cl, 0x0A
	add bx, 512
	mov dh, 0
	call read_sect
	
	;mov cl, 0x09
	;add bx, 512
	;mov dh, 1
	;call read_sect
	
	mov ax, 1000h
	mov es, ax		; Ort, wo Kernel hingeladen wird
	mov al, 0x01		; Anzahl der zu lesenden Sektoren
	
	mov cl, 0x02		; Start Sektor	
	mov bx, 0x00		; Offset, an dem begonnen werden soll, den Kernel hinzuladen
	mov dh, 0x00		; Kopf Nummer
	call read_sect		; Sektor einlesen

	mov si, prekernel_ok
	call putstr
	
	mov si, kernel_start
	call putstr
	
	cli			; Interrupts deaktivieren
	mov ax, 1000h
	mov ds, ax		; Da Kernel an 1000h muessen nun die Daten ab dieser Adresse berechnet werden
	sti			; Interrupts aktivieren

	jmp 1000h:0000	; zum Anfangscode des Kernels springen

;Funktion: String ausgeben
putstr:
	lodsb
	or al, al
	jz short putstrd
	mov ah, 0x0E
	mov bx, 0x0007
	int 0x10
	jmp putstr
	
	putstrd:
	retn

success_drivereset	db "[Drive resetted...]", 13, 10, 0
kernel_start 		db "[Now booting stage2...]", 13, 10, 0
prekernel_ok		db "[stage2 loaded into memory...]", 10, 13, 0
secload			db "[loading stage2 sectors...]", 10, 13, 0
loadmsg 		db "[Now starting EphesOS...]", 10, 13, 0
;msg_head0		db "head 0", 13, 10, 0
;msg_head1		db "head 1", 13, 10, 0
;msg_blocks_loaded	db "blocks loaded successfully", 13, 10, 0
;readblocks		db 5 ;Number of blocks to read from the floppy (block=512b)
;acthead			db 1
;actsect			db 1

;Arguments: dh: HEAD, cl: SECTOR, al: NUMSECTS, es: SEGMENT, bx: OFFSET
read_sect:
	mov al, 1
	mov ah, 02	;Function 2 = read sect
	mov dl, 0	;drive 0 = Floppy
	mov ch, 0
	int 13h
	jc read_sect
	retn

times 510-($-$$) db 0
dw 0xAA55