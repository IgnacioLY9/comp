	.align 16
block.529:
    movq free_ptr(%rip), %r11
    addq $16, free_ptr(%rip)
    movq $131, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq -8(%r15), %rax
    movq %rax, 8(%r11)
    movq %rcx, %r11
    movq 8(%r11), %rcx
    movq %rcx, %r11
    movq 8(%r11), %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.531:
    movq free_ptr(%rip), %r11
    addq $16, free_ptr(%rip)
    movq $3, 0(%r11)
    movq %r11, %rcx
    movq %rcx, %r11
    movq %rbx, 8(%r11)
    movq %rcx, -8(%r15)
    movq free_ptr(%rip), %rax
    addq $16, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.529
    movq %r15, %rdi
    movq $16, %rsi
    callq collect
    jmp block.529

	.align 16
start:
    movq $42, %rbx
    movq free_ptr(%rip), %rax
    addq $16, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.531
    movq %r15, %rdi
    movq $16, %rsi
    callq collect
    jmp block.531

	.globl main
	.align 16
main:
    pushq %rbx
    pushq %r15
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
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
    addq $0, %rsp
    popq %rbp
    popq %r15
    popq %rbx
    retq 


