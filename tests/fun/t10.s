	.align 16
one_start:
    movq %rdi, %rcx
    movq $1, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    jmp one_conclusion

	.align 16
one:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp one_start

	.align 16
one_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
two_start:
    movq %rdi, %rcx
    movq $2, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    jmp two_conclusion

	.align 16
two:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp two_start

	.align 16
two_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
three_start:
    movq %rdi, %rcx
    movq $3, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    jmp three_conclusion

	.align 16
three:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp three_start

	.align 16
three_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
four_start:
    movq %rdi, %rcx
    movq $4, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    jmp four_conclusion

	.align 16
four:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp four_start

	.align 16
four_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
block.15:
    movq $5, %rdi
    callq *-8(%rbp)
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.16:
    movq %rcx, %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -8(%rbp)
    jmp block.15

	.align 16
block.17:
    movq $255, %rdi
    callq call_exit
    jmp block.15

	.align 16
block.18:
    movq %rcx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rdx
    cmpq $1, %rdx
    jg block.16
    jmp block.17

	.align 16
block.19:
    movq free_ptr(%rip), %r11
    addq $40, free_ptr(%rip)
    movq $17, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %rbx, 8(%r11)
    movq %rcx, %r11
    movq %r14, 16(%r11)
    movq %rcx, %r11
    movq %r13, 24(%r11)
    movq %rcx, %r11
    movq %r12, 32(%r11)
    movq $1, %rax
    cmpq $0, %rax
    jge block.18
    jmp block.17

	.align 16
main_start:
    leaq one(%rip), %rbx
    leaq two(%rip), %r14
    leaq three(%rip), %r13
    leaq four(%rip), %r12
    movq free_ptr(%rip), %rax
    addq $40, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.19
    movq %r15, %rdi
    movq $40, %rsi
    callq collect
    jmp block.19

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


