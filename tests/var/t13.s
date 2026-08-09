	.globl main
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $12, %rcx
    movq $7, %r8
    movq %rcx, %rax
    addq %r8, %rax
    movq %rax, %rdi
    movq $-5, %rax
    addq %rdi, %rax
    movq %rax, %rdx
    movq %rdx, %rsi
    negq %rsi
    movq $20, %rax
    addq %rsi, %rax
    movq %rax, %rsi
    movq %rsi, %rax
    subq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %r8, %rax
    movq %rax, %rcx
    negq %rcx
    movq %rcx, %rax
    addq %rdi, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    subq %rsi, %rax
    movq %rax, %rsi
    movq %rsi, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    negq %rdx
    movq $100, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    subq %rcx, %rax
    movq %rax, %rcx
    movq $8, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    addq $0, %rsp
    popq %rbp
    retq 

