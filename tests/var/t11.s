	.globl main
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $1, %rcx
    movq $2, %rax
    addq %rcx, %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    addq $0, %rsp
    popq %rbp
    retq 

