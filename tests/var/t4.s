	.globl main
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $10, %rcx
    movq $22, %rax
    addq %rcx, %rax
    movq %rax, %rdx
    movq $1, %rsi
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rsi, %rax
    movq %rax, %rcx
    movq $-1, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    addq $0, %rsp
    popq %rbp
    retq 

