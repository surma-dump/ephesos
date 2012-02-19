#ifndef __UUID_KERNEL_IDT_H
#define __UUID_KERNEL_IDT_H

#include <pmode.h>

extern void interrupt0();
void _setup_idt();
void fill_idt_entry(_idt_entry* entr, _u32 func, _u16 sel, _u8 access, _u8 param_cnt);

#define NUM_IDT_ENTRIES	256

#endif //__UUID_KERNEL_IDT_H
