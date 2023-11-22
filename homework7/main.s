.include "macro-syscalls.m"
.globl main
main:
.text
li	s0 1
loop:
mv	a0, s0
li t1 2
rem	a1, t0, t1
jal display_n   
addi	s0 s0 1
sleep(1000)
j	loop

exit