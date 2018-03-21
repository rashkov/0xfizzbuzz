 .section .data

number_format:
 .ascii "%d\n\0"
 .section .text
 .globl _start

_start:
 movl $0, %eax
 movl $10, %ebx

_loop:
 incl %eax
 pushl %eax
 pushl %ebx

 # Check mod 3
 pushl $3
 pushl %eax
 call _modulo
 cmpl $0, %eax
 popl %eax # restore the number
 jne _not_mod_3
 # print the number
 pushl %eax
 call _print_number
 addl $0x4, %esp
_not_mod_3:
 addl $0x4, %esp


 popl %ebx 
 popl %eax
 # check "do while" condition
 cmpl %eax, %ebx
 jne _loop

 # exit
 pushl $0
 call exit

# Param 1: the number to print
_print_number:
 pushl %ebp
 movl %esp, %ebp
 # Grab parameter
 movl 8(%ebp), %eax

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

# Modulo function
# Param 1: b, in a=b(mod n)
# Param 2: n, in a=b(mod n)
# Returns  a, in a=b(mod n)
_modulo:
 pushl %ebp
 movl %esp, %ebp

 movl $0, %edx # zero out edx as required by divl
 movl 8(%ebp), %eax # set the numerator
 movl 12(%ebp), %esi # set the denominator
 divl %esi # quotient is placed in eax, remainder in edx

 # set the return value
 movl %edx, %eax

 movl %ebp, %esp
 popl %ebp
 ret
