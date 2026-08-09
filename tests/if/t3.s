	.align 16
block.19:
    movq $0, %rax
    jmp conclusion

	.align 16
block.20:
    movq $1, %rdi
    callq print_int
    jmp block.19

	.align 16
start:
    jmp block.20

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


