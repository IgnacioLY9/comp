	.align 16
block.22:
    movq $0, %rax
    jmp conclusion

	.align 16
block.23:
    movq $0, %rdi
    callq print_int
    jmp block.22

	.align 16
block.24:
    movq $1, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.23

	.align 16
block.25:
    movq $1, %rdi
    callq print_int
    jmp block.22

	.align 16
start:
    movq $1, %rcx
    cmpq $2, %rcx
    je block.24
    jmp block.25

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


