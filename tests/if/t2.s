	.align 16
block.954:
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.955:
    movq $1, %rdi
    callq print_int
    jmp block.954

	.align 16
block.958:
    movq $0, %rdi
    callq print_int
    jmp block.954

	.align 16
block.959:
    cmpq $1, %rdx
    je block.955
    cmpq $1, %rcx
    je block.955
    movq $0, %rdi
    callq print_int
    jmp block.954

	.align 16
block.960:
    cmpq $1, %rcx
    je block.958
    jmp block.959

	.align 16
main_start:
    movq $1, %rdx
    movq $1, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    cmpq $1, %rdx
    je block.960
    jmp block.959

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


