	.align 16
block.524:
    movq %r12, %rdi
    callq print_int
    movq $1, %rax
    addq -8(%rbp), %rax
    movq %rax, -8(%rbp)
    jmp label.523

	.align 16
block.525:
    movq -64(%r15), %r11
    movq -8(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r12
    jmp block.524

	.align 16
block.526:
    movq -72(%r15), %r11
    movq %r14, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -64(%r15)
    jmp block.525

	.align 16
block.527:
    movq $255, %rdi
    callq call_exit
    jmp block.525

	.align 16
block.528:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r14, %rcx
    jg block.526
    jmp block.527

	.align 16
block.529:
    cmpq $0, %r14
    jge block.528
    jmp block.527

	.align 16
block.530:
    movq $255, %rdi
    callq call_exit
    jmp block.524

	.align 16
block.531:
    movq -48(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -8(%rbp), %rcx
    jg block.529
    jmp block.530

	.align 16
block.532:
    movq -72(%r15), %r11
    movq %r14, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -48(%r15)
    jmp block.531

	.align 16
block.533:
    movq $255, %rdi
    callq call_exit
    jmp block.531

	.align 16
block.534:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r14, %rcx
    jg block.532
    jmp block.533

	.align 16
block.535:
    cmpq $0, %r14
    jge block.534
    jmp block.533

	.align 16
block.536:
    cmpq $0, -8(%rbp)
    jge block.535
    jmp block.530

	.align 16
block.537:
    movq $1, %rax
    addq %r14, %rax
    movq %rax, %r14
    jmp label.522

	.align 16
label.523:
    cmpq %r13, -8(%rbp)
    jl block.536
    jmp block.537

	.align 16
block.538:
    movq -104(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %r13
    jmp label.523

	.align 16
block.539:
    movq -72(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -104(%r15)
    jmp block.538

	.align 16
block.540:
    movq $255, %rdi
    callq call_exit
    jmp block.538

	.align 16
block.541:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.539
    jmp block.540

	.align 16
block.542:
    movq $0, -8(%rbp)
    movq $0, %rax
    cmpq $0, %rax
    jge block.541
    jmp block.540

	.align 16
label.522:
    cmpq %rbx, %r14
    jl block.542
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.546:
    movq -80(%r15), %r11
    movq -136(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq -160(%rbp), %rax
    movq %rax, 0(%r11)
    movq $1, %rax
    addq -136(%rbp), %rax
    movq %rax, -136(%rbp)
    jmp label.545

	.align 16
block.547:
    movq -72(%r15), %r11
    movq -128(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -80(%r15)
    jmp block.546

	.align 16
block.548:
    movq $255, %rdi
    callq call_exit
    jmp block.546

	.align 16
block.549:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -128(%rbp), %rcx
    jg block.547
    jmp block.548

	.align 16
block.550:
    cmpq $0, -128(%rbp)
    jge block.549
    jmp block.548

	.align 16
block.551:
    movq $1, %rax
    addq -136(%rbp), %rax
    movq %rax, -136(%rbp)
    jmp label.545

	.align 16
block.552:
    movq -88(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -136(%rbp), %rcx
    jg block.550
    jmp block.551

	.align 16
block.553:
    movq -72(%r15), %r11
    movq -128(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -88(%r15)
    jmp block.552

	.align 16
block.554:
    movq $255, %rdi
    callq call_exit
    jmp block.552

	.align 16
block.555:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -128(%rbp), %rcx
    jg block.553
    jmp block.554

	.align 16
block.556:
    cmpq $0, -128(%rbp)
    jge block.555
    jmp block.554

	.align 16
block.558:
    movq %r13, %rax
    imulq %rbx, %rax
    movq %rax, %rcx
    movq -160(%rbp), %rax
    addq %rcx, %rax
    movq %rax, -160(%rbp)
    movq $1, %rax
    addq -152(%rbp), %rax
    movq %rax, -152(%rbp)
    jmp label.557

	.align 16
block.559:
    movq -96(%r15), %r11
    movq -136(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rbx
    jmp block.558

	.align 16
block.560:
    movq -40(%r15), %r11
    movq -152(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -96(%r15)
    jmp block.559

	.align 16
block.561:
    movq $255, %rdi
    callq call_exit
    jmp block.559

	.align 16
block.562:
    movq -40(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -152(%rbp), %rcx
    jg block.560
    jmp block.561

	.align 16
block.563:
    cmpq $0, -152(%rbp)
    jge block.562
    jmp block.561

	.align 16
block.564:
    movq $255, %rdi
    callq call_exit
    jmp block.558

	.align 16
block.565:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -136(%rbp), %rcx
    jg block.563
    jmp block.564

	.align 16
block.566:
    movq -40(%r15), %r11
    movq -152(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -8(%r15)
    jmp block.565

	.align 16
block.567:
    movq $255, %rdi
    callq call_exit
    jmp block.565

	.align 16
block.568:
    movq -40(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -152(%rbp), %rcx
    jg block.566
    jmp block.567

	.align 16
block.569:
    cmpq $0, -152(%rbp)
    jge block.568
    jmp block.567

	.align 16
block.570:
    cmpq $0, -136(%rbp)
    jge block.569
    jmp block.564

	.align 16
block.571:
    movq -16(%r15), %r11
    movq -152(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r13
    jmp block.570

	.align 16
block.572:
    movq -56(%r15), %r11
    movq -128(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -16(%r15)
    jmp block.571

	.align 16
block.573:
    movq $255, %rdi
    callq call_exit
    jmp block.571

	.align 16
block.574:
    movq -56(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -128(%rbp), %rcx
    jg block.572
    jmp block.573

	.align 16
block.575:
    cmpq $0, -128(%rbp)
    jge block.574
    jmp block.573

	.align 16
block.576:
    movq $255, %rdi
    callq call_exit
    jmp block.570

	.align 16
block.577:
    movq -120(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -152(%rbp), %rcx
    jg block.575
    jmp block.576

	.align 16
block.578:
    movq -56(%r15), %r11
    movq -128(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -120(%r15)
    jmp block.577

	.align 16
block.579:
    movq $255, %rdi
    callq call_exit
    jmp block.577

	.align 16
block.580:
    movq -56(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -128(%rbp), %rcx
    jg block.578
    jmp block.579

	.align 16
block.581:
    cmpq $0, -128(%rbp)
    jge block.580
    jmp block.579

	.align 16
block.582:
    cmpq $0, -152(%rbp)
    jge block.581
    jmp block.576

	.align 16
block.583:
    cmpq $0, -136(%rbp)
    jge block.556
    jmp block.551

	.align 16
label.557:
    movq -144(%rbp), %rax
    cmpq %rax, -152(%rbp)
    jl block.582
    jmp block.583

	.align 16
block.584:
    movq -32(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, -144(%rbp)
    jmp label.557

	.align 16
block.585:
    movq -56(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -32(%r15)
    jmp block.584

	.align 16
block.586:
    movq $255, %rdi
    callq call_exit
    jmp block.584

	.align 16
block.587:
    movq -56(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.585
    jmp block.586

	.align 16
block.588:
    movq $0, -160(%rbp)
    movq $0, -152(%rbp)
    movq $0, %rax
    cmpq $0, %rax
    jge block.587
    jmp block.586

	.align 16
block.589:
    movq $1, %rax
    addq -128(%rbp), %rax
    movq %rax, -128(%rbp)
    jmp label.544

	.align 16
label.545:
    cmpq %r14, -136(%rbp)
    jl block.588
    jmp block.589

	.align 16
block.590:
    movq -112(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %r14
    jmp label.545

	.align 16
block.591:
    movq -40(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -112(%r15)
    jmp block.590

	.align 16
block.592:
    movq $255, %rdi
    callq call_exit
    jmp block.590

	.align 16
block.593:
    movq -40(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.591
    jmp block.592

	.align 16
block.594:
    movq $0, -136(%rbp)
    movq $0, %rax
    cmpq $0, %rax
    jge block.593
    jmp block.592

	.align 16
block.595:
    movq $0, %r14
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rbx
    jmp label.522

	.align 16
label.544:
    movq -24(%rbp), %rax
    cmpq %rax, -128(%rbp)
    jl block.594
    jmp block.595

	.align 16
block.596:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $11, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -24(%r15), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -72(%r15), %rax
    movq %rax, 16(%r11)
    movq %rdx, -72(%r15)
    movq $0, -128(%rbp)
    movq -56(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, -24(%rbp)
    jmp label.544

	.align 16
block.597:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.596

	.align 16
block.598:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r14, 8(%r11)
    movq %rdx, %r11
    movq -72(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rdx, -72(%r15)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.596
    jmp block.597

	.align 16
block.599:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.598

	.align 16
block.600:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -24(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %r14, 16(%r11)
    movq %rdx, -24(%r15)
    movq $0, %r14
    movq $0, -72(%rbp)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.598
    jmp block.599

	.align 16
block.601:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.600

	.align 16
block.602:
    movq free_ptr(%rip), %r11
    addq $32, free_ptr(%rip)
    movq $15, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -24(%r15), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -72(%r15), %rax
    movq %rax, 16(%r11)
    movq %rdx, %r11
    movq -40(%r15), %rax
    movq %rax, 24(%r11)
    movq %rdx, -40(%r15)
    movq $0, -24(%rbp)
    movq $0, %r14
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.600
    jmp block.601

	.align 16
block.603:
    movq %r15, %rdi
    movq $32, %rsi
    callq collect
    jmp block.602

	.align 16
block.604:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r14, 8(%r11)
    movq %rdx, %r11
    movq -40(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rdx, -40(%r15)
    movq free_ptr(%rip), %rax
    addq $32, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.602
    jmp block.603

	.align 16
block.605:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.604

	.align 16
block.606:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -40(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %r14, 16(%r11)
    movq %rdx, -72(%r15)
    movq $0, %r14
    movq $3, -40(%rbp)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.604
    jmp block.605

	.align 16
block.607:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.606

	.align 16
block.608:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -24(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %r14, 16(%r11)
    movq %rdx, -24(%r15)
    movq $2, -40(%rbp)
    movq $0, %r14
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.606
    jmp block.607

	.align 16
block.609:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.608

	.align 16
block.610:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $11, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -24(%r15), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -40(%r15), %rax
    movq %rax, 16(%r11)
    movq %rdx, -56(%r15)
    movq $2, -24(%rbp)
    movq $1, %r14
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.608
    jmp block.609

	.align 16
block.611:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.610

	.align 16
block.612:
    movq free_ptr(%rip), %r11
    addq $32, free_ptr(%rip)
    movq $13, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -56(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -40(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rdx, %r11
    movq %r14, 24(%r11)
    movq %rdx, -40(%r15)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.610
    jmp block.611

	.align 16
block.613:
    movq %r15, %rdi
    movq $32, %rsi
    callq collect
    jmp block.612

	.align 16
block.614:
    movq free_ptr(%rip), %r11
    addq $32, free_ptr(%rip)
    movq $13, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -40(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %r14, 16(%r11)
    movq %rdx, %r11
    movq -24(%rbp), %rax
    movq %rax, 24(%r11)
    movq %rdx, -24(%r15)
    movq $4, -56(%rbp)
    movq $1, -40(%rbp)
    movq $2, %r14
    movq free_ptr(%rip), %rax
    addq $32, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.612
    jmp block.613

	.align 16
block.615:
    movq %r15, %rdi
    movq $32, %rsi
    callq collect
    jmp block.614

	.align 16
main_start:
    movq $1, -40(%rbp)
    movq $2, %r14
    movq $3, -24(%rbp)
    movq free_ptr(%rip), %rax
    addq $32, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.614
    jmp block.615

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
    subq $88, %rsp
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
    subq $15, %r15
    addq $88, %rsp
    popq %rbp
    popq %r15
    popq %r12
    popq %r13
    popq %r14
    popq %rbx
    retq 


