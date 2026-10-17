	.align 16
block.962:
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.963:
    movq %rcx, %rdi
    callq print_int
    jmp block.962

	.align 16
block.964:
    movq $3, %rcx
    jmp block.963

	.align 16
block.966:
    movq $0, %rdi
    callq print_int
    jmp block.962

	.align 16
main_start:
    movq $2, %rcx
    movq $1, %rsi
    movq $1, %rcx
    movq $2, %rax
    cmpq $1, %rax
    setl %al
    movzbq %al, %rdx
    cmpq %rdx, %rsi
    je block.966
    cmpq $1, %rcx
    je block.964
    movq $10, %rcx
    jmp block.963

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


