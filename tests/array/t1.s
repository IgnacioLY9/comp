	.align 16
block.20:
    movq %r12, %rax
    imulq %rbx, %rax
    movq %rax, %rcx
    movq -24(%rbp), %rax
    addq %rcx, %rax
    movq %rax, -24(%rbp)
    movq $1, %rax
    addq %r13, %rax
    movq %rax, %r13
    jmp label.19

	.align 16
block.21:
    movq -16(%r15), %r11
    movq %r13, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rbx
    jmp block.20

	.align 16
block.22:
    movq $255, %rdi
    callq call_exit
    jmp block.20

	.align 16
block.23:
    movq -16(%r15), %rax
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
    movq -8(%r15), %r11
    movq %r13, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r12
    jmp block.24

	.align 16
block.26:
    movq $255, %rdi
    callq call_exit
    jmp block.24

	.align 16
block.27:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r13, %rcx
    jg block.25
    jmp block.26

	.align 16
block.28:
    cmpq $0, %r13
    jge block.27
    jmp block.26

	.align 16
block.29:
    movq -24(%rbp), %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
label.19:
    cmpq %r14, %r13
    jne block.28
    jmp block.29

	.align 16
block.30:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $11, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq -8(%r15), %rax
    movq %rax, 8(%r11)
    movq %rcx, %r11
    movq -16(%r15), %rax
    movq %rax, 16(%r11)
    movq $0, %r13
    movq $0, -24(%rbp)
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %r14
    jmp label.19

	.align 16
block.31:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.30

	.align 16
block.32:
    movq free_ptr(%rip), %r11
    addq $16, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r13, 8(%r11)
    movq %rcx, -16(%r15)
    movq -8(%r15), %rax
    movq %rax, -8(%r15)
    movq -16(%r15), %rax
    movq %rax, -16(%r15)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.30
    jmp block.31

	.align 16
block.33:
    movq %r15, %rdi
    movq $16, %rsi
    callq collect
    jmp block.32

	.align 16
block.34:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r14, 8(%r11)
    movq %rcx, %r11
    movq %r13, 16(%r11)
    movq %rcx, -8(%r15)
    movq $3, %r13
    movq free_ptr(%rip), %rax
    addq $16, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.32
    jmp block.33

	.align 16
block.35:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.34

	.align 16
start:
    movq $2, %r14
    movq $2, %r13
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.34
    jmp block.35

	.globl main
	.align 16
main:
    pushq %r15
    pushq %r14
    pushq %r12
    pushq %rbx
    pushq %r13
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    movq $0, 0(%r15)
    addq $8, %r15
    movq $0, 0(%r15)
    addq $8, %r15
    jmp start

	.align 16
conclusion:
    subq $2, %r15
    addq $8, %rsp
    popq %rbp
    popq %r13
    popq %rbx
    popq %r12
    popq %r14
    popq %r15
    retq 


