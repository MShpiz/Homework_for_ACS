.include "macrolib.s"

.global getN
.taxt

getN:
	push(ra)
	print_str ("how many elements are you going to summ?")
	read_int_a0
	mv      t3 a0           
        ble     t3 zero fail    # �� ������, ���� ������ 0
        li      t4 10           # ������������ ������ �������
        bgt     t3 t4 fail      # �� ������, ���� ������ 10
        mv	t3, a0
        pop(ra)
        ret
        
        
        fail:
        print_str("incorrect n!\n")
        li	a0 0
        pop(ra)
        ret
