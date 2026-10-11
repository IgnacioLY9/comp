	.align 16
block.621:
    movq $0, %rax
    jmp conclusion

	.align 16
block.623:
    movq $1, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq $3, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    jmp block.621

	.align 16
start:
    movq $1, %rcx
    cmpq $1, %rcx
    je block.623
    movq $2, %rdi
    callq print_int
    jmp block.621

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


