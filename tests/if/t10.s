	.align 16
block.904:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.905:
    movq $2, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.904

	.align 16
block.906:
    movq $10, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.904

	.align 16
block.907:
    cmpq $0, %rbx
    je block.905
    jmp block.906

	.align 16
main_start:
    callq read_int
    movq %rax, %rbx
    callq read_int
    movq %rax, %rcx
    cmpq $1, %rbx
    jl block.907
    cmpq $2, %rbx
    je block.905
    jmp block.906

	.globl main
	.align 16
main:
    pushq %rbx
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    jmp main_start

	.align 16
main_conclusion:
    subq $0, %r15
    addq $8, %rsp
    popq %rbp
    popq %rbx
    retq 


