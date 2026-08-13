	.align 16
block.21:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.22:
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
    jmp block.21

	.align 16
block.23:
    movq %r15, %rdi
    movq $16, %rsi
    callq collect
    jmp block.22

	.align 16
block.24:
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
    jl block.22
    jmp block.23

	.align 16
block.25:
    movq %r15, %rdi
    movq $16, %rsi
    callq collect
    jmp block.24

	.align 16
start:
    movq $42, %rbx
    movq free_ptr(%rip), %rax
    addq $16, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.24
    jmp block.25

	.globl main
	.align 16
main:
    pushq %r15
    pushq %rbx
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
    popq %rbx
    popq %r15
    retq 


