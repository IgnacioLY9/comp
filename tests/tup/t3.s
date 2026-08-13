	.align 16
block.36:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.37:
    movq $42, %rcx
    jmp block.36

	.align 16
block.38:
    movq $0, %rcx
    jmp block.36

	.align 16
block.39:
    cmpq %rdx, -8(%r15)
    sete %al
    movzbq %al, %rcx
    cmpq $0, %rcx
    je block.37
    jmp block.38

	.align 16
block.40:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r12, 8(%r11)
    movq %rdx, %r11
    movq %rbx, 16(%r11)
    movq -8(%r15), %rax
    cmpq %rax, -8(%r15)
    je block.39
    jmp block.38

	.align 16
block.41:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.40

	.align 16
block.42:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %rbx, 8(%r11)
    movq %rdx, %r11
    movq %r12, 16(%r11)
    movq %rdx, -8(%r15)
    movq -8(%r15), %rax
    movq %rax, -8(%r15)
    movq $3, %r12
    movq $7, %rbx
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.40
    jmp block.41

	.align 16
block.43:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.42

	.align 16
start:
    movq $3, %rbx
    movq $7, %r12
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.42
    jmp block.43

	.globl main
	.align 16
main:
    pushq %r15
    pushq %r12
    pushq %rbx
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
    popq %rbx
    popq %r12
    popq %r15
    retq 


