	.align 16
square_start:
    movq %rdi, %rcx
    movq %rcx, %rax
    imulq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    jmp square_conclusion

	.align 16
square:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp square_start

	.align 16
square_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
inc_start:
    movq %rdi, %rcx
    movq $1, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    jmp inc_conclusion

	.align 16
inc:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp inc_start

	.align 16
inc_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
block.51:
    movq %rdx, %rax
    jmp complicated_conclusion

	.align 16
complicated_start:
    movq %rdi, %rdx
    cmpq $10, %rdx
    jg block.51
    leaq complicated(%rip), %r12
    leaq inc(%rip), %rbx
    leaq square(%rip), %rcx
    movq %rdx, %rdi
    callq *%rcx
    movq %rax, %rcx
    movq %rcx, %rdi
    callq *%rbx
    movq %rax, %rcx
    movq %rcx, %rdi
    movq %r12, %rax
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    popq %rbx
    popq %r12
    jmp *%rax
    retq 

	.align 16
complicated:
    pushq %r12
    pushq %rbx
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp complicated_start

	.align 16
complicated_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    popq %rbx
    popq %r12
    retq 

	.align 16
main_start:
    leaq complicated(%rip), %rcx
    movq $1, %rdi
    callq *%rcx
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.globl main
	.align 16
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    jmp main_start

	.align 16
main_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 


