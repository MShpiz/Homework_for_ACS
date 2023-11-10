.include "macrolib.s"

.eqv     BUF_SIZE 102		# buffer size for strings 100 characters long 
    .data
buf:    .space BUF_SIZE     # buffer string for input
copy:	.space BUF_SIZE
empty_test_str: .asciz ""   # empty string
short_test_str: .asciz "Hello world!"     # short string 
long_test_str:  .asciz "This is a very loooooooooooong string, which is supposed to be longer than one hundred and one characters." # long string

.text

.globl main
main:
    print_str("Enter string for copying: ")
    # getting string
    la      a0 buf
    li      a1 BUF_SIZE
    li      a7 8
    ecall
    
    # getting lenght of copy
    print_str("Enter lenght of copy ")
    read_int(t0)
    
    # copying string to copy
    la      a0 copy
    la      a1 buf 
    mv	    a2 t0
    jal     strncpy
    print_str_r(a0)
    newline
    
    # other tests
    # copying string to copy
    la      a0 copy
    la      a1 empty_test_str
    li	    a2 5
    jal     strncpy
    print_str_r(a0)
    newline
    
    la      a0 copy
    la      a1 short_test_str 
    li	    a2 0
    jal     strncpy
    print_str_r(a0)
    newline
    
    la      a0 copy
    la      a1 short_test_str 
    li	    a2 20
    jal     strncpy
    print_str_r(a0)
    newline
    
    la      a0 copy
    la      a1 empty_test_str
    li	    a2 50
    jal     strncpy
    print_str_r(a0)
    newline
    
    la      a0 copy
    la      a1 short_test_str 
    li	    a2 5
    jal     strncpy
    print_str_r(a0)
    newline
    
    la      a0 copy
    la      a1 empty_test_str
    li	    a2 5
    jal     strncpy
    print_str_r(a0)
    newline
    
    la      a0 copy
    la      a1 long_test_str 
    li	    a2 50
    jal     strncpy
    print_str_r(a0)
    newline
    
    la      a0 copy
    la      a1 long_test_str 
    li	    a2 110
    jal     strncpy
    print_str_r(a0)
    newline

    exit