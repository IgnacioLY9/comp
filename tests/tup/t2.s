	.align 16
block.889:
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.890:
    movq $0, %rdi
    callq print_int
    jmp block.889

	.align 16
block.893:
    movq free_ptr(%rip), %r11
    addq $48, free_ptr(%rip)
    movq $11, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %rbx, 8(%r11)
    movq %rcx, %r11
    movq %r14, 16(%r11)
    movq %rcx, %r11
    movq -8(%rbp), %rax
    movq %rax, 24(%r11)
    movq %rcx, %r11
    movq %r12, 32(%r11)
    movq %rcx, %r11
    movq %r13, 40(%r11)
    movq %rcx, %rbx
    movq %rbx, %rax
    movq 0(%rax), %rax
    andq $126, %rax
    sarq $1, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    movq %rbx, %rax
    movq 0(%rax), %rax
    andq $126, %rax
    sarq $1, %rax
    movq %rax, %rcx
    cmpq $4, %rcx
    jg block.890
    movq $1, %rdi
    callq print_int
    jmp block.889

	.align 16
main_start:
    movq $1, %rbx
    movq $2, %r14
    movq $3, -8(%rbp)
    movq $4, %r12
    movq $5, %r13
    movq free_ptr(%rip), %rax
    addq $48, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.893
    movq %r15, %rdi
    movq $48, %rsi
    callq collect
    jmp block.893

	.globl main
	.align 16
main:
    pushq %rbx
    pushq %r14
    pushq %r13
    pushq %r12
    pushq %r15
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
    popq %r15
    popq %r12
    popq %r13
    popq %r14
    popq %rbx
    retq 


