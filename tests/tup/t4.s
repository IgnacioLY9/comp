	.align 16
block.4:
    movq $0, %rax
    jmp conclusion

	.align 16
block.6:
    movq $0, %rdi
    callq print_int
    jmp block.4

	.align 16
block.7:
    movq $1, %rdi
    callq print_int
    jmp block.4

	.align 16
block.8:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %r12, 8(%r11)
    movq %rcx, %r11
    movq %rbx, 16(%r11)
    movq %rcx, %r11
    movq 16(%r11), %rcx
    cmpq $1, %rcx
    je block.6
    jmp block.7

	.align 16
block.9:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.8

	.align 16
block.10:
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.8
    jmp block.9

	.align 16
block.11:
    movq $0, %rbx
    jmp block.10

	.align 16
block.12:
    movq $0, %rbx
    jmp block.10

	.align 16
start:
    movq $1, %rcx
    movq $0, %r12
    cmpq $1, %rcx
    je block.11
    jmp block.12

	.globl main
	.align 16
main:
    pushq %r15
    pushq %r12
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
    popq %r12
    popq %r15
    retq 


