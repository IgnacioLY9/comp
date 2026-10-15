	.align 16
block.7:
    movq %rdi, %rax
    jmp tail_sum_conclusion

	.align 16
tail_sum_start:
    movq %rdi, %rdx
    movq %rsi, %rdi
    cmpq $0, %rdx
    je block.7
    leaq tail_sum(%rip), %rcx
    movq $-1, %rax
    addq %rdx, %rax
    movq %rax, %rsi
    movq %rdx, %rax
    addq %rdi, %rax
    movq %rax, %rdx
    movq %rsi, %rdi
    movq %rdx, %rsi
    callq *%rcx
    movq %rax, %rcx
    movq %rcx, %rax
    jmp tail_sum_conclusion

	.align 16
tail_sum:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp tail_sum_start

	.align 16
tail_sum_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
main_start:
    leaq tail_sum(%rip), %rcx
    movq $3, %rdi
    movq $0, %rsi
    callq *%rcx
    movq %rax, %rcx
    movq $36, %rax
    addq %rcx, %rax
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


