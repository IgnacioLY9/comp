	.align 16
block.899:
    movq $0, %rdi
    callq print_int
    movq $-1, %rax
    addq %rbx, %rax
    movq %rax, %rbx
    jmp label.898

	.align 16
label.898:
    cmpq $0, %rbx
    jge block.899
    movq $0, %rax
    jmp main_conclusion

	.align 16
main_start:
    movq $10, %rbx
    jmp label.898

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


