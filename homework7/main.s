.include "macro-syscalls.m"
.globl main
main:
.text
li	s0 0
loop:		# loop for displaying everything
mv	a0, s0	# passing number
li t1 2		
rem	a1, t0, t1	# passing indicator as remainder from division by 2
jal display_n   
addi	s0 s0 1		# next number
sleep(1000)		# 1 second sleep
j	loop

exit