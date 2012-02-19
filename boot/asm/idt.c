#include <idt.h>
#include <pmode.h>
#include <pic.h>

volatile _idt_pointer idt __attribute__ ((packed)) __attribute__ ((aligned (8)));
volatile _idt_entry entries[NUM_IDT_ENTRIES] __attribute__ ((packed)) __attribute__ ((aligned (8)));

void fill_idt_entry(_idt_entry* entr, _u32 func, _u16 sel, _u8 access, _u8 param_cnt)
{
	entr->selector = sel;
	entr->offs1 = func & 0xFFFF;
	entr->offs2 = func >> 16;
	entr->flags = access;
	entr->reserved = param_cnt;
}

extern void interrupt0();
extern void asmtestfunc();
void _setup_idt()
{
	idt.base = (_u32)entries;
	idt.limit = 8*(NUM_IDT_ENTRIES-1);
	
	
	for(int i = 0; i < NUM_IDT_ENTRIES; i++)
		fill_idt_entry((_u32)&entries[i], (_u32)&interrupt0, 8, ACS_INT, 0);
		
	_init_pic();
	asm volatile("lidt (%%eax)\n" ::"a"(&idt));
 	//asm volatile("sti"::);
	
	asm volatile("call (%%eax)" ::"a"(asmtestfunc));
	//asm volatile("int $0x80");*/
}
