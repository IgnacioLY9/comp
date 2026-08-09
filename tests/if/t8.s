	.align 16
block.15:
    movq $0, %rax
    jmp conclusion

	.align 16
block.16:
    movq %rcx, %rdi
    callq print_int
    jmp block.15

	.align 16
block.17:
    movq $1, %rcx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq $3, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.16

	.align 16
block.18:
    movq $2, %rdi
    callq print_int
    jmp block.15

	.align 16
start:
    movq $1, %rdx
    cmpq $1, %rdx
    je block.17
    jmp block.18

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


