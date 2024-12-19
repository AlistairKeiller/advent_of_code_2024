.global compute_distance
compute_distance:
    // Arguments:
    // x0: pointer to array x
    // x1: pointer to array y
    // x2: size of arrays (n)

    // Prologue
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov w3, 0 // total count
    mov x4, 0 // loop index
loop_start:
    cmp x4, x2
    bge loop_end

    ldr w5, [x0, x4, lsl #2]
    ldr w6, [x1, x4, lsl #2]

    subs w5, w5, w6
    cneg w7, w7, mi

    add w3, w3, w7

    add x4, x4, 1
    b loop_start
loop_end:
    mov w0, w3

    // Epilogue
    ldp x29, x30, [sp], #16
    ret
