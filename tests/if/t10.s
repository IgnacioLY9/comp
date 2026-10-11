	.align 16
block.575:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.576:
    movq $2, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.575

	.align 16
block.577:
    movq $10, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.575

	.align 16
block.578:
    cmpq $0, %rbx
    je block.576
    jmp block.577

	.align 16
start:
    callq read_int
    movq %rax, %rbx
    callq read_int
    movq %rax, %rcx
    cmpq $1, %rbx
    jl block.578
    cmpq $2, %rbx
    je block.576
    jmp block.577

	.globl main
	.align 16
main:
    pushq %rbx
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    jmp start

	.align 16
conclusion:
    subq $0, %r15
    addq $8, %rsp
    popq %rbp
    popq %rbx
    retq 


