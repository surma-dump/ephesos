#ifndef __UUID_KERNEL_PMODE_H
#define __UUID_KERNEL_PMODE_H

#include <types.h>

#define IDTENTRY_DPL_0 0x0
#define IDTENTRY_DPL_1 0x20
#define IDTENTRY_DPL_2 0x40
#define IDTENTRY_DPL_3 0x60

#define IDTENTRY_PRESENT 0x80

typedef struct {
	_u16	offs1;
	_u16	selector;
	_u8	reserved;
	_u8	flags;
	_u16	offs2;
} _idt_entry __attribute__((packed)) __attribute__((aligned(8)));

typedef struct {
	_u16 limit;
	_u32 base;
} _idt_pointer __attribute__((packed)) __attribute__((aligned(8)));


/* Access byte's flags */
#define ACS_PRESENT     0x80            /* present segment */
#define ACS_CSEG        0x18            /* code segment */
#define ACS_DSEG        0x10            /* data segment */
#define ACS_CONFORM     0x04            /* conforming segment */
#define ACS_READ        0x02            /* readable segment */
#define ACS_WRITE       0x02            /* writable segment */
#define ACS_IDT         ACS_DSEG        /* segment type is the same type */
//#define ACS_INT_GATE    0x06            /* int gate for 286 */
#define ACS_INT_GATE    0x0E            /* int gate for 386 */
#define ACS_INT         (ACS_PRESENT | ACS_INT_GATE) /* present int gate */

/* Ready-made values */
#define ACS_CODE        (ACS_PRESENT | ACS_CSEG | ACS_READ)
#define ACS_DATA        (ACS_PRESENT | ACS_DSEG | ACS_WRITE)
#define ACS_STACK       (ACS_PRESENT | ACS_DSEG | ACS_WRITE)



/*
 * Output to x86 port
 *
 *  outb	Output one byte
 *  outw	Output two bytes
 *  outl	Output four bytes
 *
 *  ___v	Datas
 *  ___p	Port number
 *
 */
#define outb(___p, ___v) \
	asm("outb %%al,%%dx\n\t" :: "a" (___v), "d" (___p))
	
#define outw(___p, ___v) \
	asm("outw %%ax,%%dx\n\t" :: "a" (___v), "d" (___p))

#define outl(___p, ___v) \
	asm("outl %%eax,%%dx\n\t" :: "a" (___v), "d" (___p))

/*
 * Read from x86 port
 *
 *  inb		Read one byte
 *  inw		Read two bytes
 *  inl		Read four bytes
 *
 *  ___p	Port number
 *
 * Returns readed datas.
 *
 */	
#define inb(___p) \
({\
	uint8_t ___v;\
	\
	__asm __volatile__\
		("inb %%dx,%%al\n\t" : "=a" (___v) : "d" (___p)); \
\
	___v;\
})

#define inw(___p) ({\
	uint16_t ___v;\
	\
	__asm __volatile__\
		("inw %%dx,%%ax\n\t" : "=a" (___v) : "d" (___p)); \
\
	___v;\
})

#define inl(___p) \
({\
	uint32_t ___v;\
	\
	__asm __volatile__\
		("inl %%dx,%%eax\n\t" : "=a" (___v) : "d" (___p)); \
\
	___v;\
})

/*
 * Read x86 time stamp counter (64-bit value; only available to Pentium or
 * later)
 *
 * ___l		variable that should save the lowest 32-bit of the counter
 * ___h		variable that should save the highest 32-bit of the counter
 *
 */
#define rdtsc(___l, ___h) \
({\
	\
	__asm __volatile__\
		("rdtsc\n\t" : "=a" (___l),  "=d" (___h):: "memory"); \
\
})

#define	IRQ(irqnr)			(0xA0 + irqnr)

#endif //__UUID_KERNEL_PMODE_H
