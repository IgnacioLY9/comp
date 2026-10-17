	.align 16
block.416:
    movq %r13, %rax
    imulq %r14, %rax
    movq %rax, %rcx
    movq -24(%rbp), %rax
    addq %rcx, %rax
    movq %rax, -24(%rbp)
    movq $1, %rax
    addq -16(%rbp), %rax
    movq %rax, -16(%rbp)
    jmp label.415

	.align 16
block.417:
    movq %r12, %r11
    movq -16(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r14
    jmp block.416

	.align 16
block.418:
    movq $255, %rdi
    callq call_exit
    jmp block.416

	.align 16
block.419:
    movq %r12, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -16(%rbp), %rcx
    jg block.417
    jmp block.418

	.align 16
block.420:
    cmpq $0, -16(%rbp)
    jge block.419
    jmp block.418

	.align 16
block.421:
    movq -8(%r15), %r11
    movq -16(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r13
    jmp block.420

	.align 16
block.422:
    movq $255, %rdi
    callq call_exit
    jmp block.420

	.align 16
block.423:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -16(%rbp), %rcx
    jg block.421
    jmp block.422

	.align 16
block.424:
    cmpq $0, -16(%rbp)
    jge block.423
    jmp block.422

	.align 16
label.415:
    cmpq %rbx, -16(%rbp)
    jl block.424
    movq -24(%rbp), %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.426:
    movq free_ptr(%rip), %r11
    addq $48, free_ptr(%rip)
    movq $21, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -32(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -24(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rdx, %r11
    movq %rbx, 24(%r11)
    movq %rdx, %r11
    movq %r12, 32(%r11)
    movq %rdx, %r11
    movq -16(%rbp), %rax
    movq %rax, 40(%r11)
    movq %rdx, %r12
    movq $0, -24(%rbp)
    movq $0, -16(%rbp)
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rbx
    jmp label.415

	.align 16
block.427:
    movq %r15, %rdi
    movq $48, %rsi
    callq collect
    jmp block.426

	.align 16
block.428:
    movq free_ptr(%rip), %r11
    addq $48, free_ptr(%rip)
    movq $21, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -8(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %rbx, 16(%r11)
    movq %rdx, %r11
    movq -24(%rbp), %rax
    movq %rax, 24(%r11)
    movq %rdx, %r11
    movq %r12, 32(%r11)
    movq %rdx, %r11
    movq -16(%rbp), %rax
    movq %rax, 40(%r11)
    movq %rdx, -8(%r15)
    movq $2, -32(%rbp)
    movq $3, -24(%rbp)
    movq $1, %rbx
    movq $0, %r12
    movq $1, -16(%rbp)
    movq free_ptr(%rip), %rax
    addq $48, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.426
    jmp block.427

	.align 16
block.429:
    movq %r15, %rdi
    movq $48, %rsi
    callq collect
    jmp block.428

	.align 16
main_start:
    movq $1, -8(%rbp)
    movq $2, %rbx
    movq $3, -24(%rbp)
    movq $4, %r12
    movq $5, -16(%rbp)
    movq free_ptr(%rip), %rax
    addq $48, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.428
    jmp block.429

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
    subq $40, %rsp
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
    addq $40, %rsp
    popq %rbp
    popq %r15
    popq %r12
    popq %r13
    popq %r14
    popq %rbx
    retq 


