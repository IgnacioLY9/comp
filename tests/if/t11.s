	.align 16
block.41:
    movq $0, %rax
    jmp conclusion

	.align 16
block.42:
    movq %rcx, %rdi
    callq print_int
    jmp block.41

	.align 16
block.43:
    movq $2, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.42

	.align 16
block.44:
    movq $10, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.42

	.align 16
block.45:
    cmpq $0, %rsi
    je block.43
    jmp block.44

	.align 16
block.46:
    cmpq $2, %rsi
    je block.43
    jmp block.44

	.align 16
block.47:
    movq %rcx, %rdi
    callq print_int
    jmp block.41

	.align 16
block.48:
    movq $3, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.47

	.align 16
block.49:
    movq $12, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.47

	.align 16
block.50:
    cmpq $0, %rsi
    je block.48
    jmp block.49

	.align 16
block.51:
    cmpq $2, %rsi
    je block.48
    jmp block.49

	.align 16
block.52:
    cmpq $1, %rsi
    jl block.45
    jmp block.46

	.align 16
block.53:
    cmpq $1, %rsi
    jl block.50
    jmp block.51

	.align 16
start:
    movq $0, %rcx
    movq $1, %rsi
    movq $1, %rdx
    cmpq $1, %rcx
    je block.52
    jmp block.53

	.globl main
	.align 16
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $0, %rsp
    jmp start

	.align 16
conclusion:
    addq $0, %rsp
    popq %rbp
    retq 


