.section .data
  format1:	.string	"first pstring length: %d, second pstring length: %d\n"
  format2:  .string "invalid option!\n"
  format_c: .string " %c"
  format_d: .string "%d"
  format_s: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
  # format for pstrijcpy
  format_pstrijcpy: .string "length: %d, string: %s\n"  
.align 8 # Align address to multiple of 16
.table:
.quad .L1 # Case 50: option1
.quad .D # Case 51: default
.quad .L2 # Case 52: option2
.quad .L3 # Case 53: option3
.quad .L4 # Case 54: option4
.quad .L5 # Case 55: option5
.quad .D # Case 56: default
.quad .D # Case 57: default
.quad .D # Case 58: default
.quad .D # Case 59: default
.quad .L1 # Case 60: option1 

    .text
.globl run_func
    .type run_func,@function 
run_func:
        pushq %rbp
        movq %rsp , %rbp
        # Set up the jump table access
        leaq -50(%rdi),%rcx # Compute xi = x-50
        cmpq $10,%rcx # Compare xi:10
        ja .D # if >, goto default-case
        jmp *.table(,%rcx,8) # Goto jt[xi]
        ########
        .L1:
            movq %rsi , %rdi # put pstring 1 to %rdi
            movq $0 , %rax
            call pstrlen 
            movq %rax , %rsi # put the size of the first string in %rsi
            movq $0 , %rax
            movq %rdx , %rdi # put the second pstring in %rdi
            call pstrlen
            movq %rax , %rdx # put the second size in %rdx
            movq $format1 , %rdi # put the string in %rdi
            movq $0 , %rax
            call printf
            leave
            ret 

        .L2:
            # setup frame
            pushq %rbp
            movq %rbp , %rsp
            pushq %r15
            pushq %r12
            pushq %r13
            pushq %r14
            movq %rsi , %r15 # %r15 save the first pstring
            movq %rdx , %r14 # %r14 save the second pstring
            subq $16 , %rsp # allocate memory in stack.
            # setup scanf
            movq $format_c , %rdi
            leaq 8(%rsp) , %rsi
            movq $0 , %rax
            call scanf
            movzbq 8(%rsp) , %r12 # save the first char in r12.
            # setup scanf
            movq $format_c , %rdi
            leaq 8(%rsp) , %rsi
            movq $0 , %rax
            call scanf
            movzbq 8(%rsp) , %r13 # save the first char in r13.
            # setup replaceChar
            movq %r15 , %rdi
            movq %r12 , %rsi
            movq %r13 , %rdx
            call replaceChar
            movq %rax , %r15 # save the new pstring1
            # setup replaceChar
            movq %r14 , %rdi
            movq %r12 , %rsi
            movq %r13 , %rdx
            call replaceChar
            movq %rax , %r14 # save the new pstring2
            # setup printf
            movq $format_s , %rdi
            movq %r12 , %rsi
            movq %r13 , %rdx
            movq %r15 , %rcx
            movq %r14 , %r8
            movq $0 , %rax
            call printf
            # setup exit
            popq %r14
            popq %r13
            popq %r12
            popq %r15
            leave
            ret

        .L3:
            # setup frame
            pushq %rbp
            movq %rbp , %rsp
            pushq %r15
            pushq %r12
            pushq %r13
            pushq %r14
            movq %rsi , %r15 # %r15 save the first pstring
            movq %rdx , %r14 # %r14 save the second pstring
            subq $16 , %rsp # allocate memory in stack.
            # setup scanf

            movq $format_c , %rdi
            leaq 8(%rsp) , %rsi
            movq $0 , %rax
            call scanf
            movzbq 8(%rsp) , %r12 # save i in r12.

            # setup scanf
            movq $format_c , %rdi
            leaq 8(%rsp) , %rsi
            movq $0 , %rax
            call scanf
            movzbq 8(%rsp) , %r13 # save the j in r13.
            # setup to pstrijcpy
            movq %r15 , %rdi
            movq %r14 , %rsi
            movq %r12 , %rdx
            movq %r13 , %rcx
            movq $0 , %rax
            call pstrijcpy
            movq %rax , %r15 # put the pstring1 in %r15.

            # get the size of first pstring
            movq %r15 , %rdi
            movq $0 , %rax
            call pstrlen
            movq %rax , %r13 # save the first string length in r8.

            # get the size of second pstring
            movq %r14 , %rdi
            movq $0 , %rax
            call pstrlen
            movq %rax , %r12 # save the first string length in r9.

            # set printf to print fist string.
            movq $format_pstrijcpy , %rdi
            movq %r13 , %rsi
            movq %r15 , %rdx
            movq $0 , %rax
            call printf
            # set printf to print second string.
            movq $format_pstrijcpy , %rdi
            movq %r12 , %rsi
            movq %r14 , %rdx
            movq $0 , %rax
            call printf
             # setup exit
            popq %r14
            popq %r13
            popq %r12
            popq %r15
            leave
            ret
        .L4:
        .L5:
        
        # when the val is not valid.
        .D:
            movq $format2 , %rdi
            movq $0 , %rax
            call printf
            leave
            ret