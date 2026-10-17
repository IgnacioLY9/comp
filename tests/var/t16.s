	.align 16
main_start:
    movq $100, %rcx
    movq $35, %r8
    movq %rcx, %rax
    subq %r8, %rax
    movq %rax, %rsi
    movq %rsi, %rdx
    negq %rdx
    movq $60, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq $-15, %rax
    addq %rdx, %rax
    movq %rax, %rdi
    movq %rdi, %rax
    addq %r8, %rax
    movq %rax, %r8
    negq %r8
    movq %r8, %rax
    addq %rsi, %rax
    movq %rax, %rsi
    movq %rsi, %rax
    subq %rdx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    addq %rdi, %rax
    movq %rax, %rdx
    negq %rdx
    movq $75, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    subq %rsi, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    addq %r8, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    subq %rcx, %rax
    movq %rax, %rcx
    negq %rcx
    movq $200, %rax
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


