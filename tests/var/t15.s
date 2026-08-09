	.globl main
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $3, %rcx
    movq $9, %r8
    movq %rcx, %rax
    addq %r8, %rax
    movq %rax, %rdi
    movq $14, %rax
    addq %rdi, %rax
    movq %rax, %rsi
    movq %rsi, %rdx
    negq %rdx
    movq %rdx, %rax
    addq %rdi, %rax
    movq %rax, %rdi
    movq %rdi, %rax
    subq %r8, %rax
    movq %rax, %r8
    negq %r8
    movq %r8, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rdi, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    subq %rdx, %rax
    movq %rax, %rdx
    negq %rdx
    movq $40, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    subq %rsi, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    negq %rcx
    movq $6, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    addq $0, %rsp
    popq %rbp
    retq 

