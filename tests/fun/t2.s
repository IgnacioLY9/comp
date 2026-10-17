	.align 16
sevenSum_start:
    movq %rdi, %rax
    addq %rsi, %rax
    movq %rax, %rsi
    movq %rsi, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    addq %r8, %rax
    movq %rax, %rdx
    movq %r9, %r11
    movq 8(%r11), %rcx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %r9, %r11
    movq 16(%r11), %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    jmp sevenSum_conclusion

	.align 16
sevenSum:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp sevenSum_start

	.align 16
sevenSum_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    retq 

	.align 16
block.299:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $5, 0(%r11)
    movq %r11, %r9
    movq %r9, %r11
    movq %r13, 8(%r11)
    movq %r9, %r11
    movq %rbx, 16(%r11)
    movq $1, %rdi
    movq $2, %rsi
    movq $3, %rdx
    movq $4, %rcx
    movq $5, %r8
    callq *%r12
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.align 16
main_start:
    leaq sevenSum(%rip), %r12
    movq $6, %r13
    movq $7, %rbx
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.299
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.299

	.globl main
	.align 16
main:
    pushq %r15
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    jmp main_start

	.align 16
main_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    popq %r13
    popq %r12
    popq %rbx
    popq %r15
    retq 


