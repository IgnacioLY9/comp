	.align 16
block.840:
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.842:
    movq $0, %rdi
    callq print_int
    jmp block.840

	.align 16
block.844:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %rbx, 8(%r11)
    movq %rcx, %r11
    movq %r12, 16(%r11)
    movq %rcx, %r11
    movq 16(%r11), %rcx
    cmpq $1, %rcx
    je block.842
    movq $1, %rdi
    callq print_int
    jmp block.840

	.align 16
block.846:
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.844
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.844

	.align 16
block.847:
    movq $0, %r12
    jmp block.846

	.align 16
main_start:
    movq $1, %rcx
    movq $0, %rbx
    cmpq $1, %rcx
    je block.847
    movq $0, %r12
    jmp block.846

	.globl main
	.align 16
main:
    pushq %r15
    pushq %rbx
    pushq %r12
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
    popq %r12
    popq %rbx
    popq %r15
    retq 


