	.align 16
block.69:
    movq $0, %rax
    jmp conclusion

	.align 16
block.70:
    movq %rcx, %rdi
    callq print_int
    jmp block.69

	.align 16
block.71:
    movq $3, %rcx
    jmp block.70

	.align 16
block.72:
    movq $10, %rcx
    jmp block.70

	.align 16
block.73:
    movq $0, %rdi
    callq print_int
    jmp block.69

	.align 16
block.74:
    cmpq $1, %rcx
    je block.71
    jmp block.72

	.align 16
start:
    movq $2, %rcx
    movq $1, %rsi
    movq $1, %rcx
    movq $2, %rax
    cmpq $1, %rax
    setl %al
    movzbq %al, %rdx
    cmpq %rdx, %rsi
    je block.73
    jmp block.74

	.globl main
	.align 16
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp start

	.align 16
conclusion:
    addq $0, %rsp
    popq %rbp
    retq 


