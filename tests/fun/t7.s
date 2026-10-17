	.align 16
block.317:
    movq free_ptr(%rip), %r11
    addq $40, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r14, 8(%r11)
    movq %rcx, %r11
    movq %r13, 16(%r11)
    movq %rcx, %r11
    movq %rbx, 24(%r11)
    movq %rcx, %r11
    movq %r12, 32(%r11)
    movq %rcx, %rax
    jmp extend_conclusion

	.align 16
extend_start:
    movq %rdi, %rcx
    movq %rcx, %r11
    movq 8(%r11), %r14
    movq %rcx, %r11
    movq 16(%r11), %r13
    movq %rcx, %r11
    movq 8(%r11), %rbx
    movq %rcx, %r11
    movq 16(%r11), %r12
    movq free_ptr(%rip), %rax
    addq $40, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.317
    movq %r15, %rdi
    movq $40, %rsi
    callq collect
    jmp block.317

	.align 16
extend:
    pushq %rbx
    pushq %r14
    pushq %r13
    pushq %r12
    pushq %r15
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp
    jmp extend_start

	.align 16
extend_conclusion:
    subq $0, %r15
    addq $8, %rsp
    popq %rbp
    popq %r15
    popq %r12
    popq %r13
    popq %r14
    popq %rbx
    retq 

	.align 16
block.323:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r12, 8(%r11)
    movq %rcx, %r11
    movq %rbx, 16(%r11)
    movq %rcx, %rdx
    leaq extend(%rip), %rcx
    movq %rdx, %rdi
    callq *%rcx
    movq %rax, %rbx
    movq %rbx, %r11
    movq 8(%r11), %rcx
    movq %rcx, %rdi
    callq print_int
    movq %rbx, %r11
    movq 16(%r11), %rcx
    movq %rcx, %rdi
    callq print_int
    movq %rbx, %r11
    movq 24(%r11), %rcx
    movq %rcx, %rdi
    callq print_int
    movq %rbx, %r11
    movq 32(%r11), %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.align 16
main_start:
    movq $3, %r12
    movq $5, %rbx
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.323
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.323

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
    jmp main_start

	.align 16
main_conclusion:
    subq $0, %r15
    addq $8, %rsp
    popq %rbp
    popq %rbx
    popq %r15
    popq %r12
    retq 


