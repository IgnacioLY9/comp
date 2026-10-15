	.align 16
p_start:
    movq %rdi, %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp p_conclusion

	.align 16
p:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp p_start

	.align 16
p_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
main_start:
    movq $3, %rdx
    leaq p(%rip), %rcx
    movq %rdx, %rdi
    callq *%rcx
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


