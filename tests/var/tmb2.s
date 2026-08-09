	.globl main
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $1, %rcx
    movq $42, %rdx
    movq $7, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    negq %rcx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    addq $0, %rsp
    popq %rbp
    retq 

