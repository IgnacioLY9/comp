	.align 16
block.16:
    movq -16(%rbp), %rdi
    callq print_int
    movq $1, %rax
    addq %r13, %rax
    movq %rax, %r13
    jmp label.15

	.align 16
block.17:
    movq %rbx, %r11
    movq %r13, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -16(%rbp)
    jmp block.16

	.align 16
block.18:
    movq $255, %rdi
    callq call_exit
    jmp block.16

	.align 16
block.19:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r13, %rcx
    jg block.17
    jmp block.18

	.align 16
block.20:
    cmpq $0, %r13
    jge block.19
    jmp block.18

	.align 16
block.21:
    movq %rbx, %r11
    movq %r13, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq $0, 0(%r11)
    jmp block.20

	.align 16
block.22:
    jmp block.20

	.align 16
block.23:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r13, %rcx
    jg block.21
    jmp block.22

	.align 16
block.24:
    cmpq $0, %r13
    jge block.23
    jmp block.22

	.align 16
block.25:
    cmpq $3, -24(%rbp)
    je block.24
    jmp block.20

	.align 16
block.26:
    movq %rbx, %r11
    movq %r13, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -24(%rbp)
    jmp block.25

	.align 16
block.27:
    movq $255, %rdi
    callq call_exit
    jmp block.25

	.align 16
block.28:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r13, %rcx
    jg block.26
    jmp block.27

	.align 16
block.29:
    cmpq $0, %r13
    jge block.28
    jmp block.27

	.align 16
block.30:
    movq $0, %rax
    jmp conclusion

	.align 16
label.15:
    cmpq %r12, %r13
    jl block.29
    jmp block.30

	.align 16
block.31:
    movq free_ptr(%rip), %r11
    addq $48, free_ptr(%rip)
    movq $21, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq -8(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rcx, %r11
    movq %r13, 16(%r11)
    movq %rcx, %r11
    movq %r12, 24(%r11)
    movq %rcx, %r11
    movq %r14, 32(%r11)
    movq %rcx, %r11
    movq %rbx, 40(%r11)
    movq %rcx, %rbx
    movq $0, %r13
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %r12
    jmp label.15

	.align 16
block.32:
    movq %r15, %rdi
    movq $48, %rsi
    callq collect
    jmp block.31

	.align 16
start:
    movq $1, -8(%rbp)
    movq $2, %r13
    movq $3, %r12
    movq $4, %r14
    movq $5, %rbx
    movq free_ptr(%rip), %rax
    addq $48, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.31
    jmp block.32

	.globl main
	.align 16
main:
    pushq %r13
    pushq %rbx
    pushq %r14
    pushq %r12
    pushq %r15
    pushq %rbp
    movq %rsp, %rbp
    subq $24, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    jmp start

	.align 16
conclusion:
    subq $0, %r15
    addq $24, %rsp
    popq %rbp
    popq %r15
    popq %r12
    popq %r14
    popq %rbx
    popq %r13
    retq 


