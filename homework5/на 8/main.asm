.include "macrolib.s"

.global main
.data
n:	.word 0
array:  .space  40              
arrayend:

.text
main:
	jal getN 
	beqz	a0, end
	la	t0, n
	sw	a0, (t0)
	la	a1, array
	jal fillArray
	lw	a0 n
	la	a1, array
	jal summArray
	end:
	exit
