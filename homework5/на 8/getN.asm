.include "macrolib.s"

.global getN
.taxt

getN:			# Получает количество элементов для массива, если введено неверное число возвращает в a0 0, иначе введенное число.
	push(ra)
	print_str ("how many elements are you going to summ?")
	read_int_a0
	mv      t3 a0           
        ble     t3 zero fail    # Íà îøèáêó, åñëè ìåíüøå 0
        li      t4 10           # Ìàêñèìàëüíûé ðàçìåð ìàññèâà
        bgt     t3 t4 fail      # Íà îøèáêó, åñëè áîëüøå 10
        mv	t3, a0
        pop(ra)
        ret
        
        
        fail:
        print_str("incorrect n!\n")
        li	a0 0
        pop(ra)
        ret
