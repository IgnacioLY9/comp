	.align 16
block.872:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.873:
    movq $42, %rcx
    jmp block.872

	.align 16
block.874:
    movq $0, %rcx
    jmp block.872

	.align 16
block.875:
    cmpq %rcx, -8(%r15)
    sete %al
    movzbq %al, %rcx
    cmpq $0, %rcx
    je block.873
    jmp block.874

	.align 16
block.876:
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
    je block.875
    jmp block.874

	.align 16
block.878:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %rbx, 8(%r11)
    movq %rcx, %r11
    movq %r12, 16(%r11)
    movq %rcx, -8(%r15)
    movq -8(%r15), %rax
    movq %rax, -8(%r15)
    movq $3, %r12
    movq $7, %rbx
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.876
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.876

	.align 16
main_start:
    movq $3, %rbx
    movq $7, %r12
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.878
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.878

	.globl main
	.align 16
main:
    pushq %r12
    pushq %r15
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
    jmp main_start

	.align 16
main_conclusion:
    subq $1, %r15
    addq $8, %rsp
    popq %rbp
    popq %rbx
    popq %r15
    popq %r12
    retq 


