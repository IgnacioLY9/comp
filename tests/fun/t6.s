	.align 16
add_start:
    movq %rdi, %rcx
    movq %rsi, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    jmp add_conclusion

	.align 16
add:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp add_start

	.align 16
add_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
mult_start:
    movq %rdi, %rcx
    movq %rsi, %rdx
    movq %rcx, %rax
    imulq %rdx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    jmp mult_conclusion

	.align 16
mult:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp mult_start

	.align 16
mult_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
block.91:
    leaq add(%rip), %rcx
    movq %rcx, %rax
    jmp chooseAdd_conclusion

	.align 16
chooseAdd_start:
    movq %rdi, %rcx
    cmpq $1, %rcx
    je block.91
    leaq mult(%rip), %rcx
    movq %rcx, %rax
    jmp chooseAdd_conclusion

	.align 16
chooseAdd:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp chooseAdd_start

	.align 16
chooseAdd_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
main_start:
    movq $1, %rbx
    movq $1, %r12
    movq $1, %rdx
    leaq chooseAdd(%rip), %rcx
    movq %rdx, %rdi
    callq *%rcx
    movq %rax, %rcx
    movq %rbx, %rdi
    movq %r12, %rsi
    callq *%rcx
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rdx
    leaq chooseAdd(%rip), %rcx
    movq %rdx, %rdi
    callq *%rcx
    movq %rax, %rcx
    movq %rbx, %rdi
    movq %r12, %rsi
    callq *%rcx
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.globl main
	.align 16
main:
    pushq %rbx
    pushq %r12
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
    popq %r12
    popq %rbx
    retq 


