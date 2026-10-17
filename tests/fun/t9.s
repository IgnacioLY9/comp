	.align 16
block.28:
    movq $1, %rax
    jmp fib_conclusion

	.align 16
block.30:
    movq $0, %rax
    jmp fib_conclusion

	.align 16
fib_start:
    movq %rdi, %r12
    cmpq $0, %r12
    je block.30
    cmpq $1, %r12
    je block.28
    leaq fib(%rip), %rcx
    movq $-1, %rax
    addq %r12, %rax
    movq %rax, %rdx
    movq %rdx, %rdi
    callq *%rcx
    movq %rax, %rbx
    leaq fib(%rip), %rcx
    movq $-2, %rax
    addq %r12, %rax
    movq %rax, %rdx
    movq %rdx, %rdi
    callq *%rcx
    movq %rax, %rcx
    movq %rbx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rax
    jmp fib_conclusion

	.align 16
fib:
    pushq %r12
    pushq %rbx
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp fib_start

	.align 16
fib_conclusion:
    subq $0, %r15
    addq $0, %rsp
    popq %rbp
    popq %rbx
    popq %r12
    retq 

	.align 16
main_start:
    leaq fib(%rip), %rcx
    movq $8, %rdi
    callq *%rcx
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.globl main
	.align 16
main:
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
    retq 


