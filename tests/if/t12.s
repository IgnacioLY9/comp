	.align 16
block.61:
    movq $0, %rax
    jmp conclusion

	.align 16
block.62:
    movq $1, %rdi
    callq print_int
    jmp block.61

	.align 16
block.63:
    movq $0, %rdi
    callq print_int
    jmp block.61

	.align 16
block.64:
    cmpq $0, %rsi
    je block.62
    jmp block.63

	.align 16
block.65:
    cmpq $1, %rsi
    je block.62
    jmp block.64

	.align 16
block.66:
    cmpq $0, %rcx
    je block.65
    jmp block.64

	.align 16
block.67:
    cmpq $1, %rdx
    je block.65
    jmp block.66

	.align 16
start:
    movq $0, %rsi
    movq $1, %rdx
    movq $1, %rcx
    cmpq $1, %rsi
    je block.67
    jmp block.66

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


