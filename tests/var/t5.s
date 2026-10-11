	.align 16
start:
    movq $12, %rcx
    movq $4, %rsi
    movq %rcx, %rdx
    negq %rdx
    movq %rdx, %rax
    addq %rsi, %rax
    movq %rax, %r8
    movq %rcx, %rax
    subq %rsi, %rax
    movq %rax, %r9
    movq %r8, %rdx
    negq %rdx
    movq %rdx, %rax
    addq %r9, %rax
    movq %rax, %rdi
    movq %rsi, %rdx
    negq %rdx
    movq %rdi, %rax
    subq %rdx, %rax
    movq %rax, %rdi
    movq %rdi, %rax
    addq %rcx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    subq %rsi, %rax
    movq %rax, %r10
    movq %r9, %rdx
    negq %rdx
    movq %r10, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    negq %rcx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rsi, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    subq %r8, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %r9, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    subq %rdi, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

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
    jmp start

	.align 16
conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 


