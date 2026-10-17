	.align 16
block.803:
    movq -24(%rbp), %rdi
    callq print_int
    movq $1, %rax
    addq %rbx, %rax
    movq %rax, %rbx
    jmp label.802

	.align 16
block.804:
    movq %r13, %r11
    movq %rbx, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -24(%rbp)
    jmp block.803

	.align 16
block.805:
    movq $255, %rdi
    callq call_exit
    jmp block.803

	.align 16
block.806:
    movq %r13, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %rbx, %rcx
    jg block.804
    jmp block.805

	.align 16
block.807:
    cmpq $0, %rbx
    jge block.806
    jmp block.805

	.align 16
label.802:
    cmpq %r12, %rbx
    jl block.807
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.811:
    movq %r13, %r11
    movq %rcx, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq -120(%rbp), %rax
    movq %rax, 0(%r11)
    movq $1, %rax
    addq -112(%rbp), %rax
    movq %rax, -112(%rbp)
    jmp label.810

	.align 16
block.812:
    movq -72(%rbp), %rax
    imulq %r12, %rax
    movq %rax, %rdx
    movq -112(%rbp), %rax
    imulq -56(%rbp), %rax
    movq %rax, %rcx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    jmp block.811

	.align 16
block.813:
    movq $1, %rax
    addq -112(%rbp), %rax
    movq %rax, -112(%rbp)
    jmp label.810

	.align 16
block.814:
    movq %r13, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    movq -72(%rbp), %rax
    imulq %r12, %rax
    movq %rax, %rsi
    movq -112(%rbp), %rax
    imulq -56(%rbp), %rax
    movq %rax, %rdx
    movq %rsi, %rax
    addq %rdx, %rax
    movq %rax, %rdx
    cmpq %rdx, %rcx
    jg block.812
    jmp block.813

	.align 16
block.816:
    movq -96(%rbp), %rax
    imulq -40(%rbp), %rax
    movq %rax, %rcx
    movq -120(%rbp), %rax
    addq %rcx, %rax
    movq %rax, -120(%rbp)
    movq $1, %rax
    addq -104(%rbp), %rax
    movq %rax, -104(%rbp)
    jmp label.815

	.align 16
block.817:
    movq -112(%rbp), %rax
    imulq %rbx, %rax
    movq %rax, %rdx
    movq -104(%rbp), %rax
    imulq -64(%rbp), %rax
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
    movq %rcx, -40(%rbp)
    jmp block.816

	.align 16
block.818:
    movq $255, %rdi
    callq call_exit
    jmp block.816

	.align 16
block.819:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rdx
    movq -112(%rbp), %rax
    imulq %rbx, %rax
    movq %rax, %rsi
    movq -104(%rbp), %rax
    imulq -64(%rbp), %rax
    movq %rax, %rcx
    movq %rsi, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    cmpq %rcx, %rdx
    jg block.817
    jmp block.818

	.align 16
block.820:
    movq -112(%rbp), %rax
    imulq %rbx, %rax
    movq %rax, %rdx
    movq -104(%rbp), %rax
    imulq -64(%rbp), %rax
    movq %rax, %rcx
    movq %rdx, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jge block.819
    jmp block.818

	.align 16
block.821:
    movq -72(%rbp), %rax
    imulq -32(%rbp), %rax
    movq %rax, %rcx
    movq -104(%rbp), %rax
    imulq -88(%rbp), %rax
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
    movq %rcx, -96(%rbp)
    jmp block.820

	.align 16
block.822:
    movq $255, %rdi
    callq call_exit
    jmp block.820

	.align 16
block.823:
    movq -16(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rdx
    movq -72(%rbp), %rax
    imulq -32(%rbp), %rax
    movq %rax, %rsi
    movq -104(%rbp), %rax
    imulq -88(%rbp), %rax
    movq %rax, %rcx
    movq %rsi, %rax
    addq %rcx, %rax
    movq %rax, %rcx
    cmpq %rcx, %rdx
    jg block.821
    jmp block.822

	.align 16
block.824:
    movq -72(%rbp), %rax
    imulq -32(%rbp), %rax
    movq %rax, %rcx
    movq -104(%rbp), %rax
    imulq -88(%rbp), %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jge block.823
    jmp block.822

	.align 16
block.825:
    movq -72(%rbp), %rax
    imulq %r12, %rax
    movq %rax, %rcx
    movq -112(%rbp), %rax
    imulq -56(%rbp), %rax
    movq %rax, %rdx
    movq %rcx, %rax
    addq %rdx, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jge block.814
    jmp block.813

	.align 16
label.815:
    movq -48(%rbp), %rax
    cmpq %rax, -104(%rbp)
    jl block.824
    jmp block.825

	.align 16
block.826:
    movq $0, -120(%rbp)
    movq $0, -104(%rbp)
    jmp label.815

	.align 16
block.827:
    movq $1, %rax
    addq -72(%rbp), %rax
    movq %rax, -72(%rbp)
    jmp label.809

	.align 16
label.810:
    cmpq %r14, -112(%rbp)
    jl block.826
    jmp block.827

	.align 16
block.828:
    movq $0, -112(%rbp)
    jmp label.810

	.align 16
block.829:
    movq $0, %rbx
    movq %r13, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %r12
    jmp label.802

	.align 16
label.809:
    movq -80(%rbp), %rax
    cmpq %rax, -72(%rbp)
    jl block.828
    jmp block.829

	.align 16
block.830:
    movq free_ptr(%rip), %r11
    addq $40, free_ptr(%rip)
    movq $17, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r14, 8(%r11)
    movq %rdx, %r11
    movq %rbx, 16(%r11)
    movq %rdx, %r11
    movq %r13, 24(%r11)
    movq %rdx, %r11
    movq %r12, 32(%r11)
    movq %rdx, %r13
    movq $2, -80(%rbp)
    movq $3, -48(%rbp)
    movq $3, -32(%rbp)
    movq $1, -88(%rbp)
    movq $3, %rcx
    movq $2, %r14
    movq $2, -64(%rbp)
    movq $1, %rbx
    movq $2, %rcx
    movq $2, %rcx
    movq $2, %r12
    movq $1, -56(%rbp)
    movq $0, -72(%rbp)
    jmp label.809

	.align 16
block.831:
    movq %r15, %rdi
    movq $40, %rsi
    callq collect
    jmp block.830

	.align 16
block.832:
    movq free_ptr(%rip), %r11
    addq $56, free_ptr(%rip)
    movq $25, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r13, 8(%r11)
    movq %rdx, %r11
    movq -32(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rdx, %r11
    movq %rbx, 24(%r11)
    movq %rdx, %r11
    movq %r14, 32(%r11)
    movq %rdx, %r11
    movq %r12, 40(%r11)
    movq %rdx, %r11
    movq -8(%rbp), %rax
    movq %rax, 48(%r11)
    movq %rdx, -8(%r15)
    movq $0, %r14
    movq $0, %rbx
    movq $0, %r13
    movq $0, %r12
    movq free_ptr(%rip), %rax
    addq $40, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.830
    jmp block.831

	.align 16
block.833:
    movq %r15, %rdi
    movq $56, %rsi
    callq collect
    jmp block.832

	.align 16
block.834:
    movq free_ptr(%rip), %r11
    addq $56, free_ptr(%rip)
    movq $25, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -16(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %r13, 16(%r11)
    movq %rdx, %r11
    movq %rbx, 24(%r11)
    movq %rdx, %r11
    movq -8(%rbp), %rax
    movq %rax, 32(%r11)
    movq %rdx, %r11
    movq %r14, 40(%r11)
    movq %rdx, %r11
    movq %r12, 48(%r11)
    movq %rdx, -16(%r15)
    movq $2, %r13
    movq $1, -32(%rbp)
    movq $2, %rbx
    movq $0, %r14
    movq $0, %r12
    movq $3, -8(%rbp)
    movq free_ptr(%rip), %rax
    addq $56, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.832
    jmp block.833

	.align 16
block.835:
    movq %r15, %rdi
    movq $56, %rsi
    callq collect
    jmp block.834

	.align 16
main_start:
    movq $1, -16(%rbp)
    movq $2, %r13
    movq $3, %rbx
    movq $4, -8(%rbp)
    movq $1, %r14
    movq $2, %r12
    movq free_ptr(%rip), %rax
    addq $56, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.834
    jmp block.835

	.globl main
	.align 16
main:
    pushq %rbx
    pushq %r14
    pushq %r13
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
    jmp main_start

	.align 16
main_conclusion:
    subq $2, %r15
    addq $120, %rsp
    popq %rbp
    popq %r15
    popq %r12
    popq %r13
    popq %r14
    popq %rbx
    retq 


