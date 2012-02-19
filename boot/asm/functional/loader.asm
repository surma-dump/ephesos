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


	mov cl, 0x02		; Start Sektor
	mov ax, 1000h
	mov es, ax		; Ort, wo Kernel hingeladen wird
	mov bx, 0x00		; Offset, an dem begonnen werden soll, den Kernel hinzuladen
	mov al, 0x04		; Anzahl der zu lesenden Sektoren
read_sector:
	mov ah, 0x02		; Interrupt 13h Funktion zum Lesen von Sektoren
	mov ch, 0x00		; Spur 0
	mov dl, 0x00		; Laufwerks Nummer (0 = Erstes Diskettenlaufwerk)
	mov dh, 0x00		; Kopf Nummer
	int 13h		; Sektor einlesen
	jc read_sector		; Wenn CFlag gesetzt ist ein Fehler aufgetreten, nochmal versuchen

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

times 510-($-$$) db 0
dw 0xAA55