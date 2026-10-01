	.align 16
block.10:
    movq %r14, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.11:
    movq %rdx, %r11
    movq $4, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r14
    jmp block.10

	.align 16
block.12:
    movq $255, %rdi
    callq call_exit
    jmp block.10

	.align 16
block.13:
    movq %rdx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $4, %rcx
    jg block.11
    jmp block.12

	.align 16
block.14:
    movq %rdx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq $2, 0(%r11)
    movq $4, %rax
    cmpq $0, %rax
    jge block.13
    jmp block.12

	.align 16
block.15:
    movq $4, %rax
    cmpq $0, %rax
    jge block.13
    jmp block.12

	.align 16
block.16:
    movq %rdx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.14
    jmp block.15

	.align 16
block.17:
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
    movq %r12, 24(%r11)
    movq %rcx, %r11
    movq %rbx, 32(%r11)
    movq %rcx, %rdx
    movq $0, %rax
    cmpq $0, %rax
    jge block.16
    jmp block.15

	.align 16
block.18:
    movq %r15, %rdi
    movq $40, %rsi
    callq collect
    jmp block.17

	.align 16
start:
    movq $1, -8(%rbp)
    movq $2, %r13
    movq $3, %r12
    movq $4, %rbx
    movq free_ptr(%rip), %rax
    addq $40, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.17
    jmp block.18

	.globl main
	.align 16
main:
    pushq %r13
    pushq %r14
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
    jmp start

	.align 16
conclusion:
    subq $0, %r15
    addq $8, %rsp
    popq %rbp
    popq %rbx
    popq %r15
    popq %r12
    popq %r14
    popq %r13
    retq 


