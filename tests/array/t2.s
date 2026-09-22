	.align 16
block.338:
    movq %rcx, %rdi
    callq print_int
    movq $0, %rax
    jmp conclusion

	.align 16
block.339:
    movq %r12, %rax
    imulq -16(%rbp), %rax
    movq %rax, %rcx
    movq %r13, %rax
    subq %rcx, %rax
    movq %rax, %rcx
    jmp block.338

	.align 16
block.340:
    movq -16(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -16(%rbp)
    jmp block.339

	.align 16
block.341:
    movq %rbx, %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -16(%r15)
    jmp block.340

	.align 16
block.342:
    movq $255, %rdi
    callq call_exit
    jmp block.340

	.align 16
block.343:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.341
    jmp block.342

	.align 16
block.344:
    movq $1, %rax
    cmpq $0, %rax
    jge block.343
    jmp block.342

	.align 16
block.345:
    movq $255, %rdi
    callq call_exit
    jmp block.339

	.align 16
block.346:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.344
    jmp block.345

	.align 16
block.347:
    movq %rbx, %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -72(%r15)
    jmp block.346

	.align 16
block.348:
    movq $255, %rdi
    callq call_exit
    jmp block.346

	.align 16
block.349:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.347
    jmp block.348

	.align 16
block.350:
    movq $1, %rax
    cmpq $0, %rax
    jge block.349
    jmp block.348

	.align 16
block.351:
    movq $0, %rax
    cmpq $0, %rax
    jge block.350
    jmp block.345

	.align 16
block.352:
    movq -24(%r15), %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r12
    jmp block.351

	.align 16
block.353:
    movq %rbx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -24(%r15)
    jmp block.352

	.align 16
block.354:
    movq $255, %rdi
    callq call_exit
    jmp block.352

	.align 16
block.355:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.353
    jmp block.354

	.align 16
block.356:
    movq $0, %rax
    cmpq $0, %rax
    jge block.355
    jmp block.354

	.align 16
block.357:
    movq $255, %rdi
    callq call_exit
    jmp block.351

	.align 16
block.358:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.356
    jmp block.357

	.align 16
block.359:
    movq %rbx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -8(%r15)
    jmp block.358

	.align 16
block.360:
    movq $255, %rdi
    callq call_exit
    jmp block.358

	.align 16
block.361:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.359
    jmp block.360

	.align 16
block.362:
    movq $0, %rax
    cmpq $0, %rax
    jge block.361
    jmp block.360

	.align 16
block.363:
    movq -48(%rbp), %rax
    imulq %r14, %rax
    movq %rax, %r13
    movq $1, %rax
    cmpq $0, %rax
    jge block.362
    jmp block.357

	.align 16
block.364:
    movq -32(%r15), %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r14
    jmp block.363

	.align 16
block.365:
    movq %rbx, %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -32(%r15)
    jmp block.364

	.align 16
block.366:
    movq $255, %rdi
    callq call_exit
    jmp block.364

	.align 16
block.367:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.365
    jmp block.366

	.align 16
block.368:
    movq $1, %rax
    cmpq $0, %rax
    jge block.367
    jmp block.366

	.align 16
block.369:
    movq $255, %rdi
    callq call_exit
    jmp block.363

	.align 16
block.370:
    movq -40(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.368
    jmp block.369

	.align 16
block.371:
    movq %rbx, %r11
    movq $1, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -40(%r15)
    jmp block.370

	.align 16
block.372:
    movq $255, %rdi
    callq call_exit
    jmp block.370

	.align 16
block.373:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $1, %rcx
    jg block.371
    jmp block.372

	.align 16
block.374:
    movq $1, %rax
    cmpq $0, %rax
    jge block.373
    jmp block.372

	.align 16
block.375:
    movq $1, %rax
    cmpq $0, %rax
    jge block.374
    jmp block.369

	.align 16
block.376:
    movq -48(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -48(%rbp)
    jmp block.375

	.align 16
block.377:
    movq %rbx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -48(%r15)
    jmp block.376

	.align 16
block.378:
    movq $255, %rdi
    callq call_exit
    jmp block.376

	.align 16
block.379:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.377
    jmp block.378

	.align 16
block.380:
    movq $0, %rax
    cmpq $0, %rax
    jge block.379
    jmp block.378

	.align 16
block.381:
    movq $255, %rdi
    callq call_exit
    jmp block.375

	.align 16
block.382:
    movq -56(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.380
    jmp block.381

	.align 16
block.383:
    movq %rbx, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -56(%r15)
    jmp block.382

	.align 16
block.384:
    movq $255, %rdi
    callq call_exit
    jmp block.382

	.align 16
block.385:
    movq %rbx, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.383
    jmp block.384

	.align 16
block.386:
    movq $0, %rax
    cmpq $0, %rax
    jge block.385
    jmp block.384

	.align 16
block.387:
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
    jge block.386
    jmp block.381

	.align 16
block.388:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.387

	.align 16
block.389:
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
    jl block.387
    jmp block.388

	.align 16
block.390:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.389

	.align 16
block.391:
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
    jl block.389
    jmp block.390

	.align 16
block.392:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.391

	.align 16
start:
    movq $1, %r13
    movq $2, %rbx
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.391
    jmp block.392

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
    jmp start

	.align 16
conclusion:
    subq $10, %r15
    addq $24, %rsp
    popq %rbp
    popq %r12
    popq %r15
    popq %rbx
    popq %r13
    popq %r14
    retq 


