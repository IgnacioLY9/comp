	.align 16
block.732:
    movq %r14, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.733:
    movq %rdx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r14
    jmp block.732

	.align 16
block.734:
    movq $255, %rdi
    callq call_exit
    jmp block.732

	.align 16
block.735:
    movq %rdx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.733
    jmp block.734

	.align 16
block.736:
    movq %rdx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq $2, 0(%r11)
    movq $0, %rax
    cmpq $0, %rax
    jge block.735
    jmp block.734

	.align 16
block.737:
    movq $0, %rax
    cmpq $0, %rax
    jge block.735
    jmp block.734

	.align 16
block.738:
    movq %rdx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.736
    jmp block.737

	.align 16
block.739:
    movq free_ptr(%rip), %r11
    addq $40, free_ptr(%rip)
    movq $17, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq -8(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rcx, %r11
    movq %r13, 16(%r11)
    movq %rcx, %r11
    movq %rbx, 24(%r11)
    movq %rcx, %r11
    movq %r12, 32(%r11)
    movq %rcx, %rdx
    movq $0, %rax
    cmpq $0, %rax
    jge block.738
    jmp block.737

	.align 16
main_start:
    movq $1, -8(%rbp)
    movq $2, %r13
    movq $3, %rbx
    movq $4, %r12
    movq free_ptr(%rip), %rax
    addq $40, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.739
    movq %r15, %rdi
    movq $40, %rsi
    callq collect
    jmp block.739

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


