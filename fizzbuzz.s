.equ STDOUT, 1
.equ SYS_WRITE, 4
.equ SYS_EXIT, 1
.equ LINUX_SYSCALL, 0x80

 .section .data
helloworld:
 .ascii "hello world\n"
helloworld_end:
 .equ helloworld_len, helloworld_end - helloworld
fizz:
 .ascii "fizz\n"
fizz_end:
 .equ fizz_len, fizz_end - fizz
buzz:
 .ascii "buzz\n"
buzz_end:
 .equ buzz_len, buzz_end - buzz

 .equ three, 3
 .equ five, 5

 .section .text
 .globl _start

_start:
 movl $0, %edi
 movl $10, %esi

start_loop:
 cmpl %edi, %esi
 je _exit
 incl %edi
 
 # save off edi and esi
 pushl %edi
 pushl %esi

 movl $0, %edx # zero out edx as required by divl
 movl %edi, %eax # set the numerator
 movl $3, %esi # set the denominator, which is 3
 divl %esi # quotient is placed in eax, remainder in edx
 cmpl $0, %edx
 je _print_fizz

_check_buzz:
 movl $0, %edx # zero out edx as required by divl
 movl %edi, %eax # set the numerator
 movl $5, %esi # set the denominator, which is 3
 divl %esi # quotient is placed in eax, remainder in edx
 cmpl $0, %edx
 je _print_buzz

 jmp _print_number

_print_number:
 # Print a message
 movl $STDOUT, %ebx
 #movl %edi, %ecx
 movl %edi, %ecx # Print the number, in eax
 addl $0x30, %ecx # Convert int to ascii
 pushl %ecx
 movl %esp, %ecx
 movl $1, %edx
 movl $SYS_WRITE, %eax
 int $LINUX_SYSCALL
 popl %ecx
 jmp _loopback

_print_fizz:
 # Print a message
 movl $STDOUT, %ebx
 movl $fizz, %ecx # Print the number, in eax
 movl $fizz_len, %edx
 movl $SYS_WRITE, %eax
 int $LINUX_SYSCALL
 jmp _loopback

_print_buzz:
 # Print a message
 movl $STDOUT, %ebx
 movl $buzz, %ecx # Print the number, in eax
 movl $buzz_len, %edx
 movl $SYS_WRITE, %eax
 int $LINUX_SYSCALL
 jmp _loopback

_loopback:
 # Restore esi and edi
 popl %esi
 popl %edi
 jmp start_loop

_exit:
 # Exit
 movl $0, %ebx
 movl $SYS_EXIT, %eax
 int $LINUX_SYSCALL
