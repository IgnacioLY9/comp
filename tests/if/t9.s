	.align 16
block.581:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.582:
    movq $2, %rcx
    jmp block.581

	.align 16
start:
    movq $1, %rcx
    cmpq $0, %rcx
    je block.582
    callq read_int
    movq %rax, %rcx
    movq $2, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.581

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


