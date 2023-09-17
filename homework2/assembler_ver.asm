.data
    arg01:  .asciz "Enter dividend: "
    arg02:  .asciz "Enter divisor: "
    quotient_txt: .asciz "quotient: "
    remainder_txt: .asciz " remainder: "
    ln:     .asciz "\n"
    error: .asciz "Error, division by zero"
.text
	la 	a0, arg01   # Подсказка для ввода первого числа
        li 	a7, 4       
        ecall
        li      a7 5        # ввести дделимое
        ecall   
        mv      t0 a0            

        la 	a0, arg02   # Подсказка для ввода второго числа
        li 	a7, 4       
        ecall
        li      a7 5        # ввести делитель
        ecall               
        mv      t1 a0    
        
        beq	t1, zero, badending # проверка деления на 0
        
        li	t2, 1 # дельта
        li	t3, 0 # отрицательный остаток или нет
        li 	t4, 0 # частное
        
        # если делимое >= 0 пропускаем смену знака делимого и дельты и флага об отрицательном остатке
        bge	t0, zero, endfirstcomp 
        sub	t0, zero, t0
        sub	t2, zero, t2
        addi	t3, t3, 1
              
        endfirstcomp:    # конец первого условия
        # если делитель >= 0 пропускаем смену знака делителя и дельты
        bge	t1, zero, endsecondcomp 
        sub	t1, zero, t1
        sub	t2, zero, t2    
        
        endsecondcomp:  # конец второго условия
        
        blt 	t0, t1, endloop # если делимое меньше делителя пропускаем цикл
        
        loop: # цикл деления
       	sub 	t0, t0, t1 # вычитаем делитель из делимого
       	add	t4, t4, t2 # прибавляем дельту к частному
       	bge	t0, t1, loop # пока делимое больше или равно делителю делим
       
       endloop: # конец цикла
	
	beq 	t3, zero, printresult # если остаток должен быть неотрицательным переходим к печати результата
	sub 	t0, zero, t0 # меняем знак остатка
	
	printresult:   
	    
	la a0, quotient_txt       # Подсказка для выводимого результата
        li a7, 4            
        ecall
        
        mv     a0 t4   # переносим значение частного
        li      a7 1        # выводим частное
        ecall
        
        la a0, remainder_txt       # Подсказка для выводимого результата
        li a7, 4            
        ecall
        
        mv     a0 t0    # переносим значение остатка
        li      a7 1        # выводим остаток
        ecall
        
        la a0, ln       # перевод строки
        li a7, 4            
        ecall

        li	a7, 10 # окончание программы
        ecall         
                         
        badending:    
        la 	a0, error   # Подсказка для ввода первого числа
        li 	a7, 4       
        ecall
        li	a7, 10 # окончание программы
        ecall
