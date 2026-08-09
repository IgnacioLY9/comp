	.globl main
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $12, %rcx
    movq $4, %rsi
    movq %rcx, %rdx
    negq %rdx
    movq %rdx, %rax
    addq %rsi, %rax
    movq %rax, %r9
    movq %rcx, %rax
    subq %rsi, %rax
    movq %rax, %rdi
    movq %r9, %rdx
    negq %rdx
    movq %rdx, %rax
    addq %rdi, %rax
    movq %rax, %r8
    movq %rsi, %rdx
    negq %rdx
    movq %r8, %rax
    subq %rdx, %rax
    movq %rax, %r8
    movq %r8, %rax
    addq %rcx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    subq %rsi, %rax
    movq %rax, %r10
    movq %rdi, %rdx
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
    subq %r9, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rdi, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    subq %r8, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    addq $0, %rsp
    popq %rbp
    retq 

