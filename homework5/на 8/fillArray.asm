.include "macrolib.s"

.global fillArray
.text
fillArray:
	push(ra)
	push(a0)
	push(a1)
	
	loop:
		print_str ("enter number: ")
		read_int_a0
		pop(t0)
		pop(t3)
		sw      a0 (t0)         # ������ ����� �� ������ � t0
	        addi    t0 t0 4         # �������� ����� �� ������ ����� � ������
	        addi    t3 t3 -1        # �������� ���������� ���������� ��������� �� 1
	        push(t3)
	        push(t0)
	        bnez    t3 loop  
	pop(t0)
	pop(t0)
	pop(ra)
	ret    
