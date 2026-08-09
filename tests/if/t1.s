	.align 16
block.3:
    movq $0, %rax
    jmp conclusion

	.align 16
block.4:
    movq $0, %rdi
    callq print_int
    jmp block.3

	.align 16
start:
    jmp block.4

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


