	.align 16
block.625:
    movq $0, %rax
    jmp conclusion

	.align 16
block.626:
    movq $1, %rdi
    callq print_int
    jmp block.625

	.align 16
block.629:
    movq $0, %rdi
    callq print_int
    jmp block.625

	.align 16
block.630:
    cmpq $1, %rdx
    je block.626
    cmpq $1, %rcx
    je block.626
    movq $0, %rdi
    callq print_int
    jmp block.625

	.align 16
block.631:
    cmpq $1, %rcx
    je block.629
    jmp block.630

	.align 16
start:
    movq $1, %rdx
    movq $1, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    cmpq $1, %rdx
    je block.631
    jmp block.630

	.globl main
	.align 16
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    jmp start

	.align 16
conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 


