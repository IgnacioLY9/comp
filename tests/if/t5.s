	.align 16
block.641:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.642:
    movq $2, %rcx
    jmp block.641

	.align 16
start:
    movq $1, %rcx
    movq $0, %rbx
    cmpq $3, %rcx
    je block.642
    callq read_int
    movq %rax, %rcx
    movq %rbx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq $2, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.641

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


