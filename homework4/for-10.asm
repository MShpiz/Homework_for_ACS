# вычисление максимальног аргумента факториала
# Вызывающая программа
        jal     fact_max           
        li      a7 1		
        ecall                  
        li      a7 10
        ecall
# Подпрограмма вычисления факториала
fact_max:   
	li	t2, 2 # текущий аргумент
	li	t3, 1 # прошлое значение факториала
	for:
		mv	a0, t2
		jal fact 	# ищем факториал от нового аргумента
		bltu   	a0, t3, end_for 	# если произошло переполнение следующее значение будет меньше чем текущее
		mv	t3, a0
		addi	t1, t1, 1
		b	for
	
	end_for:
	addi	a0, t1, -1
        ret
        

fact:   addi    sp sp -4
        sw      ra (sp)         # Сохраняем ra
        mv      t1 a0           # Запоминаем N в t1
        addi    a0 t1 -1        # Формируем n-1 в a0
        li      t0 1
        ble     a0 t0 done      # Если n<2, готово
        addi    sp sp -4        ## Сохраняем t1 на стеке
        sw      t1 (sp)         ##
        jal     fact            # Посчитаем (n-1)!
        lw      t1 (sp)         ## Вспоминаем t1
        addi    sp sp 4         ##
        mul     t1 t1 a0        # Домножаем на (n-1)!
done:   mv      a0 t1           # Возвращаемое значение
        lw      ra (sp)         # Восстанавливаем ra
        addi    sp sp 4         # Восстанавливаем вершину стека
        ret
