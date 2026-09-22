	.align 16
block.195:
    movq %r12, %rdi
    callq print_int
    movq $1, %rax
    addq -8(%rbp), %rax
    movq %rax, -8(%rbp)
    jmp label.194

	.align 16
block.196:
    movq -56(%r15), %r11
    movq -8(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r12
    jmp block.195

	.align 16
block.197:
    movq -64(%r15), %r11
    movq %r14, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -56(%r15)
    jmp block.196

	.align 16
block.198:
    movq $255, %rdi
    callq call_exit
    jmp block.196

	.align 16
block.199:
    movq -64(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r14, %rcx
    jg block.197
    jmp block.198

	.align 16
block.200:
    cmpq $0, %r14
    jge block.199
    jmp block.198

	.align 16
block.201:
    movq $255, %rdi
    callq call_exit
    jmp block.195

	.align 16
block.202:
    movq -24(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -8(%rbp), %rcx
    jg block.200
    jmp block.201

	.align 16
block.203:
    movq -64(%r15), %r11
    movq %r14, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -24(%r15)
    jmp block.202

	.align 16
block.204:
    movq $255, %rdi
    callq call_exit
    jmp block.202

	.align 16
block.205:
    movq -64(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r14, %rcx
    jg block.203
    jmp block.204

	.align 16
block.206:
    cmpq $0, %r14
    jge block.205
    jmp block.204

	.align 16
block.207:
    cmpq $0, -8(%rbp)
    jge block.206
    jmp block.201

	.align 16
block.208:
    movq $1, %rax
    addq %r14, %rax
    movq %rax, %r14
    jmp label.193

	.align 16
label.194:
    cmpq %r13, -8(%rbp)
    jl block.207
    jmp block.208

	.align 16
block.209:
    movq -80(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %r13
    jmp label.194

	.align 16
block.210:
    movq -64(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -80(%r15)
    jmp block.209

	.align 16
block.211:
    movq $255, %rdi
    callq call_exit
    jmp block.209

	.align 16
block.212:
    movq -64(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.210
    jmp block.211

	.align 16
block.213:
    movq $0, -8(%rbp)
    movq $0, %rax
    cmpq $0, %rax
    jge block.212
    jmp block.211

	.align 16
block.214:
    movq $0, %rax
    jmp conclusion

	.align 16
label.193:
    cmpq %rbx, %r14
    jl block.213
    jmp block.214

	.align 16
block.217:
    movq -72(%r15), %r11
    movq -136(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq -160(%rbp), %rax
    movq %rax, 0(%r11)
    movq $1, %rax
    addq -136(%rbp), %rax
    movq %rax, -136(%rbp)
    jmp label.216

	.align 16
block.218:
    movq -64(%r15), %r11
    movq %r14, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -72(%r15)
    jmp block.217

	.align 16
block.219:
    movq $255, %rdi
    callq call_exit
    jmp block.217

	.align 16
block.220:
    movq -64(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r14, %rcx
    jg block.218
    jmp block.219

	.align 16
block.221:
    cmpq $0, %r14
    jge block.220
    jmp block.219

	.align 16
block.222:
    movq $1, %rax
    addq -136(%rbp), %rax
    movq %rax, -136(%rbp)
    jmp label.216

	.align 16
block.223:
    movq -8(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -136(%rbp), %rcx
    jg block.221
    jmp block.222

	.align 16
block.224:
    movq -64(%r15), %r11
    movq %r14, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -8(%r15)
    jmp block.223

	.align 16
block.225:
    movq $255, %rdi
    callq call_exit
    jmp block.223

	.align 16
block.226:
    movq -64(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r14, %rcx
    jg block.224
    jmp block.225

	.align 16
block.227:
    cmpq $0, %r14
    jge block.226
    jmp block.225

	.align 16
block.229:
    movq %r13, %rax
    imulq %rbx, %rax
    movq %rax, %rcx
    movq -160(%rbp), %rax
    addq %rcx, %rax
    movq %rax, -160(%rbp)
    movq $1, %rax
    addq -152(%rbp), %rax
    movq %rax, -152(%rbp)
    jmp label.228

	.align 16
block.230:
    movq -120(%r15), %r11
    movq -136(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rbx
    jmp block.229

	.align 16
block.231:
    movq -16(%r15), %r11
    movq -152(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -120(%r15)
    jmp block.230

	.align 16
block.232:
    movq $255, %rdi
    callq call_exit
    jmp block.230

	.align 16
block.233:
    movq -16(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -152(%rbp), %rcx
    jg block.231
    jmp block.232

	.align 16
block.234:
    cmpq $0, -152(%rbp)
    jge block.233
    jmp block.232

	.align 16
block.235:
    movq $255, %rdi
    callq call_exit
    jmp block.229

	.align 16
block.236:
    movq -112(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -136(%rbp), %rcx
    jg block.234
    jmp block.235

	.align 16
block.237:
    movq -16(%r15), %r11
    movq -152(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -112(%r15)
    jmp block.236

	.align 16
block.238:
    movq $255, %rdi
    callq call_exit
    jmp block.236

	.align 16
block.239:
    movq -16(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -152(%rbp), %rcx
    jg block.237
    jmp block.238

	.align 16
block.240:
    cmpq $0, -152(%rbp)
    jge block.239
    jmp block.238

	.align 16
block.241:
    cmpq $0, -136(%rbp)
    jge block.240
    jmp block.235

	.align 16
block.242:
    movq -104(%r15), %r11
    movq -152(%rbp), %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %r13
    jmp block.241

	.align 16
block.243:
    movq -48(%r15), %r11
    movq %r14, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -104(%r15)
    jmp block.242

	.align 16
block.244:
    movq $255, %rdi
    callq call_exit
    jmp block.242

	.align 16
block.245:
    movq -48(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r14, %rcx
    jg block.243
    jmp block.244

	.align 16
block.246:
    cmpq $0, %r14
    jge block.245
    jmp block.244

	.align 16
block.247:
    movq $255, %rdi
    callq call_exit
    jmp block.241

	.align 16
block.248:
    movq -40(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq -152(%rbp), %rcx
    jg block.246
    jmp block.247

	.align 16
block.249:
    movq -48(%r15), %r11
    movq %r14, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -40(%r15)
    jmp block.248

	.align 16
block.250:
    movq $255, %rdi
    callq call_exit
    jmp block.248

	.align 16
block.251:
    movq -48(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq %r14, %rcx
    jg block.249
    jmp block.250

	.align 16
block.252:
    cmpq $0, %r14
    jge block.251
    jmp block.250

	.align 16
block.253:
    cmpq $0, -152(%rbp)
    jge block.252
    jmp block.247

	.align 16
block.254:
    cmpq $0, -136(%rbp)
    jge block.227
    jmp block.222

	.align 16
label.228:
    movq -144(%rbp), %rax
    cmpq %rax, -152(%rbp)
    jl block.253
    jmp block.254

	.align 16
block.255:
    movq -96(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, -144(%rbp)
    jmp label.228

	.align 16
block.256:
    movq -48(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -96(%r15)
    jmp block.255

	.align 16
block.257:
    movq $255, %rdi
    callq call_exit
    jmp block.255

	.align 16
block.258:
    movq -48(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.256
    jmp block.257

	.align 16
block.259:
    movq $0, -160(%rbp)
    movq $0, -152(%rbp)
    movq $0, %rax
    cmpq $0, %rax
    jge block.258
    jmp block.257

	.align 16
block.260:
    movq $1, %rax
    addq %r14, %rax
    movq %rax, %r14
    jmp label.215

	.align 16
label.216:
    movq -32(%rbp), %rax
    cmpq %rax, -136(%rbp)
    jl block.259
    jmp block.260

	.align 16
block.261:
    movq -88(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, -32(%rbp)
    jmp label.216

	.align 16
block.262:
    movq -16(%r15), %r11
    movq $0, %rax
    addq $1, %rax
    imulq $8, %rax
    addq %rax, %r11
    movq 0(%r11), %rcx
    movq %rcx, -88(%r15)
    jmp block.261

	.align 16
block.263:
    movq $255, %rdi
    callq call_exit
    jmp block.261

	.align 16
block.264:
    movq -16(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rcx
    cmpq $0, %rcx
    jg block.262
    jmp block.263

	.align 16
block.265:
    movq $0, -136(%rbp)
    movq $0, %rax
    cmpq $0, %rax
    jge block.264
    jmp block.263

	.align 16
block.266:
    movq $0, %r14
    movq -64(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, %rbx
    jmp label.193

	.align 16
label.215:
    cmpq -128(%rbp), %r14
    jl block.265
    jmp block.266

	.align 16
block.267:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $11, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -64(%r15), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -32(%r15), %rax
    movq %rax, 16(%r11)
    movq %rdx, -64(%r15)
    movq $0, %r14
    movq -48(%r15), %rax
    movq 0(%rax), %rax
    movq $4611686018427387900, %r11
    andq %r11, %rax
    sarq $2, %rax
    movq %rax, -128(%rbp)
    jmp label.215

	.align 16
block.268:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.267

	.align 16
block.269:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r14, 8(%r11)
    movq %rdx, %r11
    movq -32(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rdx, -32(%r15)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.267
    jmp block.268

	.align 16
block.270:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.269

	.align 16
block.271:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -32(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %r14, 16(%r11)
    movq %rdx, -64(%r15)
    movq $0, %r14
    movq $0, -32(%rbp)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.269
    jmp block.270

	.align 16
block.272:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.271

	.align 16
block.273:
    movq free_ptr(%rip), %r11
    addq $32, free_ptr(%rip)
    movq $15, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -16(%r15), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -32(%r15), %rax
    movq %rax, 16(%r11)
    movq %rdx, %r11
    movq -64(%r15), %rax
    movq %rax, 24(%r11)
    movq %rdx, -16(%r15)
    movq $0, -32(%rbp)
    movq $0, %r14
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.271
    jmp block.272

	.align 16
block.274:
    movq %r15, %rdi
    movq $32, %rsi
    callq collect
    jmp block.273

	.align 16
block.275:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq %r14, 8(%r11)
    movq %rdx, %r11
    movq -64(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rdx, -64(%r15)
    movq free_ptr(%rip), %rax
    addq $32, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.273
    jmp block.274

	.align 16
block.276:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.275

	.align 16
block.277:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -32(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %r14, 16(%r11)
    movq %rdx, -32(%r15)
    movq $0, %r14
    movq $3, -64(%rbp)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.275
    jmp block.276

	.align 16
block.278:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.277

	.align 16
block.279:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $9, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -16(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq %r14, 16(%r11)
    movq %rdx, -16(%r15)
    movq $2, -32(%rbp)
    movq $0, %r14
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.277
    jmp block.278

	.align 16
block.280:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.279

	.align 16
block.281:
    movq free_ptr(%rip), %r11
    addq $24, free_ptr(%rip)
    movq $11, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -16(%r15), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -32(%r15), %rax
    movq %rax, 16(%r11)
    movq %rdx, -48(%r15)
    movq $2, -16(%rbp)
    movq $1, %r14
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.279
    jmp block.280

	.align 16
block.282:
    movq %r15, %rdi
    movq $24, %rsi
    callq collect
    jmp block.281

	.align 16
block.283:
    movq free_ptr(%rip), %r11
    addq $32, free_ptr(%rip)
    movq $13, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -48(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -32(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rdx, %r11
    movq %r14, 24(%r11)
    movq %rdx, -32(%r15)
    movq free_ptr(%rip), %rax
    addq $24, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.281
    jmp block.282

	.align 16
block.284:
    movq %r15, %rdi
    movq $32, %rsi
    callq collect
    jmp block.283

	.align 16
block.285:
    movq free_ptr(%rip), %r11
    addq $32, free_ptr(%rip)
    movq $13, 0(%r11)
    movq %r11, %rdx
    movq %rdx, %r11
    movq -32(%rbp), %rax
    movq %rax, 8(%r11)
    movq %rdx, %r11
    movq -16(%rbp), %rax
    movq %rax, 16(%r11)
    movq %rdx, %r11
    movq %r14, 24(%r11)
    movq %rdx, -16(%r15)
    movq $4, -48(%rbp)
    movq $1, -32(%rbp)
    movq $2, %r14
    movq free_ptr(%rip), %rax
    addq $32, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.283
    jmp block.284

	.align 16
block.286:
    movq %r15, %rdi
    movq $32, %rsi
    callq collect
    jmp block.285

	.align 16
start:
    movq $1, -32(%rbp)
    movq $2, -16(%rbp)
    movq $3, %r14
    movq free_ptr(%rip), %rax
    addq $32, %rax
    movq %rax, %rcx
    cmpq fromspace_end(%rip), %rcx
    jl block.285
    jmp block.286

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
    jmp start

	.align 16
conclusion:
    subq $15, %r15
    addq $88, %rsp
    popq %rbp
    popq %r12
    popq %r15
    popq %rbx
    popq %r13
    popq %r14
    retq 


