	.align 16
block.511:
    movq $0, %rax
    jmp conclusion

	.align 16
block.513:
    movq $0, %rdi
    callq print_int
    jmp block.511

	.align 16
block.515:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %rbx, 8(%r11)
    movq %rcx, %r11
    movq %r12, 16(%r11)
    movq %rcx, %r11
    movq 16(%r11), %rcx
    cmpq $1, %rcx
    je block.513
    movq $1, %rdi
    callq print_int
    jmp block.511

	.align 16
block.517:
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.515
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.515

	.align 16
block.518:
    movq $0, %r12
    jmp block.517

	.align 16
start:
    movq $1, %rcx
    movq $0, %rbx
    cmpq $1, %rcx
    je block.518
    movq $0, %r12
    jmp block.517

	.globl main
	.align 16
main:
    pushq %rbx
    pushq %r15
    pushq %r12
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
    popq %r12
    popq %r15
    popq %rbx
    retq 


