	.globl main
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $9223372036854775807, %rcx
    negq %rcx
    movq $-1, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    negq %rcx
    movq %rcx, %rdi
    callq print_int
    addq $0, %rsp
    popq %rbp
    retq 

