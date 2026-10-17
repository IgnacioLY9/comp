	.align 16
block.190:
    movq -96(%r15), %r11
    movq -120(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq %r13, 0(%r11)
    movq $1, %rax
    addq -120(%rbp), %rax
    movq %rax, -120(%rbp)
    jmp label.189

	.align 16
block.191:
    movq -88(%r15), %r11
    movq -104(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -96(%r15)
    jmp block.190

	.align 16
block.192:
    movq $255, %rdi
    callq call_exit
    jmp block.190

	.align 16
block.193:
    movq -88(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -104(%rbp), %rcx
    jg block.191
    jmp block.192

	.align 16
block.194:
    cmpq $0, -104(%rbp)
    jge block.193
    jmp block.192

	.align 16
block.195:
    movq $1, %rax
    addq -120(%rbp), %rax
    movq %rax, -120(%rbp)
    jmp label.189

	.align 16
block.196:
    movq -24(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -120(%rbp), %rcx
    jg block.194
    jmp block.195

	.align 16
block.197:
    movq -88(%r15), %r11
    movq -104(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -24(%r15)
    jmp block.196

	.align 16
block.198:
    movq $255, %rdi
    callq call_exit
    jmp block.196

	.align 16
block.199:
    movq -88(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -104(%rbp), %rcx
    jg block.197
    jmp block.198

	.align 16
block.200:
    cmpq $0, -104(%rbp)
    jge block.199
    jmp block.198

	.align 16
block.202:
    movq %rbx, %rax
    imulq %r12, %rax
    movq %rax, %rcx
    movq %r13, %rax
    addq %rcx, %rax
    movq %rax, %r13
    movq $1, %rax
    addq -128(%rbp), %rax
    movq %rax, -128(%rbp)
    jmp label.201

	.align 16
block.203:
    movq -56(%r15), %r11
    movq -120(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r12
    jmp block.202

	.align 16
block.204:
    movq -48(%r15), %r11
    movq -128(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -56(%r15)
    jmp block.203

	.align 16
block.205:
    movq $255, %rdi
    callq call_exit
    jmp block.203

	.align 16
block.206:
    movq -48(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -128(%rbp), %rcx
    jg block.204
    jmp block.205

	.align 16
block.207:
    cmpq $0, -128(%rbp)
    jge block.206
    jmp block.205

	.align 16
block.208:
    movq $255, %rdi
    callq call_exit
    jmp block.202

	.align 16
block.209:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -120(%rbp), %rcx
    jg block.207
    jmp block.208

	.align 16
block.210:
    movq -48(%r15), %r11
    movq -128(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -8(%r15)
    jmp block.209

	.align 16
block.211:
    movq $255, %rdi
    callq call_exit
    jmp block.209

	.align 16
block.212:
    movq -48(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -128(%rbp), %rcx
    jg block.210
    jmp block.211

	.align 16
block.213:
    cmpq $0, -128(%rbp)
    jge block.212
    jmp block.211

	.align 16
block.214:
    cmpq $0, -120(%rbp)
    jge block.213
    jmp block.208

	.align 16
block.215:
    movq -64(%r15), %r11
    movq -128(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rbx
    jmp block.214

	.align 16
block.216:
    movq -40(%r15), %r11
    movq -104(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -64(%r15)
    jmp block.215

	.align 16
block.217:
    movq $255, %rdi
    callq call_exit
    jmp block.215

	.align 16
block.218:
    movq -40(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -104(%rbp), %rcx
    jg block.216
    jmp block.217

	.align 16
block.219:
    cmpq $0, -104(%rbp)
    jge block.218
    jmp block.217

	.align 16
block.220:
    movq $255, %rdi
    callq call_exit
    jmp block.214

	.align 16
block.221:
    movq -16(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -128(%rbp), %rcx
    jg block.219
    jmp block.220

	.align 16
block.222:
    movq -40(%r15), %r11
    movq -104(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -16(%r15)
    jmp block.221

	.align 16
block.223:
    movq $255, %rdi
    callq call_exit
    jmp block.221

	.align 16
block.224:
    movq -40(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -104(%rbp), %rcx
    jg block.222
    jmp block.223

	.align 16
block.225:
    cmpq $0, -104(%rbp)
    jge block.224
    jmp block.223

	.align 16
block.226:
    cmpq $0, -128(%rbp)
    jge block.225
    jmp block.220

	.align 16
block.227:
    cmpq $0, -120(%rbp)
    jge block.200
    jmp block.195

	.align 16
label.201:
    movq -112(%rbp), %rax
    cmpq %rax, -128(%rbp)
    jl block.226
    jmp block.227

	.align 16
block.228:
    movq -80(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, -112(%rbp)
    jmp label.201

	.align 16
block.229:
    movq -40(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -80(%r15)
    jmp block.228

	.align 16
block.230:
    movq $255, %rdi
    callq call_exit
    jmp block.228

	.align 16
block.231:
    movq -40(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.229
    jmp block.230

	.align 16
block.232:
    movq $0, %r13
    movq $0, -128(%rbp)
    movq $0, %rax
    cmpq $0, %rax
    jge block.231
    jmp block.230

	.align 16
block.233:
    movq $1, %rax
    addq -104(%rbp), %rax
    movq %rax, -104(%rbp)
    jmp label.188

	.align 16
label.189:
    movq -32(%rbp), %rax
    cmpq %rax, -120(%rbp)
    jl block.232
    jmp block.233

	.align 16
block.234:
    movq -72(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, -32(%rbp)
    jmp label.189

	.align 16
block.235:
    movq -48(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -72(%r15)
    jmp block.234

	.align 16
block.236:
    movq $255, %rdi
    callq call_exit
    jmp block.234

	.align 16
block.237:
    movq -48(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.235
    jmp block.236

	.align 16
block.238:
    movq $0, -120(%rbp)
    movq $0, %rax
    cmpq $0, %rax
    jge block.237
    jmp block.236

	.align 16
label.188:
    cmpq %r14, -104(%rbp)
    jl block.238
    movq -88(%r15), %rax
    jmp twoByTwoGEMM_conclusion

	.align 16
block.240:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $11, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -32(%r15), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -88(%r15), %rax
    movq %rax, 16(%r11)
    movq %rdx, -88(%r15)
    movq $0, -104(%rbp)
    movq -40(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %r14
    jmp label.188

	.align 16
block.241:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.240

	.align 16
block.242:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r14, 8(%r11)
    movq %rdx, %r11
    movq %r13, 16(%r11)
    movq %rdx, -88(%r15)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.240
    jmp block.241

	.align 16
block.243:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.242

	.align 16
block.244:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r13, 8(%r11)
    movq %rdx, %r11
    movq %r14, 16(%r11)
    movq %rdx, -32(%r15)
    movq $0, %r14
    movq $0, %r13
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.242
    jmp block.243

	.align 16
block.245:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.244

	.align 16
twoByTwoGEMM_start:
    movq %rdi, -40(%r15)
    movq %rsi, -48(%r15)
    movq $0, %r13
    movq $0, %r14
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.244
    jmp block.245

	.align 16
twoByTwoGEMM:
    pushq %rbx
    pushq %r14
    pushq %r13
    pushq %r12
    pushq %r15
    pushq %rbp
    movq %rsp, %rbp
    subq $40, %rsp
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
    jmp twoByTwoGEMM_start

	.align 16
twoByTwoGEMM_conclusion:
    subq $12, %r15
    addq $40, %rsp
    popq %rbp
    popq %r15
    popq %r12
    popq %r13
    popq %r14
    popq %rbx
    retq 

	.align 16
block.248:
    movq %rbx, %rdi
    callq print_int
    movq $1, %rax
    addq -24(%rbp), %rax
    movq %rax, -24(%rbp)
    jmp label.247

	.align 16
block.249:
    movq -32(%r15), %r11
    movq -24(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rbx
    jmp block.248

	.align 16
block.250:
    movq %r14, %r11
    movq %r12, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -32(%r15)
    jmp block.249

	.align 16
block.251:
    movq $255, %rdi
    callq call_exit
    jmp block.249

	.align 16
block.252:
    movq %r14, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r12, %rcx
    jg block.250
    jmp block.251

	.align 16
block.253:
    cmpq $0, %r12
    jge block.252
    jmp block.251

	.align 16
block.254:
    movq $255, %rdi
    callq call_exit
    jmp block.248

	.align 16
block.255:
    movq -16(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -24(%rbp), %rcx
    jg block.253
    jmp block.254

	.align 16
block.256:
    movq %r14, %r11
    movq %r12, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -16(%r15)
    jmp block.255

	.align 16
block.257:
    movq $255, %rdi
    callq call_exit
    jmp block.255

	.align 16
block.258:
    movq %r14, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r12, %rcx
    jg block.256
    jmp block.257

	.align 16
block.259:
    cmpq $0, %r12
    jge block.258
    jmp block.257

	.align 16
block.260:
    cmpq $0, -24(%rbp)
    jge block.259
    jmp block.254

	.align 16
block.261:
    movq $1, %rax
    addq %r12, %rax
    movq %rax, %r12
    jmp label.246

	.align 16
label.247:
    cmpq %r13, -24(%rbp)
    jl block.260
    jmp block.261

	.align 16
block.262:
    movq -48(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %r13
    jmp label.247

	.align 16
block.263:
    movq %r14, %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -48(%r15)
    jmp block.262

	.align 16
block.264:
    movq $255, %rdi
    callq call_exit
    jmp block.262

	.align 16
block.265:
    movq %r14, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.263
    jmp block.264

	.align 16
block.266:
    movq $0, -24(%rbp)
    movq $0, %rax
    cmpq $0, %rax
    jge block.265
    jmp block.264

	.align 16
label.246:
    cmpq -8(%rbp), %r12
    jl block.266
    movq $0, %rax
    jmp main_conclusion

	.align 16
block.268:
    movq free_ptr(%rip), %r11
    addq $32, free_ptr(%rip)
    movq $15, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -40(%r15), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -8(%r15), %rax
    movq %rax, 16(%r11)
    movq %rdx, %r11
    movq -56(%r15), %rax
    movq %rax, 24(%r11)
    leaq twoByTwoGEMM(%rip), %rcx
    movq -24(%r15), %rdi
    movq %rdx, %rsi
    callq *%rcx
    movq %rax, %r14
    movq $0, %r12
    movq %r14, %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, -8(%rbp)
    jmp label.246

	.align 16
block.269:
    movq %r15, %rdi
    movq $32, %rsi
    callq collect
    jmp block.268

	.align 16
block.270:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r13, 8(%r11)
    movq %rdx, %r11
    movq %r12, 16(%r11)
    movq %rdx, -56(%r15)
    movq free_ptr(%rip), %rax
    addq $32, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.268
    jmp block.269

	.align 16
block.271:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.270

	.align 16
block.272:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r13, 8(%r11)
    movq %rdx, %r11
    movq %r12, 16(%r11)
    movq %rdx, -8(%r15)
    movq $0, %r13
    movq $3, %r12
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.270
    jmp block.271

	.align 16
block.273:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.272

	.align 16
block.274:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r13, 8(%r11)
    movq %rdx, %r11
    movq %r12, 16(%r11)
    movq %rdx, -40(%r15)
    movq $2, %r13
    movq $0, %r12
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.272
    jmp block.273

	.align 16
block.275:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.274

	.align 16
block.276:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $11, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -8(%r15), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -24(%r15), %rax
    movq %rax, 16(%r11)
    movq %rdx, -24(%r15)
    movq $2, %r13
    movq $1, %r12
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.274
    jmp block.275

	.align 16
block.277:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.276

	.align 16
block.278:
    movq free_ptr(%rip), %r11
    addq $32, free_ptr(%rip)
    movq $13, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r14, 8(%r11)
    movq %rdx, %r11
    movq %r12, 16(%r11)
    movq %rdx, %r11
    movq %r13, 24(%r11)
    movq %rdx, -24(%r15)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.276
    jmp block.277

	.align 16
block.279:
    movq %r15, %rdi
    movq $32, %rsi
    callq collect
    jmp block.278

	.align 16
block.280:
    movq free_ptr(%rip), %r11
    addq $32, free_ptr(%rip)
    movq $13, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r14, 8(%r11)
    movq %rdx, %r11
    movq %r13, 16(%r11)
    movq %rdx, %r11
    movq %r12, 24(%r11)
    movq %rdx, -8(%r15)
    movq $4, %r14
    movq $1, %r12
    movq $2, %r13
    movq free_ptr(%rip), %rax
    addq $32, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.278
    jmp block.279

	.align 16
block.281:
    movq %r15, %rdi
    movq $32, %rsi
    callq collect
    jmp block.280

	.align 16
main_start:
    movq $1, %r14
    movq $2, %r13
    movq $3, %r12
    movq free_ptr(%rip), %rax
    addq $32, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.280
    jmp block.281

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
    jmp main_start

	.align 16
main_conclusion:
    subq $7, %r15
    addq $24, %rsp
    popq %rbp
    popq %r15
    popq %r12
    popq %r13
    popq %r14
    popq %rbx
    retq 


