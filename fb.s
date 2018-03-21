 .section .data

number_format:
 .ascii "%d\n\0"
 .section .text
 .globl _start

_start:
 movl $0, %eax
 movl $100, %ebx

_loop:
 incl %eax

 pushl %eax
 pushl %ebx

 # print the number
 call _print_number

 popl %ebx 
 popl %eax

 # check "do while" condition
 cmpl %eax, %ebx
 jne _loop

 # exit
 pushl $0
 call exit

_print_number:
 pushl %ebp
 movl %esp, %ebp

 # push printf params
 pushl %eax
 pushl $number_format
 call printf
 # Clean up printf params
 addl $0x8, %esp 
 # Set return vale
 movl $0, %eax

 movl %ebp, %esp
 popl %ebp
 ret
