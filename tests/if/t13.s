	.align 16
block.9:
    movq $0, %rax
    jmp conclusion

	.align 16
block.10:
    movq %rcx, %rdi
    callq print_int
    jmp block.9

	.align 16
block.11:
    movq $0, %rcx
    jmp block.10

	.align 16
start:
    jmp block.11

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


