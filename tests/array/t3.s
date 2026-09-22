	.align 16
block.87:
    movq %r13, %rax
    imulq %r14, %rax
    movq %rax, %rcx
    movq -24(%rbp), %rax
    addq %rcx, %rax
    movq %rax, -24(%rbp)
    movq $1, %rax
    addq -16(%rbp), %rax
    movq %rax, -16(%rbp)
    jmp label.86

	.align 16
block.88:
    movq %rbx, %r11
    movq -16(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r14
    jmp block.87

	.align 16
block.89:
    movq $255, %rdi
    callq call_exit
    jmp block.87

	.align 16
block.90:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -16(%rbp), %rcx
    jg block.88
    jmp block.89

	.align 16
block.91:
    cmpq $0, -16(%rbp)
    jge block.90
    jmp block.89

	.align 16
block.92:
    movq -8(%r15), %r11
    movq -16(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r13
    jmp block.91

	.align 16
block.93:
    movq $255, %rdi
    callq call_exit
    jmp block.91

	.align 16
block.94:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -16(%rbp), %rcx
    jg block.92
    jmp block.93

	.align 16
block.95:
    cmpq $0, -16(%rbp)
    jge block.94
    jmp block.93

	.align 16
block.96:
    movq -24(%rbp), %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
label.86:
    cmpq %r12, -16(%rbp)
    jl block.95
    jmp block.96

	.align 16
block.97:
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
    movq %rdx, %rbx
    movq $0, -24(%rbp)
    movq $0, -16(%rbp)
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %r12
    jmp label.86

	.align 16
block.98:
    movq %r15, %rdi
    movq $48, %rsi
    callq collect
    jmp block.97

	.align 16
block.99:
    movq free_ptr(%rip), %r11
    addq $48, free_ptr(%rip)
    movq $21, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %rbx, 8(%r11)
    movq %rdx, %r11
    movq -24(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rdx, %r11
    movq -8(%rbp), %rax
    movq %rax, 24(%r11)
    movq %rdx, %r11
    movq -16(%rbp), %rax
    movq %rax, 32(%r11)
    movq %rdx, %r11
    movq %r12, 40(%r11)
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
    jl block.97
    jmp block.98

	.align 16
block.100:
    movq %r15, %rdi
    movq $48, %rsi
    callq collect
    jmp block.99

	.align 16
start:
    movq $1, %rbx
    movq $2, -24(%rbp)
    movq $3, -8(%rbp)
    movq $4, -16(%rbp)
    movq $5, %r12
    movq free_ptr(%rip), %rax
    addq $48, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.99
    jmp block.100

	.globl main
	.align 16
main:
    pushq %r14
    pushq %r13
    pushq %rbx
    pushq %r15
    pushq %r12
    pushq %rbp
    movq %rsp, %rbp
    subq $40, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    movq $0, 0(%r15)
    addq $8, %r15
    jmp start

	.align 16
conclusion:
    subq $1, %r15
    addq $40, %rsp
    popq %rbp
    popq %r12
    popq %r15
    popq %rbx
    popq %r13
    popq %r14
    retq 


