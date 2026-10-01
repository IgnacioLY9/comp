	.align 16
block.50:
    movq %r13, %rax
    imulq %r12, %rax
    movq %rax, %rcx
    movq -24(%rbp), %rax
    addq %rcx, %rax
    movq %rax, -24(%rbp)
    movq $1, %rax
    addq -16(%rbp), %rax
    movq %rax, -16(%rbp)
    jmp label.49

	.align 16
block.51:
    movq %r14, %r11
    movq -16(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r12
    jmp block.50

	.align 16
block.52:
    movq $255, %rdi
    callq call_exit
    jmp block.50

	.align 16
block.53:
    movq %r14, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -16(%rbp), %rcx
    jg block.51
    jmp block.52

	.align 16
block.54:
    cmpq $0, -16(%rbp)
    jge block.53
    jmp block.52

	.align 16
block.55:
    movq -8(%r15), %r11
    movq -16(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r13
    jmp block.54

	.align 16
block.56:
    movq $255, %rdi
    callq call_exit
    jmp block.54

	.align 16
block.57:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -16(%rbp), %rcx
    jg block.55
    jmp block.56

	.align 16
block.58:
    cmpq $0, -16(%rbp)
    jge block.57
    jmp block.56

	.align 16
block.59:
    movq -24(%rbp), %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
label.49:
    cmpq %rbx, -16(%rbp)
    jne block.58
    jmp block.59

	.align 16
block.60:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r14, 8(%r11)
    movq %rcx, %r11
    movq %rbx, 16(%r11)
    movq %rcx, %r14
    movq $0, -16(%rbp)
    movq $0, -24(%rbp)
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rbx
    jmp label.49

	.align 16
block.61:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.60

	.align 16
block.62:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r14, 8(%r11)
    movq %rcx, %r11
    movq %rbx, 16(%r11)
    movq %rcx, -8(%r15)
    movq $3, %r14
    movq $3, %rbx
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.60
    jmp block.61

	.align 16
block.63:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.62

	.align 16
start:
    movq $2, %r14
    movq $2, %rbx
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.62
    jmp block.63

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
    movq $0, 0(%r15)
    addq $8, %r15
    jmp start

	.align 16
conclusion:
    subq $1, %r15
    addq $24, %rsp
    popq %rbp
    popq %r15
    popq %r12
    popq %r14
    popq %rbx
    popq %r13
    retq 


