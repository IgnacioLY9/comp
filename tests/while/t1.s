	.align 16
block.567:
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rdx
    movq $-1, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp label.566

	.align 16
label.566:
    cmpq $0, %rcx
    jg block.567
    movq %rdx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
start:
    movq $0, %rdx
    movq $5, %rcx
    jmp label.566

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


