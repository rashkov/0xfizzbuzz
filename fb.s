 .section .data

number_format:
 .ascii "%d\n\0"
fizz_format:
 .ascii "fizz\n\0"
buzz_format:
 .ascii "buzz\n\0"
fizzbuzz_format:
 .ascii "fizzbuzz\n\0"
 .section .text
 .globl _start

_start:
 movl $0, %eax
 movl $100, %ebx

_loop:
 incl %eax
 pushl %eax
 pushl %ebx

 pushl $3
 pushl %eax
 call _check_mod
 movl %eax, %ecx # save return value
 popl %eax # restore number
 addl $0x4, %esp

 pushl $5
 pushl %eax # save number
 call _check_mod
 shll $1, %ecx # left shift to make room for new return val
 orl %eax, %ecx # OR return val w/ previous one
 popl %eax # restore number
 addl $0x4, %esp

 # ecx has one of four values:
 #  0: neither 3 nor 5
 #  1: only 5
 #  2: only 3
 #  3: both 3 and 5
 cmpl $0, %ecx
 jne _not_zero
 pushl %eax

 pushl %eax
 pushl $number_format
 call printf
 addl $0x8, %esp 

 popl %eax
 jmp _done_compare
 _not_zero:
  cmpl $1, %ecx
  jne _not_one
  pushl %eax

  pushl $buzz_format
  call printf
  addl $0x4, %esp

  popl %eax
  jmp _done_compare
  _not_one:
   cmpl $2, %ecx
   jne _not_two
   pushl %eax

   pushl $fizz_format
   call printf
   addl $0x4, %esp

   popl %eax
   jmp _done_compare
   _not_two:
    cmpl $3, %ecx
    jne _not_three
    pushl %eax

    pushl $fizzbuzz_format
    call printf
    addl $0x4, %esp 

    popl %eax
    jmp _done_compare
    _not_three: # Error
 _done_compare:

 popl %ebx 
 popl %eax
 # check "do while" condition
 cmpl %eax, %ebx
 jne _loop

 # exit
 pushl $0
 call exit

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

# Check if modulo equals zero
# Param 1: the number to check
# Param 2:  the modulo value
# Returns 0 if modulo doesn't equal zero
# Returns 1 if modulo equals zero
_check_mod:
 pushl %ebp
 movl %esp, %ebp
 # Grab param 1
 movl 8(%ebp), %eax
 # Grab param 2
 movl 12(%ebp), %ebx

 # initialize our return value
 pushl $0 # -4(%ebp)

 pushl %ebx
 pushl %eax
 call _modulo
 cmpl $0, %eax
 jne _non_zero_mod
 popl %eax # cleanup from call to _modulo
 addl $0x4, %esp # cleanup from call to _modulo

 movl $1, -4(%ebp) # set return value to true
 jmp _done_check_mod

 _non_zero_mod:
  popl %eax # cleanup from call to _modulo
  addl $0x4, %esp # cleanup from call to _modulo
 
 _done_check_mod:
  # set the return value
  movl -4(%ebp), %eax
 
  movl %ebp, %esp
  popl %ebp
  ret

