	.align 16
block.455:
    movq -32(%rbp), %rdi
    callq print_int
    movq $1, %rax
    addq %rbx, %rax
    movq %rax, %rbx
    jmp label.454

	.align 16
block.456:
    movq -72(%r15), %r11
    movq %rbx, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -32(%rbp)
    jmp block.455

	.align 16
block.457:
    movq $255, %rdi
    callq call_exit
    jmp block.455

	.align 16
block.458:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %rbx, %rcx
    jg block.456
    jmp block.457

	.align 16
block.459:
    cmpq $0, %rbx
    jge block.458
    jmp block.457

	.align 16
block.460:
    movq $0, %rax
    jmp conclusion

	.align 16
label.454:
    cmpq %r12, %rbx
    jl block.459
    jmp block.460

	.align 16
block.463:
    movq -72(%r15), %r11
    movq %rcx, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq -120(%rbp), %rax
    movq %rax, 0(%r11)
    movq $1, %rax
    addq -112(%rbp), %rax
    movq %rax, -112(%rbp)
    jmp label.462

	.align 16
block.464:
    movq -48(%rbp), %rax
    imulq -80(%rbp), %rax
    movq %rax, %rcx
    movq -112(%rbp), %rax
    imulq %r12, %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.463

	.align 16
block.465:
    movq $1, %rax
    addq -112(%rbp), %rax
    movq %rax, -112(%rbp)
    jmp label.462

	.align 16
block.466:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rsi
    movq -48(%rbp), %rax
    imulq -80(%rbp), %rax
    movq %rax, %rcx
    movq -112(%rbp), %rax
    imulq %r12, %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    cmpq %rcx, %rsi
    jg block.464
    jmp block.465

	.align 16
block.468:
    movq -96(%rbp), %rax
    imulq -40(%rbp), %rax
    movq %rax, %rcx
    movq -120(%rbp), %rax
    addq %rcx, %rax
    movq %rax, -120(%rbp)
    movq $1, %rax
    addq -104(%rbp), %rax
    movq %rax, -104(%rbp)
    jmp label.467

	.align 16
block.469:
    movq -112(%rbp), %rax
    imulq %r14, %rax
    movq %rax, %rcx
    movq -104(%rbp), %rax
    imulq %rbx, %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    movq -16(%r15), %r11
    movq %rcx, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -40(%rbp)
    jmp block.468

	.align 16
block.470:
    movq $255, %rdi
    callq call_exit
    jmp block.468

	.align 16
block.471:
    movq -16(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rdx
    movq -112(%rbp), %rax
    imulq %r14, %rax
    movq %rax, %rsi
    movq -104(%rbp), %rax
    imulq %rbx, %rax
    movq %rax, %rcx
    movq %rsi, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    cmpq %rcx, %rdx
    jg block.469
    jmp block.470

	.align 16
block.472:
    movq -112(%rbp), %rax
    imulq %r14, %rax
    movq %rax, %rdx
    movq -104(%rbp), %rax
    imulq %rbx, %rax
    movq %rax, %rcx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jge block.471
    jmp block.470

	.align 16
block.473:
    movq -48(%rbp), %rax
    imulq -64(%rbp), %rax
    movq %rax, %rdx
    movq -104(%rbp), %rax
    imulq -24(%rbp), %rax
    movq %rax, %rcx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq -8(%r15), %r11
    movq %rcx, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -96(%rbp)
    jmp block.472

	.align 16
block.474:
    movq $255, %rdi
    callq call_exit
    jmp block.472

	.align 16
block.475:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rdx
    movq -48(%rbp), %rax
    imulq -64(%rbp), %rax
    movq %rax, %rsi
    movq -104(%rbp), %rax
    imulq -24(%rbp), %rax
    movq %rax, %rcx
    movq %rsi, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    cmpq %rcx, %rdx
    jg block.473
    jmp block.474

	.align 16
block.476:
    movq -48(%rbp), %rax
    imulq -64(%rbp), %rax
    movq %rax, %rcx
    movq -104(%rbp), %rax
    imulq -24(%rbp), %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jge block.475
    jmp block.474

	.align 16
block.477:
    movq -48(%rbp), %rax
    imulq -80(%rbp), %rax
    movq %rax, %rcx
    movq -112(%rbp), %rax
    imulq %r12, %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jge block.466
    jmp block.465

	.align 16
label.467:
    movq -88(%rbp), %rax
    cmpq %rax, -104(%rbp)
    jl block.476
    jmp block.477

	.align 16
block.478:
    movq $0, -120(%rbp)
    movq $0, -104(%rbp)
    jmp label.467

	.align 16
block.479:
    movq $1, %rax
    addq -48(%rbp), %rax
    movq %rax, -48(%rbp)
    jmp label.461

	.align 16
label.462:
    cmpq %r13, -112(%rbp)
    jl block.478
    jmp block.479

	.align 16
block.480:
    movq $0, -112(%rbp)
    jmp label.462

	.align 16
block.481:
    movq $0, %rbx
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %r12
    jmp label.454

	.align 16
label.461:
    movq -56(%rbp), %rax
    cmpq %rax, -48(%rbp)
    jl block.480
    jmp block.481

	.align 16
block.482:
    movq free_ptr(%rip), %r11
    addq $40, free_ptr(%rip)
    movq $17, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %rbx, 8(%r11)
    movq %rdx, %r11
    movq %r14, 16(%r11)
    movq %rdx, %r11
    movq %r13, 24(%r11)
    movq %rdx, %r11
    movq %r12, 32(%r11)
    movq %rdx, -72(%r15)
    movq $2, -56(%rbp)
    movq $3, -88(%rbp)
    movq $3, -64(%rbp)
    movq $1, -24(%rbp)
    movq $3, %rcx
    movq $2, %r13
    movq $2, %rbx
    movq $1, %r14
    movq $2, %rcx
    movq $2, %rcx
    movq $2, -80(%rbp)
    movq $1, %r12
    movq $0, -48(%rbp)
    jmp label.461

	.align 16
block.483:
    movq %r15, %rdi
    movq $40, %rsi
    callq collect
    jmp block.482

	.align 16
block.484:
    movq free_ptr(%rip), %r11
    addq $56, free_ptr(%rip)
    movq $25, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -24(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %rbx, 16(%r11)
    movq %rdx, %r11
    movq %r12, 24(%r11)
    movq %rdx, %r11
    movq %r13, 32(%r11)
    movq %rdx, %r11
    movq %r14, 40(%r11)
    movq %rdx, %r11
    movq -16(%rbp), %rax
    movq %rax, 48(%r11)
    movq %rdx, -16(%r15)
    movq $0, %rbx
    movq $0, %r14
    movq $0, %r13
    movq $0, %r12
    movq free_ptr(%rip), %rax
    addq $40, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.482
    jmp block.483

	.align 16
block.485:
    movq %r15, %rdi
    movq $56, %rsi
    callq collect
    jmp block.484

	.align 16
block.486:
    movq free_ptr(%rip), %r11
    addq $56, free_ptr(%rip)
    movq $25, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -16(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -8(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rdx, %r11
    movq %rbx, 24(%r11)
    movq %rdx, %r11
    movq %r13, 32(%r11)
    movq %rdx, %r11
    movq %r14, 40(%r11)
    movq %rdx, %r11
    movq %r12, 48(%r11)
    movq %rdx, -8(%r15)
    movq $2, -24(%rbp)
    movq $1, %rbx
    movq $2, %r12
    movq $0, %r13
    movq $0, %r14
    movq $3, -16(%rbp)
    movq free_ptr(%rip), %rax
    addq $56, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.484
    jmp block.485

	.align 16
block.487:
    movq %r15, %rdi
    movq $56, %rsi
    callq collect
    jmp block.486

	.align 16
start:
    movq $1, -16(%rbp)
    movq $2, -8(%rbp)
    movq $3, %rbx
    movq $4, %r13
    movq $1, %r14
    movq $2, %r12
    movq free_ptr(%rip), %rax
    addq $56, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.486
    jmp block.487

	.globl main
	.align 16
main:
    pushq %r14
    pushq %r13
    pushq %rbx
    pushq %r15
    pushq %r12
    pushq %rbp
    movq %rsp, %rbp
    subq $120, %rsp
    movq $16384, %rdi
    movq $16384, %rsi
    callq initialize
    movq rootstack_begin(%rip), %r15
    movq $0, 0(%r15)
    addq $8, %r15
    movq $0, 0(%r15)
    addq $8, %r15
    movq $0, 0(%r15)
    addq $8, %r15
    jmp start

	.align 16
conclusion:
    subq $3, %r15
    addq $120, %rsp
    popq %rbp
    popq %r12
    popq %r15
    popq %rbx
    popq %r13
    popq %r14
    retq 


