.include "macrolib.s"

.macro getN 		# Получает количество элементов для массива, если введено неверное число возвращает в a0 0, иначе введенное число.
	print_str ("how many elements are you going to summ?")
	read_int_a0
	mv      t3 a0           
        ble     t3 zero fail    # На ошибку, если меньше 0
        li      t4 10           # Максимальный размер массива
        bgt     t3 t4 fail      # На ошибку, если больше 10
        mv	t3, a0
        b end

        fail:
        print_str("incorrect n!\n")
        li	a0 0
        end:
.end_macro 

.macro fillArray %x, %y			#  x - количество элементов, y - адрес массива
loop:
		print_str ("enter number: ")
		read_int_a0
		sw      a0 (%x)         # Запись числа по адресу в t0
	        addi    %x %x 4         # Увеличим адрес на размер слова в байтах
	        addi    %y %y -1        # Уменьшим количество оставшихся элементов на 1
	        bnez    %y loop  
.end_macro

.macro summArray %x, %y		#  x - количество элементов, y - адрес массива
	push(%x)	# тк не известно какие именно регистры переданы, закидываем значения в стек и извлекаем их в необходимые регистры
	push(%y)
	pop(t3)
	pop(t0)
	li	t6 0 		#сумма
        li	t5 0		# разница между суммой и границей
        li	t4 0		# счетчик просуммированных значений
        li	t2 0		# счетчик четных элементов
        push(s1)	# про s регистры тоже не многое известно, поэтому сохраним их
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
.end_macro
