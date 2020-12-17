.text
.globl pstrlen
    .type pstrlen,@function 
pstrlen:
    # setup code
    pushq %rbp
    movq %rsp,%rbp

    movzbl (%rdi) , %rax # put first char in the pstring in %rax
    leave
    ret
.globl replaceChar
    .type replaceChar,@function
replaceChar:
    # setup code
    pushq %rbp
    movq %rsp,%rbp
    pushq %r12
    pushq %r13
    # setup pstrlen
    movq %rdi , %r12 # save pstring.
    movq $0 , %rax # reset %rax.
    call pstrlen
    movq %rax , %r13 # save the length of the pstring.
    incq %r13 # r13 = lengthOf pstring+1
    movq $1 , %rcx # set the counter to 1 when the string begin.
    # change the string.
    .makeLoop:
        addq $1 , %rdi # continue in the string
        movzbq (%rdi)  , %r8 # move the current char to r8
        cmpq %r8 , %rsi # see if the current char is equal to older char
        je .changeChar # if the current char equal to the older char then replace.
        incq %rcx # i++.
        cmpq %r13 , %rcx # check if the current char is the last one.
        jl .makeLoop # if the current char isnt the last char in string then continue in loop
        jmp .finish # else done.
    # setup leave
    .finish:
        movq %r12 , %rax # put the answer in rax
        popq %r13
        popq %r12
        leave
        ret
   .changeChar:
        movb %dl, (%rdi) # replace the char in the newchar.
        incq %rcx # i++.
        cmpq %r13 , %rcx # check if the current char is the last one.
        jl .makeLoop # if the current char isnt the last char in string then continue in loop
        jmp .finish # else done.

.globl pstrijcpy
    .type pstrijcpy,@function
pstrijcpy:
    # setup code
    pushq %rbp
    movq %rsp,%rbp
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    # save the pointer to the dst.
    movq %rdi , %r14 

    # save i and j in the right format in r12 , r13
    movq %rdx , %r12 # put i in r12.
    subq $48 , %r12 # fit the format to ascii.
    movq %rcx , %r13 # put j in r13.
    subq $48 , %r13 # fit the format to ascii.

    # setup the strings before copy.
    addq %r12 , %rsi # put the 2 pstrings in the i place.
    addq %r12 , %rdi
    
    movq $-1 , %r15 # r15 will be the counter.
    # copy src[i-j] to dst.
    .iToj:
        addq $1 , %rsi # increment the position. 
        addq $1 , %rdi
        movzbq (%rsi)  , %rcx # move the current char to rcx.
        movb %cl, (%rdi) # replace the char in the newchar.
        incq %r15 # i++.
        cmpq %r13 , %r15 # check if the current char is the last one.
        jl .iToj # if the current char isnt the last char in string then continue in loop
        jmp .pstrijcpy_finish # else done.

    # setup leave
    .pstrijcpy_finish:
        popq %r15
        movq %r14 , %rax # set pointer to dst.
        popq %r14
        popq %r13
        popq %r12
        leave
        ret


