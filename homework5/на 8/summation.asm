.include "macrolib.s"

.global summArray
.text

summArray:			# Аргументы: a0 - количество элементов, a1 - адрес массива.
	push(ra)
	mv	t3 a0		# Число элементов массива
        mv	t0, a1	
        li	t6 0 		#сумма
        li	t5 0		# разница между суммой и границей
        li	t4 0		# счетчик просуммированных значений
        li	t2 0		# счетчик четных элементов
        push(s1)
        push(s2)
        li	s1 2147483647   # максимальное положительное
        li	s2 -2147483648   # минимальное отрицательное
	summ_proces:
	
		lw	t1 (t0)		# загружаем текущий элемент массива
		bltz	t6, neg_sum_check	# если сумма отрицательная отправляем в другую секцию
		sub	t5, s1, t6
	
		blt	t1, t5, end_check	# если элемент меньше или равен разнице до макс числа выходим из проверок
		beq	t1, t5, end_check
		jal over_message
		
		neg_sum_check:
		sub	t5, s2, t6
		bge 	t1, t5, end_check	# если элемент меньше или равен разнице до макс числа выходим из проверок
		
		over_message:
		print_str ("overflow occured!\n")
	        print_str ("last correct summ: ")
	        jal	end		 
	        
		end_check:
		
		add	t6, t6, t1		# суммируем и считаем сколько удалось просуммировать
		addi	t4, t4, 1
		addi    t0 t0 4         
	        addi    t3 t3 -1        
	        bnez    t3 summ_proces 
	
	print_str("Summ: ")
	end:
	print_int(t6)
	print_str("\nNumber os elements summed: ")
	print_int(t4)
	pop(s2)
	pop(s1)
	pop(ra)
	ret
	
