	.align 16
start:
    movq $1, %rcx
    movq $42, %rdx
    movq $7, %rax
    addq %rcx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    negq %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

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


