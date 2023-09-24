.data
sep:    .asciz  "--------\n"    # Строка-разделитель (с \n и нулём в конце)
prompt: .asciz  "how many elements are you going to summ? "         # Подсказка для ввода числа
error:  .asciz  "incorrect n!\n"  # Сообщение о некорректном вводе
overflow_error:  .asciz  "number overflow occured!\n"  # Сообщение о некорректном вводе
correct_sum:	.asciz 	"sum: "
last:	.asciz 	"last "
element_count:	.asciz 	"elements summed: "
even_elements:	.asciz	"number of even elements: "
odd_elements:	.asciz	"number of odd elements: "
ln:	.asciz 	"\n"
.align  2                       # Выравнивание на границу слова
n:	.word	0		# Число введенных элементов массива
array:  .space  40              # 64 байта
.text
in:
        la 	a0, prompt      # Подсказка для ввода числа элементов массива
        li 	a7, 4           
        ecall
        
        li      a7 5            # Системный вызов №5 — ввести десятичное число
        ecall
        mv      t3 a0           # Сохраняем результат в t3 (это n)
        ble     t3 zero fail    # На ошибку, если меньше 0
        
        li      t4 10           # Максимальный размер массива
        bgt     t3 t4 fail      # На ошибку, если больше 10
        
        la	t4 n		# Адрес n в t4
        sw	t3 (t4)		# Загрузка n в память на хранение
        
        la      t0 array        # Указатель элемента массива
        li      t2 1            # Число, которое мы будем записывать в массив
        
fill:
	li      a7 5            # Считываем число для сожения 
        ecall
        mv      t2 a0
	sw      t2 (t0)         # Запись числа по адресу в t0
        addi    t0 t0 4         # Увеличим адрес на размер слова в байтах
        addi    t3 t3 -1        # Уменьшим количество оставшихся элементов на 1
        bnez    t3 fill      
        
        
        la      a0 sep          # Выведем строку-разделитель
        li      a7 4
        ecall

        lw	t3 n		# Число элементов массива
        la      t0 array
        li	t6 0 		#сумма
        li	t5 0		# разница между суммой и границей
        li	t4 0		# счетчик просуммированных значений
        li	t2 0		# счетчик четных элементов
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
	la 	a0, overflow_error       # выводим сообщение об ошибке и выходим из цикла
        li 	a7, 4           
        ecall
        la 	a0, last       
        li 	a7, 4           
        ecall
        jal	even_count_process		# я не хочу делать спагетти-монстра из этого цикла поэтому четные числа считаем в отдельном цикле 
        
	end_check:
	
	add	t6, t6, t1		# суммируем и считаем сколько удалось просуммировать
	addi	t4, t4, 1
	addi    t0 t0 4         
        addi    t3 t3 -1        
        bnez    t3 summ_proces 

        lw	t3 n  
        la      t0 array
even_count_process:		# цикл подсчета четных чисел
	lw	t1 (t0)
	li	t5, 2
	rem	t5, t1, t5		# в условии ничего не говорилось про то, что нельзя использовать команду взятия остатка от деления
	bnez 	t5, cont
	addi	t2, t2, 1
	
	cont:
	addi    t0 t0 4         
        addi    t3 t3 -1        
        bnez    t3 even_count_process 	 

        lw	t3 n       
end:
	la 	a0, correct_sum       	# вывод всех данных
        li 	a7, 4           
        ecall
        mv	a0, t6
        li	a7, 1
        ecall
        la 	a0, ln       
        li 	a7, 4           
        ecall
        
        la 	a0, element_count       
        li 	a7, 4           
        ecall
        mv	a0, t4
        li	a7, 1
        ecall
        la 	a0, ln       
        li 	a7, 4           
        ecall
        
        la 	a0, even_elements       
        li 	a7, 4           
        ecall
        mv	a0, t2
        li	a7, 1
        ecall
        la 	a0, ln       
        li 	a7, 4           
        ecall
        
        la 	a0, odd_elements       
        li 	a7, 4           
        ecall
        sub	t2, t3, t2
        mv	a0, t2
        li	a7, 1
        ecall
        la 	a0, ln       
        li 	a7, 4           
        ecall
       
        li      a7 10           # Останов
        ecall
        
fail:
        la 	a0, error       # Сообщение об ошибке ввода числа элементов массива
        li 	a7, 4           # Системный вызов №4
        ecall
        li      a7 10           # Останов
        ecall
