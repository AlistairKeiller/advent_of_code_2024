.global compute_distance
compute_distance:
    // Arguments:
    // x0: pointer to array x
    // x1: pointer to array y
    // x2: size of arrays (n)

    // Prologue
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov w3, #0 // similarity
    mov x4, #0 // i

loop_init:
    cmp x4, x2
    bge loop_end

    ldr w5, [x0, x4, lsl #2]

    mov x6, #0 // j

loop_inner:
    cmp x6, x2
    bge loop_inner_end
    ldr w7, [x1, x6, lsl #2]

    cmp w5, w7
    bne loop_inner_skip
    add w3, w3, w5

loop_inner_skip:
    add x6, x6, #1
    b loop_inner

loop_inner_end:
    add x4, x4, #1
    b loop_init

loop_end:
    mov w0, w3

    // Epilogue
    ldp x29, x30, [sp], #16
    ret
