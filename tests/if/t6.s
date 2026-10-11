	.align 16
block.615:
    movq $0, %rax
    jmp conclusion

	.align 16
block.617:
    movq $1, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq $0, %rdi
    callq print_int
    jmp block.615

	.align 16
start:
    movq $1, %rcx
    cmpq $2, %rcx
    je block.617
    movq $1, %rdi
    callq print_int
    jmp block.615

	.globl main
	.align 16
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    jmp start

	.align 16
conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 


