	.align 16
block.910:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.911:
    movq $2, %rcx
    jmp block.910

	.align 16
main_start:
    movq $1, %rcx
    cmpq $0, %rcx
    je block.911
    callq read_int
    movq %rax, %rcx
    movq $2, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.910

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
    jmp main_start

	.align 16
main_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 


