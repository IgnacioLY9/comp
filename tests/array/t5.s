	.align 16
block.474:
    movq -24(%rbp), %rdi
    callq print_int
    movq $1, %rax
    addq %r12, %rax
    movq %rax, %r12
    jmp label.473

	.align 16
block.475:
    movq -72(%r15), %r11
    movq %r12, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -24(%rbp)
    jmp block.474

	.align 16
block.476:
    movq $255, %rdi
    callq call_exit
    jmp block.474

	.align 16
block.477:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r12, %rcx
    jg block.475
    jmp block.476

	.align 16
block.478:
    cmpq $0, %r12
    jge block.477
    jmp block.476

	.align 16
block.479:
    movq $0, %rax
    jmp conclusion

	.align 16
label.473:
    cmpq %rbx, %r12
    jl block.478
    jmp block.479

	.align 16
block.482:
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
    jmp label.481

	.align 16
block.483:
    movq -32(%rbp), %rax
    imulq %r14, %rax
    movq %rax, %rcx
    movq -112(%rbp), %rax
    imulq %r12, %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    jmp block.482

	.align 16
block.484:
    movq $1, %rax
    addq -112(%rbp), %rax
    movq %rax, -112(%rbp)
    jmp label.481

	.align 16
block.485:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    movq -32(%rbp), %rax
    imulq %r14, %rax
    movq %rax, %rsi
    movq -112(%rbp), %rax
    imulq %r12, %rax
    movq %rax, %rdx
    movq %rsi, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    cmpq %rdx, %rcx
    jg block.483
    jmp block.484

	.align 16
block.487:
    movq -40(%rbp), %rax
    imulq -96(%rbp), %rax
    movq %rax, %rcx
    movq -120(%rbp), %rax
    addq %rcx, %rax
    movq %rax, -120(%rbp)
    movq $1, %rax
    addq -104(%rbp), %rax
    movq %rax, -104(%rbp)
    jmp label.486

	.align 16
block.488:
    movq -112(%rbp), %rax
    imulq -80(%rbp), %rax
    movq %rax, %rcx
    movq -104(%rbp), %rax
    imulq -88(%rbp), %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    movq -8(%r15), %r11
    movq %rcx, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -96(%rbp)
    jmp block.487

	.align 16
block.489:
    movq $255, %rdi
    callq call_exit
    jmp block.487

	.align 16
block.490:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rdx
    movq -112(%rbp), %rax
    imulq -80(%rbp), %rax
    movq %rax, %rsi
    movq -104(%rbp), %rax
    imulq -88(%rbp), %rax
    movq %rax, %rcx
    movq %rsi, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    cmpq %rcx, %rdx
    jg block.488
    jmp block.489

	.align 16
block.491:
    movq -112(%rbp), %rax
    imulq -80(%rbp), %rax
    movq %rax, %rcx
    movq -104(%rbp), %rax
    imulq -88(%rbp), %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jge block.490
    jmp block.489

	.align 16
block.492:
    movq -32(%rbp), %rax
    imulq -56(%rbp), %rax
    movq %rax, %rdx
    movq -104(%rbp), %rax
    imulq -64(%rbp), %rax
    movq %rax, %rcx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    movq -16(%r15), %r11
    movq %rcx, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -40(%rbp)
    jmp block.491

	.align 16
block.493:
    movq $255, %rdi
    callq call_exit
    jmp block.491

	.align 16
block.494:
    movq -16(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rdx
    movq -32(%rbp), %rax
    imulq -56(%rbp), %rax
    movq %rax, %rsi
    movq -104(%rbp), %rax
    imulq -64(%rbp), %rax
    movq %rax, %rcx
    movq %rsi, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    cmpq %rcx, %rdx
    jg block.492
    jmp block.493

	.align 16
block.495:
    movq -32(%rbp), %rax
    imulq -56(%rbp), %rax
    movq %rax, %rdx
    movq -104(%rbp), %rax
    imulq -64(%rbp), %rax
    movq %rax, %rcx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jge block.494
    jmp block.493

	.align 16
block.496:
    movq -32(%rbp), %rax
    imulq %r14, %rax
    movq %rax, %rcx
    movq -112(%rbp), %rax
    imulq %r12, %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jge block.485
    jmp block.484

	.align 16
label.486:
    cmpq %r13, -104(%rbp)
    jl block.495
    jmp block.496

	.align 16
block.497:
    movq $0, -120(%rbp)
    movq $0, -104(%rbp)
    jmp label.486

	.align 16
block.498:
    movq $1, %rax
    addq -32(%rbp), %rax
    movq %rax, -32(%rbp)
    jmp label.480

	.align 16
label.481:
    cmpq %rbx, -112(%rbp)
    jl block.497
    jmp block.498

	.align 16
block.499:
    movq $0, -112(%rbp)
    jmp label.481

	.align 16
block.500:
    movq $0, %r12
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rbx
    jmp label.473

	.align 16
label.480:
    movq -48(%rbp), %rax
    cmpq %rax, -32(%rbp)
    jl block.499
    jmp block.500

	.align 16
block.501:
    movq free_ptr(%rip), %r11
    addq $40, free_ptr(%rip)
    movq $17, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r13, 8(%r11)
    movq %rdx, %r11
    movq %r14, 16(%r11)
    movq %rdx, %r11
    movq %rbx, 24(%r11)
    movq %rdx, %r11
    movq %r12, 32(%r11)
    movq %rdx, -72(%r15)
    movq $2, -48(%rbp)
    movq $3, %r13
    movq $3, -56(%rbp)
    movq $1, -64(%rbp)
    movq $3, %rcx
    movq $2, %rbx
    movq $2, -88(%rbp)
    movq $1, -80(%rbp)
    movq $2, %rcx
    movq $2, %rcx
    movq $2, %r14
    movq $1, %r12
    movq $0, -32(%rbp)
    jmp label.480

	.align 16
block.502:
    movq %r15, %rdi
    movq $40, %rsi
    callq collect
    jmp block.501

	.align 16
block.503:
    movq free_ptr(%rip), %r11
    addq $56, free_ptr(%rip)
    movq $25, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -32(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %rbx, 16(%r11)
    movq %rdx, %r11
    movq %r13, 24(%r11)
    movq %rdx, %r11
    movq %r14, 32(%r11)
    movq %rdx, %r11
    movq -8(%rbp), %rax
    movq %rax, 40(%r11)
    movq %rdx, %r11
    movq %r12, 48(%r11)
    movq %rdx, -8(%r15)
    movq $0, %r13
    movq $0, %r14
    movq $0, %rbx
    movq $0, %r12
    movq free_ptr(%rip), %rax
    addq $40, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.501
    jmp block.502

	.align 16
block.504:
    movq %r15, %rdi
    movq $56, %rsi
    callq collect
    jmp block.503

	.align 16
block.505:
    movq free_ptr(%rip), %r11
    addq $56, free_ptr(%rip)
    movq $25, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -16(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %r14, 16(%r11)
    movq %rdx, %r11
    movq %rbx, 24(%r11)
    movq %rdx, %r11
    movq -8(%rbp), %rax
    movq %rax, 32(%r11)
    movq %rdx, %r11
    movq %r13, 40(%r11)
    movq %rdx, %r11
    movq %r12, 48(%r11)
    movq %rdx, -16(%r15)
    movq $2, -32(%rbp)
    movq $1, %rbx
    movq $2, %r13
    movq $0, %r14
    movq $0, -8(%rbp)
    movq $3, %r12
    movq free_ptr(%rip), %rax
    addq $56, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.503
    jmp block.504

	.align 16
block.506:
    movq %r15, %rdi
    movq $56, %rsi
    callq collect
    jmp block.505

	.align 16
start:
    movq $1, -16(%rbp)
    movq $2, %r14
    movq $3, %rbx
    movq $4, -8(%rbp)
    movq $1, %r13
    movq $2, %r12
    movq free_ptr(%rip), %rax
    addq $56, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.505
    jmp block.506

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
    popq %r15
    popq %r12
    popq %r14
    popq %rbx
    popq %r13
    retq 


