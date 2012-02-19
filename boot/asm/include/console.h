#ifndef __UUID_KERNEL_CONSOLE_H
#define __UUID_KERNEL_CONSOLE_H

void _printstr(char* arg);
void _clearscreen();
void _movelineup();

//Characters per Line
#define CONSOLE_CPL 80

#define __console_process(str, what) do { \
					_printstr(str); \
					what; \
					_printstr("done\n"); \
					} \
					while(0);
					
#define __console_msg(str) _printstr(str "\n");

#endif //__UUID_KERNEL_CONSOLE_H
