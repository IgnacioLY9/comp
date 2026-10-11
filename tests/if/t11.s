	.align 16
block.591:
    movq $0, %rax
    jmp conclusion

	.align 16
block.592:
    movq %rcx, %rdi
    callq print_int
    jmp block.591

	.align 16
block.593:
    movq $2, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.592

	.align 16
block.594:
    movq $10, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.592

	.align 16
block.595:
    cmpq $0, %rsi
    je block.593
    jmp block.594

	.align 16
block.597:
    movq %rcx, %rdi
    callq print_int
    jmp block.591

	.align 16
block.598:
    movq $3, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.597

	.align 16
block.599:
    movq $12, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.597

	.align 16
block.600:
    cmpq $0, %rsi
    je block.598
    jmp block.599

	.align 16
block.602:
    cmpq $1, %rsi
    jl block.595
    cmpq $2, %rsi
    je block.593
    jmp block.594

	.align 16
start:
    movq $0, %rcx
    movq $1, %rsi
    movq $1, %rdx
    cmpq $1, %rcx
    je block.602
    cmpq $1, %rsi
    jl block.600
    cmpq $2, %rsi
    je block.598
    jmp block.599

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


