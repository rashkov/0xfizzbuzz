 .section .data

number_format:
 .ascii "%d\n\0"
fizz_format:
 .ascii "fizz\n\0"
buzz_format:
 .ascii "buzz\n\0"
 .section .text
 .globl _start

_start:
 movl $0, %eax
 movl $10, %ebx

_loop:
 incl %eax
 pushl %eax
 pushl %ebx

 pushl %eax # save number
 call _check_mod_3
 movl %eax, %ecx # save return value
 popl %eax # restore number

 pushl %eax # save number
 call _check_mod_5
 orl %eax, %ecx # OR return val w/ previous one
 popl %eax # restore number

 # Print number if neither modulo's were true
 cmpl $0, %ecx
 jne _modulo_true
 pushl %eax
 call _print_number
 popl %eax
 _modulo_true:

 popl %ebx 
 popl %eax
 # check "do while" condition
 cmpl %eax, %ebx
 jne _loop

 # exit
 pushl $0
 call exit

_print_fizz:
 pushl %ebp
 movl %esp, %ebp

 # push printf params
 pushl $fizz_format
 call printf
 # Clean up printf params
 addl $0x4, %esp 
 # Set return vale
 movl $0, %eax

 movl %ebp, %esp
 popl %ebp
 ret

_print_buzz:
 pushl %ebp
 movl %esp, %ebp

 # push printf params
 pushl $buzz_format
 call printf
 # Clean up printf params
 addl $0x4, %esp 
 # Set return vale
 movl $0, %eax

 movl %ebp, %esp
 popl %ebp
 ret

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

# Check mod 3
# Param 1: the number to check
_check_mod_3:
 pushl %ebp
 movl %esp, %ebp
 # Grab param
 movl 8(%ebp), %eax

 # initialize our return value
 pushl $0 # -4(%ebp)

 pushl $3
 pushl %eax
 call _modulo
 cmpl $0, %eax
 jne _not_mod_3
 popl %eax # cleanup from call to _modulo
 addl $0x4, %esp # cleanup from call to _modulo

 movl $1, -4(%ebp)
 call _print_fizz
 movl 4(%esp), %eax # restore number
 jmp _done_check_mod_3

 _not_mod_3:
  popl %eax # cleanup from call to _modulo
  addl $0x4, %esp # cleanup from call to _modulo
 
 _done_check_mod_3:
  # set the return value
  movl -4(%ebp), %eax
 
  movl %ebp, %esp
  popl %ebp
  ret

# Check mod 5
# Param 1: the number to check
_check_mod_5:
 pushl %ebp
 movl %esp, %ebp
 # Grab param
 movl 8(%ebp), %eax

 # initialize our return value
 pushl $0 # -4(%ebp)

 pushl $5
 pushl %eax
 call _modulo
 cmpl $0, %eax
 jne _not_mod_5
 popl %eax # cleanup from call to _modulo
 addl $0x4, %esp # cleanup from call to _modulo

 movl $1, -4(%ebp)
 call _print_buzz
 movl 4(%esp), %eax # restore number
 jmp _done_check_mod_5

 _not_mod_5:
  popl %eax # cleanup from call to _modulo
  addl $0x4, %esp # cleanup from call to _modulo
 
 _done_check_mod_5:
  # set the return value
  movl -4(%ebp), %eax
 
  movl %ebp, %esp
  popl %ebp
  ret
