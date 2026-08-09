	.globl main
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $1, %rcx
    movq $42, %rdx
    movq $7, %rax
    addq %rcx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    negq %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    addq $0, %rsp
    popq %rbp
    retq 

