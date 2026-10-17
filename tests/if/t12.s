	.align 16
block.937:
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.938:
    movq $1, %rdi
    callq print_int
    jmp block.937

	.align 16
block.940:
    cmpq $0, %rdx
    je block.938
    movq $0, %rdi
    callq print_int
    jmp block.937

	.align 16
block.941:
    cmpq $1, %rdx
    je block.938
    jmp block.940

	.align 16
block.942:
    cmpq $0, %rcx
    je block.941
    jmp block.940

	.align 16
block.943:
    cmpq $1, %rsi
    je block.941
    jmp block.942

	.align 16
main_start:
    movq $0, %rdx
    movq $1, %rsi
    movq $1, %rcx
    cmpq $1, %rdx
    je block.943
    jmp block.942

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


