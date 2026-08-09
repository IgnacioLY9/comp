	.globl main
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $-9223372036854775616, %rdi
    callq print_int
    addq $0, %rsp
    popq %rbp
    retq 

