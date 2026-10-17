	.align 16
block.668:
    movq %r14, %rax
    imulq -16(%rbp), %rax
    movq %rax, %rcx
    movq %r12, %rax
    subq %rcx, %rax
    movq %rax, %rcx
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.669:
    movq -16(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -16(%rbp)
    jmp block.668

	.align 16
block.670:
    movq %rbx, %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -16(%r15)
    jmp block.669

	.align 16
block.671:
    movq $255, %rdi
    callq call_exit
    jmp block.669

	.align 16
block.672:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.670
    jmp block.671

	.align 16
block.673:
    movq $1, %rax
    cmpq $0, %rax
    jge block.672
    jmp block.671

	.align 16
block.674:
    movq $255, %rdi
    callq call_exit
    jmp block.668

	.align 16
block.675:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.673
    jmp block.674

	.align 16
block.676:
    movq %rbx, %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -72(%r15)
    jmp block.675

	.align 16
block.677:
    movq $255, %rdi
    callq call_exit
    jmp block.675

	.align 16
block.678:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.676
    jmp block.677

	.align 16
block.679:
    movq $1, %rax
    cmpq $0, %rax
    jge block.678
    jmp block.677

	.align 16
block.680:
    movq $0, %rax
    cmpq $0, %rax
    jge block.679
    jmp block.674

	.align 16
block.681:
    movq -24(%r15), %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r14
    jmp block.680

	.align 16
block.682:
    movq %rbx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -24(%r15)
    jmp block.681

	.align 16
block.683:
    movq $255, %rdi
    callq call_exit
    jmp block.681

	.align 16
block.684:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.682
    jmp block.683

	.align 16
block.685:
    movq $0, %rax
    cmpq $0, %rax
    jge block.684
    jmp block.683

	.align 16
block.686:
    movq $255, %rdi
    callq call_exit
    jmp block.680

	.align 16
block.687:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.685
    jmp block.686

	.align 16
block.688:
    movq %rbx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -8(%r15)
    jmp block.687

	.align 16
block.689:
    movq $255, %rdi
    callq call_exit
    jmp block.687

	.align 16
block.690:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.688
    jmp block.689

	.align 16
block.691:
    movq $0, %rax
    cmpq $0, %rax
    jge block.690
    jmp block.689

	.align 16
block.692:
    movq -48(%rbp), %rax
    imulq %r12, %rax
    movq %rax, %r12
    movq $1, %rax
    cmpq $0, %rax
    jge block.691
    jmp block.686

	.align 16
block.693:
    movq -32(%r15), %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r12
    jmp block.692

	.align 16
block.694:
    movq %rbx, %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -32(%r15)
    jmp block.693

	.align 16
block.695:
    movq $255, %rdi
    callq call_exit
    jmp block.693

	.align 16
block.696:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.694
    jmp block.695

	.align 16
block.697:
    movq $1, %rax
    cmpq $0, %rax
    jge block.696
    jmp block.695

	.align 16
block.698:
    movq $255, %rdi
    callq call_exit
    jmp block.692

	.align 16
block.699:
    movq -40(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.697
    jmp block.698

	.align 16
block.700:
    movq %rbx, %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -40(%r15)
    jmp block.699

	.align 16
block.701:
    movq $255, %rdi
    callq call_exit
    jmp block.699

	.align 16
block.702:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.700
    jmp block.701

	.align 16
block.703:
    movq $1, %rax
    cmpq $0, %rax
    jge block.702
    jmp block.701

	.align 16
block.704:
    movq $1, %rax
    cmpq $0, %rax
    jge block.703
    jmp block.698

	.align 16
block.705:
    movq -48(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -48(%rbp)
    jmp block.704

	.align 16
block.706:
    movq %rbx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -48(%r15)
    jmp block.705

	.align 16
block.707:
    movq $255, %rdi
    callq call_exit
    jmp block.705

	.align 16
block.708:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.706
    jmp block.707

	.align 16
block.709:
    movq $0, %rax
    cmpq $0, %rax
    jge block.708
    jmp block.707

	.align 16
block.710:
    movq $255, %rdi
    callq call_exit
    jmp block.704

	.align 16
block.711:
    movq -56(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.709
    jmp block.710

	.align 16
block.712:
    movq %rbx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -56(%r15)
    jmp block.711

	.align 16
block.713:
    movq $255, %rdi
    callq call_exit
    jmp block.711

	.align 16
block.714:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.712
    jmp block.713

	.align 16
block.715:
    movq $0, %rax
    cmpq $0, %rax
    jge block.714
    jmp block.713

	.align 16
block.716:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $11, 0(%r11)
    movq %r11, %rbx
    movq %rbx, %r11
    movq -80(%r15), %rax
    movq %rax, 8(%r11)
    movq %rbx, %r11
    movq -64(%r15), %rax
    movq %rax, 16(%r11)
    movq $0, %rax
    cmpq $0, %rax
    jge block.715
    jmp block.710

	.align 16
block.718:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r13, 8(%r11)
    movq %rdx, %r11
    movq %rbx, 16(%r11)
    movq %rdx, -64(%r15)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.716
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.716

	.align 16
block.720:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r13, 8(%r11)
    movq %rdx, %r11
    movq %rbx, 16(%r11)
    movq %rdx, -80(%r15)
    movq $3, %r13
    movq $4, %rbx
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.718
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.718

	.align 16
main_start:
    movq $1, %r13
    movq $2, %rbx
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.720
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.720

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
    subq $24, %rsp
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
    movq $0, 0(%r15)
    addq $8, %r15
    movq $0, 0(%r15)
    addq $8, %r15
    movq $0, 0(%r15)
    addq $8, %r15
    movq $0, 0(%r15)
    addq $8, %r15
    movq $0, 0(%r15)
    addq $8, %r15
    movq $0, 0(%r15)
    addq $8, %r15
    movq $0, 0(%r15)
    addq $8, %r15
    jmp main_start

	.align 16
main_conclusion:
    subq $10, %r15
    addq $24, %rsp
    popq %rbp
    popq %r15
    popq %r12
    popq %r13
    popq %r14
    popq %rbx
    retq 


