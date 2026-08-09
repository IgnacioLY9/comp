	.align 16
block.28:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.29:
    movq $2, %rcx
    jmp block.28

	.align 16
block.30:
    callq read_int
    movq %rax, %rcx
    movq %rbx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq $2, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.28

	.align 16
start:
    movq $1, %rcx
    movq $0, %rbx
    cmpq $3, %rcx
    je block.29
    jmp block.30

	.globl main
	.align 16
main:
    pushq %rbx
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp
    jmp start

	.align 16
conclusion:
    addq $8, %rsp
    popq %rbp
    popq %rbx
    retq 


