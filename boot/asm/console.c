#include <console.h>

char* vram = (char*)0xB8000;
unsigned long offs = 0;

void _printstr(char* arg)
{	
	while(arg[0] != 0)
	{
		if(arg[0] == '\n')
		{
			offs -= (offs%80);
			offs += 80;
			offs--;
			goto out;
		}
		vram[2*offs] = arg[0];
	out:
		arg++;
		offs++;
		
		if(offs > 1999)
			_movelineup();
	}
}

void _movelineup()
{
	offs -= offs % CONSOLE_CPL;
	offs -= CONSOLE_CPL;
	for(int i = 0; i < 1920*2; i++)
		vram[i] = vram[2*CONSOLE_CPL+i];
		
	for(int i = 0; i < 80; i++)
	{
		vram[3840+2*i] = ' ';
		vram[3840+2*i+1] = 0x07;
	}
}

void _clearscreen()
{
	for(int k = 0; k < 2000; k++)
	{
		vram[2*k] = ' ';
		vram[2*k+1] = 0x07;
	}
}
