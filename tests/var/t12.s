	.globl main
main:
    pushq %r14
    pushq %r12
    pushq %r13
    pushq %rbx
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp
    movq $10, %rcx
    movq $1, %r13
    movq $1, %rsi
    movq $1, %rbx
    movq $1, %r8
    movq $1, -8(%rbp)
    movq $1, %r14
    movq $1, %rdi
    movq $1, %r9
    movq $1, %r12
    movq $1, %r10
    movq $1, %rdx
    movq %rcx, %rax
    addq %r13, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rsi, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rbx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %r8, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq -8(%rbp), %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %r14, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rdi, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %r9, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %r12, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %r10, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    addq $16, %rsp
    popq %rbp
    popq %rbx
    popq %r13
    popq %r12
    popq %r14
    retq 

