	.align 16
block.403:
    movq -8(%rbp), %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.404:
    movq %rdx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -8(%rbp)
    jmp block.403

	.align 16
block.405:
    movq $255, %rdi
    callq call_exit
    jmp block.403

	.align 16
block.406:
    movq %rdx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.404
    jmp block.405

	.align 16
block.407:
    movq %rdx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq $2, 0(%r11)
    movq $0, %rax
    cmpq $0, %rax
    jge block.406
    jmp block.405

	.align 16
block.408:
    movq $0, %rax
    cmpq $0, %rax
    jge block.406
    jmp block.405

	.align 16
block.409:
    movq %rdx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.407
    jmp block.408

	.align 16
block.410:
    movq free_ptr(%rip), %r11
    addq $40, free_ptr(%rip)
    movq $17, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r12, 8(%r11)
    movq %rcx, %r11
    movq %r13, 16(%r11)
    movq %rcx, %r11
    movq %r14, 24(%r11)
    movq %rcx, %r11
    movq %rbx, 32(%r11)
    movq %rcx, %rdx
    movq $0, %rax
    cmpq $0, %rax
    jge block.409
    jmp block.408

	.align 16
start:
    movq $1, %r12
    movq $2, %r13
    movq $3, %r14
    movq $4, %rbx
    movq free_ptr(%rip), %rax
    addq $40, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.410
    movq %r15, %rdi
    movq $40, %rsi
    callq collect
    jmp block.410

	.globl main
	.align 16
main:
    pushq %r14
    pushq %r12
    pushq %r15
    pushq %rbx
    pushq %r13
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
    popq %r13
    popq %rbx
    popq %r15
    popq %r12
    popq %r14
    retq 


