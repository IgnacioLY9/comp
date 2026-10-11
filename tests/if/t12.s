	.align 16
block.608:
    movq $0, %rax
    jmp conclusion

	.align 16
block.609:
    movq $1, %rdi
    callq print_int
    jmp block.608

	.align 16
block.611:
    cmpq $0, %rdx
    je block.609
    movq $0, %rdi
    callq print_int
    jmp block.608

	.align 16
block.612:
    cmpq $1, %rdx
    je block.609
    jmp block.611

	.align 16
block.613:
    cmpq $0, %rcx
    je block.612
    jmp block.611

	.align 16
block.614:
    cmpq $1, %rsi
    je block.612
    jmp block.613

	.align 16
start:
    movq $0, %rdx
    movq $1, %rsi
    movq $1, %rcx
    cmpq $1, %rdx
    je block.614
    jmp block.613

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


