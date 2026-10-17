	.align 16
block.950:
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.952:
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
    jmp block.950

	.align 16
main_start:
    movq $1, %rcx
    cmpq $1, %rcx
    je block.952
    movq $2, %rdi
    callq print_int
    jmp block.950

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


