.include "macro-syscalls.m"
.text
        lui     t6 0xffff0          # база MMIO (старшие адреса)
        mv      t5 zero             # счётчик
        mv      t4 zero             # предыдущее значение
        li      t2 20               # Число нажатий до завершения программы
loop:
        mv      t1 zero             # общий результат сканирования
        li      t0 1                # первый ряд
        sb      t0 0x12(t6)         # сканируем
        lb      t0 0x14(t6)         # забираем результат
        or      t1 t1 t0            # добавляем биты в общий результат
        li      t0 2                # второй ряд
        sb      t0 0x12(t6)
        lb      t0 0x14(t6)
        or      t1 t1 t0
        li      t0 4                # третий ряд
        sb      t0 0x12(t6)
        lb      t0 0x14(t6)
        or      t1 t1 t0
        li      t0 8                # четвёртый ряд
        sb      t0 0x12(t6)
        lb      t0 0x14(t6)
        or      t1 t1 t0
        beq     t1 t4 same
        print_int_dec(t5)           # Номер срабатывания
        print_str(": ")
        print_int_bin(t1)           # выведем результат как двоичное
        print_str(" == ")
        print_int_hex(t1)           # Заодно и как шестнадцатиричное
        #mv      a0 t1              # выведем результат как двоичное
        #li      a7 35
        #ecall
        newline
        #li      a0 10
        #li      a7 11
        #ecall
        mv a0 t5
        jal get_digit
        sb      a0 0x10(t6)         # запишем его в другое окошко
        mv      t4 t1
same:   ble     t5 t2 loop

        print_str("20 keystrokes completed\n")

        exit


get_digit:
push(ra)
li	t0 16
li	t1 0
ble	a0 t0 after_dot
li	t1	1 # mark need of dot
rem	a0 a0 t0	# needed digit
after_dot:
nul:			# assign display code for the digit
li	t0 0
bne	a0 t0 one
li	t2 0x3f
j after_number
one:
li	t0 1
bne	a0 t0 two
li	t2 0x6
j after_number
two:
li	t0 2
bne	a0 t0 three
li	t2 0x5b
j after_number
three:
li	t0 3
bne	a0 t0 four
li	t2 0x4f
j after_number
four:
li	t0 4
bne	a0 t0 five
li	t2 0x66
j after_number
five:
li	t0 5
bne	a0 t0 six
li	t2 0x6d
j after_number
six:
li	t0 6
bne	a0 t0 seven
li	t2 0x7d
j after_number
seven:
li	t0 7
bne	a0 t0 eight
li	t2 0x7
j after_number
eight:
li	t0 8
bne	a0 t0 nine
li	t2 0x7f
j after_number
nine:
li	t0 9
bne	a0 t0 ten
li	t2 0x6f
j after_number
ten:
li	t0 10
bne	a0 t0 eleven
li	t2 0x77
j after_number
eleven:
li	t0 11
bne	a0 t0 twelve
li	t2 0x7c
j after_number
twelve:
li	t0 12
bne	a0 t0 thirteen
li	t2 0x39
j after_number
thirteen:
li	t0 13
bne	a0 t0 fourteen
li	t2 0x5e
j after_number
fourteen:
li	t0 14
bne	a0 t0 fifteen
li	t2 0x79
j after_number
fifteen:
li	t2 0x71
j after_number

after_number:			# if dot is needed add its code
beqz	t1, after_add_dot
addi	t2, t2 0x80

after_add_dot:
mv	a0 t2
pop(ra)
ret
