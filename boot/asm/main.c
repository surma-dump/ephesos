#include <utils.h>
#include <pmode.h>
#include <pic.h>
#include <console.h>
#include <idt.h>

int main()
{
	_clearscreen();
	_printstr("*** WELCOME TO 32-bit Protected Mode ***\n");
	_printstr("setting up idt...");
	_setup_idt();
	//__console_process("setting up idt...", _setup_idt());
	__console_msg("Interrupts are now enabled!");
	
	asm volatile("int $0x80");
	
	hang:
		goto hang;
	
	return 0;
}



