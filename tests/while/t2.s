	.align 16
block.3:
    movq $0, %rax
    jmp conclusion

	.align 16
block.4:
    movq $0, %rdi
    callq print_int
    movq $-1, %rax
    addq %rbx, %rax
    movq %rax, %rbx
    jmp block.5

	.align 16
block.5:
    cmpq $0, %rbx
    jge block.4
    jmp block.3

	.align 16
start:
    movq $10, %rbx
    jmp block.5

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


