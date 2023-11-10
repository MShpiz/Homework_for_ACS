.include "macrolib.s"
.global strncpy

strncpy:
	push(ra)
	push(s0)
	push(s1)
	push(a0)
	mv	t6 a0			# copy buf
	mv	s0 a1			#string
	mv	s1 a2			# count
	
	li t0 102
	ble	s1 t0 zero_check		# if count is bigger than buffer size, change to buffer size
	mv	s1 t0
	
	zero_check:
	bgez	s1, loop		# if count less than zero, change to zero
	li	s1 0
	
	loop:
		lb	t1 (s0)
		sb	t1 (t6)			# copy symbol from first string to second
		addi	s0, s0, 1			# move positions in string and make number of characters to copy less
		addi	s1, s1, -1
		addi	t6, t6, 1
		beqz	s1, filler
		bnez 	t1, loop
	filler:
		blez	s1, endcpy
		li	t1, 0
		sb	t1 (t6)			# fill whats left with 0 characters
					# move positions in string and make number of characters to fill less
		addi	s1, s1, -1
		addi	t6 t6 1
		b	filler

	endcpy:
	
	pop(a0)
	pop(s1)
	pop(s0)
	pop(ra)
	ret
	
