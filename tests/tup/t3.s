	.align 16
block.543:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.544:
    movq $42, %rcx
    jmp block.543

	.align 16
block.545:
    movq $0, %rcx
    jmp block.543

	.align 16
block.546:
    cmpq %rcx, -8(%r15)
    sete %al
    movzbq %al, %rcx
    cmpq $0, %rcx
    je block.544
    jmp block.545

	.align 16
block.547:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r12, 8(%r11)
    movq %rcx, %r11
    movq %rbx, 16(%r11)
    movq -8(%r15), %rax
    cmpq %rax, -8(%r15)
    je block.546
    jmp block.545

	.align 16
block.549:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r12, 8(%r11)
    movq %rcx, %r11
    movq %rbx, 16(%r11)
    movq %rcx, -8(%r15)
    movq -8(%r15), %rax
    movq %rax, -8(%r15)
    movq $3, %r12
    movq $7, %rbx
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.547
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.547

	.align 16
start:
    movq $3, %r12
    movq $7, %rbx
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.549
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.549

	.globl main
	.align 16
main:
    pushq %r12
    pushq %rbx
    pushq %r15
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    movq $0, 0(%r15)
    addq $8, %r15
    jmp start

	.align 16
conclusion:
    subq $1, %r15
    addq $8, %rsp
    popq %rbp
    popq %r15
    popq %rbx
    popq %r12
    retq 


