	.align 16
block.6:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.7:
    movq $2, %rcx
    jmp block.6

	.align 16
block.8:
    callq read_int
    movq %rax, %rcx
    movq $2, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.6

	.align 16
start:
    movq $1, %rcx
    cmpq $0, %rcx
    je block.7
    jmp block.8

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


