.include "macro-syscalls.m"
.global display_n

display_n:
push(ra)
li	t0 16
li	t1 0
ble	a0 t0 after_dot
li	t1	1 # mark need of dot
rem	a0 a0 t0	# needed digit
after_dot:
nul:			# assign display code for the digit
li	t0 0
bne	a0 t0 one
li	t2 0x3f
j after_number
one:
li	t0 1
bne	a0 t0 two
li	t2 0x6
j after_number
two:
li	t0 2
bne	a0 t0 three
li	t2 0x5b
j after_number
three:
li	t0 3
bne	a0 t0 four
li	t2 0x4f
j after_number
four:
li	t0 4
bne	a0 t0 five
li	t2 0x66
j after_number
five:
li	t0 5
bne	a0 t0 six
li	t2 0x6d
j after_number
six:
li	t0 6
bne	a0 t0 seven
li	t2 0x7d
j after_number
seven:
li	t0 7
bne	a0 t0 eight
li	t2 0x7
j after_number
eight:
li	t0 8
bne	a0 t0 nine
li	t2 0x7f
j after_number
nine:
li	t0 9
bne	a0 t0 ten
li	t2 0x6f
j after_number
ten:
li	t0 10
bne	a0 t0 eleven
li	t2 0x77
j after_number
eleven:
li	t0 11
bne	a0 t0 twelve
li	t2 0x7c
j after_number
twelve:
li	t0 12
bne	a0 t0 thirteen
li	t2 0x39
j after_number
thirteen:
li	t0 13
bne	a0 t0 fourteen
li	t2 0x5e
j after_number
fourteen:
li	t0 14
bne	a0 t0 fifteen
li	t2 0x79
j after_number
fifteen:
li	t2 0x71
j after_number

after_number:			# if dot is needed add its code
beqz	t1, after_add_dot
addi	t2, t2 0x80

after_add_dot:		# displaying digits
lui     t6 0xffff0          # MMIO
beqz	a1 left		# if a1 == 0 right indicator, else left indicator
right:
sb      t2 0x10(t6)
j end_func
left:
sb      t2 0x11(t6)
end_func:		# the end.
pop(ra)
ret
