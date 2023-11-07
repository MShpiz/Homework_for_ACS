.include "macrolib.s"
global strncpy

strncpy:
	push(ra)
	push(s0)
	push(s1)
	push(a0)
	mv	t6 a0
	mv	s0 a1
	mv	s1 s2
	
	loop:
		lb	t1 (s0)
		sb	t1 (t6)			# copy symbol from first string to second
		addi	t0 1			# move positions in string and make number of characters to copy less
		addi	s0, 1
		addi	s1, -1
		bne 	t1, 10, loop
		bnez	s1, loop
	
	
	pop(a0)
	pop(s1)
	pop(s0)
	pop(ra)
	ret
	
	
strnlen:
    li      t0 0        # Счетчик
loop:
    lb      t1 (a0)   # Загрузка символа для сравнения
    beqz    t1 end
    addi    t0 t0 1		# Счетчик символов увеличивается на 1
    addi    a0 a0 1		# Берется следующий символ
    bge     t0 a1 fatal # Выход, по превышению размера буфера
    b       loop
end:
    mv      a0 t0
    ret
fatal:
    li      a0 -1
    ret
