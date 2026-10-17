	.align 16
block.345:
    movq %rbx, %rdi
    callq print_int
    movq $1, %rax
    addq %r14, %rax
    movq %rax, %r14
    jmp label.344

	.align 16
block.346:
    movq %r13, %r11
    movq %r14, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rbx
    jmp block.345

	.align 16
block.347:
    movq $255, %rdi
    callq call_exit
    jmp block.345

	.align 16
block.348:
    movq %r13, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r14, %rcx
    jg block.346
    jmp block.347

	.align 16
block.349:
    cmpq $0, %r14
    jge block.348
    jmp block.347

	.align 16
block.350:
    movq %r13, %r11
    movq %r14, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq $0, 0(%r11)
    jmp block.349

	.align 16
block.351:
    jmp block.349

	.align 16
block.352:
    movq %r13, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r14, %rcx
    jg block.350
    jmp block.351

	.align 16
block.353:
    cmpq $0, %r14
    jge block.352
    jmp block.351

	.align 16
block.354:
    cmpq $3, -8(%rbp)
    je block.353
    jmp block.349

	.align 16
block.355:
    movq %r13, %r11
    movq %r14, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -8(%rbp)
    jmp block.354

	.align 16
block.356:
    movq $255, %rdi
    callq call_exit
    jmp block.354

	.align 16
block.357:
    movq %r13, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r14, %rcx
    jg block.355
    jmp block.356

	.align 16
block.358:
    cmpq $0, %r14
    jge block.357
    jmp block.356

	.align 16
label.344:
    cmpq %r12, %r14
    jl block.358
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.360:
    movq free_ptr(%rip), %r11
    addq $48, free_ptr(%rip)
    movq $21, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r12, 8(%r11)
    movq %rcx, %r11
    movq -24(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rcx, %r11
    movq -16(%rbp), %rax
    movq %rax, 24(%r11)
    movq %rcx, %r11
    movq %r13, 32(%r11)
    movq %rcx, %r11
    movq %r14, 40(%r11)
    movq %rcx, %r13
    movq $0, %r14
    movq %r13, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %r12
    jmp label.344

	.align 16
block.361:
    movq %r15, %rdi
    movq $48, %rsi
    callq collect
    jmp block.360

	.align 16
main_start:
    movq $1, %r12
    movq $2, -24(%rbp)
    movq $3, -16(%rbp)
    movq $4, %r13
    movq $5, %r14
    movq free_ptr(%rip), %rax
    addq $48, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.360
    jmp block.361

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
    subq $24, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    jmp main_start

	.align 16
main_conclusion:
    subq $0, %r15
    addq $24, %rsp
    popq %rbp
    popq %r15
    popq %r12
    popq %r13
    popq %r14
    popq %rbx
    retq 


