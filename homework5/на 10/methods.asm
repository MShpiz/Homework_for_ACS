.include "macrolib.s"

.macro getN 
	print_str ("how many elements are you going to summ?")
	read_int_a0
	mv      t3 a0           
        ble     t3 zero fail    # �� ������, ���� ������ 0
        li      t4 10           # ������������ ������ �������
        bgt     t3 t4 fail      # �� ������, ���� ������ 10
        mv	t3, a0
        b end

        fail:
        print_str("incorrect n!\n")
        li	a0 0
        end:
.end_macro 

.macro fillArray %x, %y
loop:
		print_str ("enter number: ")
		read_int_a0
		sw      a0 (%x)         # ������ ����� �� ������ � t0
	        addi    %x %x 4         # �������� ����� �� ������ ����� � ������
	        addi    %y %y -1        # �������� ���������� ���������� ��������� �� 1
	        bnez    %y loop  
.end_macro

.macro summArray %x, %y
	push(%x)
	push(%y)
	pop(t3)
	pop(t0)
	li	t6 0 		#�����
        li	t5 0		# ������� ����� ������ � ��������
        li	t4 0		# ������� ���������������� ��������
        li	t2 0		# ������� ������ ���������
        push(s1)
        push(s2)
        li	s1 2147483647   # ������������ �������������
        li	s2 -2147483648   # ����������� �������������
	summ_proces:
	
		lw	t1 (t0)		# ��������� ������� ������� �������
		bltz	t6, neg_sum_check	# ���� ����� ������������� ���������� � ������ ������
		sub	t5, s1, t6
	
		blt	t1, t5, end_check	# ���� ������� ������ ��� ����� ������� �� ���� ����� ������� �� ��������
		beq	t1, t5, end_check
		jal over_message
		
		neg_sum_check:
		sub	t5, s2, t6
		bge 	t1, t5, end_check	# ���� ������� ������ ��� ����� ������� �� ���� ����� ������� �� ��������
		
		over_message:
		print_str ("overflow occured!\n")
	        print_str ("last correct summ: ")
	        jal	end		 
	        
		end_check:
		
		add	t6, t6, t1		# ��������� � ������� ������� ������� ��������������
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