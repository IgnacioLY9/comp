	.align 16
block.633:
    movq $0, %rax
    jmp conclusion

	.align 16
block.634:
    movq %rcx, %rdi
    callq print_int
    jmp block.633

	.align 16
block.635:
    movq $3, %rcx
    jmp block.634

	.align 16
block.637:
    movq $0, %rdi
    callq print_int
    jmp block.633

	.align 16
start:
    movq $2, %rcx
    movq $1, %rsi
    movq $1, %rcx
    movq $2, %rax
    cmpq $1, %rax
    setl %al
    movzbq %al, %rdx
    cmpq %rdx, %rsi
    je block.637
    cmpq $1, %rcx
    je block.635
    movq $10, %rcx
    jmp block.634

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


