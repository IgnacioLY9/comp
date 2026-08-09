	.align 16
block.0:
    movq %rdx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.1:
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rdx
    movq $-1, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.2

	.align 16
block.2:
    cmpq $0, %rcx
    jg block.1
    jmp block.0

	.align 16
start:
    movq $0, %rdx
    movq $5, %rcx
    jmp block.2

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


