.include "methods.asm"

.global main
.data
n:	.word 0
array:  .space  40              
arrayend:

.text
main:
	getN 
	beqz	a0, end
	la	t0, n
	sw	a0, (t0)
	mv	t0, a0
	la	t1, array
	fillArray (t1, t0)
	lw	t0 n
	la	t1 array
	summArray(t1, t0)
	end:
	li	a7, 10
	ecall
