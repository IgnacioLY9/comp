	.globl main
main:
    pushq %rbx
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp
    callq read_int
    movq %rax, %rbx
    callq read_int
    movq %rax, %rcx
    movq %rbx, %rax
    subq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    addq $8, %rsp
    popq %rbp
    popq %rbx
    retq 

