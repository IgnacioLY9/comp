	.align 16
block.920:
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.921:
    movq %rcx, %rdi
    callq print_int
    jmp block.920

	.align 16
block.922:
    movq $2, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.921

	.align 16
block.923:
    movq $10, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.921

	.align 16
block.924:
    cmpq $0, %rsi
    je block.922
    jmp block.923

	.align 16
block.926:
    movq %rcx, %rdi
    callq print_int
    jmp block.920

	.align 16
block.927:
    movq $3, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.926

	.align 16
block.928:
    movq $12, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.926

	.align 16
block.929:
    cmpq $0, %rsi
    je block.927
    jmp block.928

	.align 16
block.931:
    cmpq $1, %rsi
    jl block.924
    cmpq $2, %rsi
    je block.922
    jmp block.923

	.align 16
main_start:
    movq $0, %rcx
    movq $1, %rsi
    movq $1, %rdx
    cmpq $1, %rcx
    je block.931
    cmpq $1, %rsi
    jl block.929
    cmpq $2, %rsi
    je block.927
    jmp block.928

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


