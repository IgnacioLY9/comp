	.align 16
block.34:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.35:
    movq $2, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.34

	.align 16
block.36:
    movq $10, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.34

	.align 16
block.37:
    cmpq $0, %rbx
    je block.35
    jmp block.36

	.align 16
block.38:
    cmpq $2, %rbx
    je block.35
    jmp block.36

	.align 16
start:
    callq read_int
    movq %rax, %rbx
    callq read_int
    movq %rax, %rcx
    cmpq $1, %rbx
    jl block.37
    jmp block.38

	.globl main
	.align 16
main:
    pushq %rbx
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp
    jmp start

	.align 16
conclusion:
    addq $8, %rsp
    popq %rbp
    popq %rbx
    retq 


