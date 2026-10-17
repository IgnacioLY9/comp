	.align 16
block.72:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %rbx, 8(%r11)
    movq %rcx, %r11
    movq %r12, 16(%r11)
    movq %rcx, %rax
    jmp map_conclusion

	.align 16
map_start:
    movq %rdi, %r12
    movq %rsi, -8(%r15)
    movq -8(%r15), %r11
    movq 8(%r11), %rcx
    movq %rcx, %rdi
    callq *%r12
    movq %rax, %rbx
    movq -8(%r15), %r11
    movq 16(%r11), %rcx
    movq %rcx, %rdi
    callq *%r12
    movq %rax, %r12
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.72
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.72

	.align 16
map:
    pushq %r15
    pushq %rbx
    pushq %r12
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp
    movq $0, 0(%r15)
    addq $8, %r15
    jmp map_start

	.align 16
map_conclusion:
    subq $1, %r15
    addq $8, %rsp
    popq %rbp
    popq %r12
    popq %rbx
    popq %r15
    retq 

	.align 16
inc_start:
    movq %rdi, %rcx
    movq $1, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    jmp inc_conclusion

	.align 16
inc:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp inc_start

	.align 16
inc_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
block.75:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r14, 8(%r11)
    movq %rcx, %r11
    movq %r12, 16(%r11)
    movq %r13, %rdi
    movq %rcx, %rsi
    callq *%rbx
    movq %rax, %rcx
    movq %rcx, %r11
    movq 16(%r11), %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.align 16
main_start:
    leaq inc(%rip), %rcx
    movq $1, %rdi
    callq *%rcx
    leaq map(%rip), %rbx
    leaq inc(%rip), %r13
    movq $0, %r14
    movq $41, %r12
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.75
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.75

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


