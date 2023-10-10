.global summArray
.text

summArray:
	push(ra)
	mv	t3 a1		# ����� ��������� �������
        mv	t0, a0	
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
		la 	a0, overflow_error       # ������� ��������� �� ������ � ������� �� �����
	        li 	a7, 4           
	        ecall
	        la 	a0, last       
	        li 	a7, 4           
	        ecall
	        jal	even_count_process		# � �� ���� ������ ��������-������� �� ����� ����� ������� ������ ����� ������� � ��������� ����� 
	        
		end_check:
		
		add	t6, t6, t1		# ��������� � ������� ������� ������� ��������������
		addi	t4, t4, 1
		addi    t0 t0 4         
	        addi    t3 t3 -1        
	        bnez    t3 summ_proces 

	pop(s2)
	pop(s1)
	pop(ra)
	