# Печать содержимого регистра как целого
.macro print_int (%x)
	li a7, 1
	mv a0, %x
	ecall
.end_macro

.macro print_imm_int (%x)
   li a7, 1
   li a0, %x
   ecall
.end_macro

# Ввод целого числа с консоли в регистр a0
.macro read_int_a0
   li a7, 5
   ecall
.end_macro

# Ввод целого числа с консоли в указанный регистр,
# исключая регистр a0
.macro read_int(%x)
   push	(a0)
   li a7, 5
   ecall
   mv %x, a0
   pop	(a0)
.end_macro

.macro print_str (%x)
   .data
str:
   .asciz %x
   .text
   push (a0)
   li a7, 4
   la a0, str
   ecall
   pop	(a0)
   .end_macro

.macro print_str_r (%x)
   .text
   push (a0)
   li a7, 4
   mv a0, %x
   ecall
   pop	(a0)
   .end_macro
   
   .macro print_char(%x)
   li a7, 11
   li a0, %x
   ecall
   .end_macro

   .macro newline
   print_char('\n')
   .end_macro

# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro

# Сохранение заданного регистра на стеке
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

#__________________________________________________

# prints double passed through %x register
.macro print_double (%x)
	li a7, 3
	fmv.d fa0, %x
	ecall
.end_macro

#prints double passed as an immedeate
.macro print_imm_double (%x)
   li a7, 3
   li fa0, %x
   ecall
.end_macro

# reads a double to a0
.macro read_double_a0
   li a7, 7
   ecall
.end_macro

# reads a double to %x register
.macro read_double(%x)
   fpush	(fa0)
   li a7, 7
   ecall
   fmv.d %x, fa0
   fpop		(fa0)
.end_macro

# pushes a double to stack
.macro fpush(%x)
	addi	sp, sp, -8
	fsd	%x, (sp)
.end_macro

# gets a double  from stack
.macro fpop(%x)
	fld	%x, (sp)
	addi	sp, sp, 8
.end_macro

.macro	strncpy (%cpy, %str, %cnt)
	push(s0)
	push(s1)
	push(s2)
	push(%cpy)
	mv	s2 %cpy			# copy buf
	mv	s0 %str			#string
	mv	s1 %cnt			# count
	
	li t0 102
	ble	s1 t0 zero_check		# if count is bigger than buffer size, change to buffer size
	mv	s1 t0
	
	zero_check:
	blez	s1, endcpy		# if count less than zero, finish copy

	
	loop:
		lb	t1 (s0)
		sb	t1 (s2)			# copy symbol from first string to second
		addi	s0, s0, 1			# move positions in string and make number of characters to copy less
		addi	s1, s1, -1
		addi	s2, s2, 1
		beqz	s1, filler
		bnez 	t1, loop
	filler:
		blez	s1, endcpy
		li	t1, 0
		sb	t1 (t6)			# fill whats left with 0 characters
					# move positions in string and make number of characters to fill less
		addi	s1, s1, -1
		addi	s2 s2 1
		b	filler

	endcpy:
	
	pop(a0)
	pop(s2)
	pop(s1)
	pop(s0)
.end_macro
