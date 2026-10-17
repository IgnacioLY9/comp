	.align 16
main_start:
    movq $50, %rcx
    movq $13, %rdi
    movq %rcx, %rax
    subq %rdi, %rax
    movq %rax, %rsi
    movq %rsi, %rdx
    negq %rdx
    movq $17, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    addq %rdi, %rax
    movq %rax, %rdi
    movq %rdi, %rax
    subq %rcx, %rax
    movq %rax, %rcx
    negq %rcx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq $-9, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    addq %rsi, %rax
    movq %rax, %rdx
    negq %rdx
    movq $25, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    subq %rdi, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq $-4, %rax
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


