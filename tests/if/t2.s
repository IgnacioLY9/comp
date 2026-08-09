	.align 16
block.54:
    movq $0, %rax
    jmp conclusion

	.align 16
block.55:
    movq $1, %rdi
    callq print_int
    jmp block.54

	.align 16
block.56:
    movq $0, %rdi
    callq print_int
    jmp block.54

	.align 16
block.57:
    cmpq $1, %rdx
    je block.55
    jmp block.56

	.align 16
block.58:
    movq $0, %rdi
    callq print_int
    jmp block.54

	.align 16
block.59:
    cmpq $1, %rcx
    je block.55
    jmp block.57

	.align 16
block.60:
    cmpq $1, %rdx
    je block.58
    jmp block.59

	.align 16
start:
    movq $1, %rcx
    movq $1, %rax
    addq %rcx, %rax
    movq %rax, %rdx
    cmpq $1, %rcx
    je block.60
    jmp block.59

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


