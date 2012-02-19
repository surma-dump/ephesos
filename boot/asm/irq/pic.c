#include <pmode.h>
#include <pic.h>

void _init_pic()
{
	_init_pics_cascade(0x20, 0x28);
}

#define PIC1 0x20
#define PIC2 0xA0

#define ICW1 0x11
#define ICW4 0x01

/* _init_pics_cascade()
 * init the PICs and remap them
 */
void _init_pics_cascade(int pic1, int pic2)
{
	/* send ICW1 */
	outb(PIC1, ICW1);
	outb(PIC2, ICW1);

	/* send ICW2 */
	outb(PIC1 + 1, pic1);	/* remap */
	outb(PIC2 + 1, pic2);	/*  pics */

	/* send ICW3 */
	outb(PIC1 + 1, 4);	/* IRQ2 -> connection to slave */
	outb(PIC2 + 1, 2);

	/* send ICW4 */
	outb(PIC1 + 1, ICW4);
	outb(PIC2 + 1, ICW4);

	/* disable all IRQs */
	outb(PIC1 + 1, 0xFF);
}
