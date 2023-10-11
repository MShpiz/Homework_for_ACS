.include "macrolib.s"

.global fillArray
.text
fillArray:		# Аргументы: a0 - количество элементов, a1 - адрес массива.
	push(ra)
	push(a0)
	push(a1)
	
	loop:
		print_str ("enter number: ")
		read_int_a0
		pop(t0)
		pop(t3)
		sw      a0 (t0)         # Çàïèñü ÷èñëà ïî àäðåñó â t0
	        addi    t0 t0 4         # Óâåëè÷èì àäðåñ íà ðàçìåð ñëîâà â áàéòàõ
	        addi    t3 t3 -1        # Óìåíüøèì êîëè÷åñòâî îñòàâøèõñÿ ýëåìåíòîâ íà 1
	        push(t3)
	        push(t0)
	        bnez    t3 loop  
	pop(t0)
	pop(t0)
	pop(ra)
	ret    
