	.align 16
block.22:
    movq $0, %rax
    jmp conclusion

	.align 16
block.23:
    movq $0, %rdi
    callq print_int
    jmp block.22

	.align 16
block.24:
    movq $1, %rdi
    callq print_int
    jmp block.22

	.align 16
block.25:
    movq %rcx, %rdi
    callq print_int
    movq %rbx, %rax
    movq 0(%rax), %rax
    andq $126, %rax
    sarq $1, %rax
    movq %rax, %rcx
    cmpq $4, %rcx
    jg block.23
    jmp block.24

	.align 16
block.26:
    movq free_ptr(%rip), %r11
    addq $48, free_ptr(%rip)
    movq $11, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %rbx, 8(%r11)
    movq %rcx, %r11
    movq %r13, 16(%r11)
    movq %rcx, %r11
    movq -8(%rbp), %rax
    movq %rax, 24(%r11)
    movq %rcx, %r11
    movq %r14, 32(%r11)
    movq %rcx, %r11
    movq %r12, 40(%r11)
    movq %rcx, %rbx
    movq %rbx, %rax
    movq 0(%rax), %rax
    andq $126, %rax
    sarq $1, %rax
    movq %rax, %rcx
    jmp block.25

	.align 16
block.27:
    movq %r15, %rdi
    movq $48, %rsi
    callq collect
    jmp block.26

	.align 16
start:
    movq $1, %rbx
    movq $2, %r13
    movq $3, -8(%rbp)
    movq $4, %r14
    movq $5, %r12
    movq free_ptr(%rip), %rax
    addq $48, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.26
    jmp block.27

	.globl main
	.align 16
main:
    pushq %r15
    pushq %r13
    pushq %r12
    pushq %rbx
    pushq %r14
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    jmp start

	.align 16
conclusion:
    subq $0, %r15
    addq $8, %rsp
    popq %rbp
    popq %r14
    popq %rbx
    popq %r12
    popq %r13
    popq %r15
    retq 


