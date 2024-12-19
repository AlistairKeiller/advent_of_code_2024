.global compute_distance
compute_distance:
    // Arguments:
    // x0: pointer to array x
    // x1: pointer to array y
    // x2: size of arrays (n)

    // Prologue
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov x3, #1

bubble_sort_outer:
    cmp x3, x2
    bge loop_init
    mov x4, #1

bubble_sort_inner:
    sub x5, x4, #1
    ldr w6, [x0, x5, lsl #2]
    ldr w7, [x0, x4, lsl #2]
    cmp w6, w7
    bge bubble_sort_skip
    str w7, [x0, x5, lsl #2]
    str w6, [x0, x4, lsl #2]

bubble_sort_skip:
    add x4, x4, #1
    cmp x4, x2
    blt bubble_sort_inner

    add x3, x3, #1
    b bubble_sort_outer

loop_init:
    mov w3, #0 // total count
    mov x4, #0 // loop index

loop_start:
    cmp x4, x2
    bge loop_end

    ldr w5, [x0, x4, lsl #2]
    ldr w6, [x1, x4, lsl #2]

    subs w7, w5, w6
    cneg w7, w7, mi

    add w3, w3, w7

    add x4, x4, 1
    b loop_start

loop_end:
    mov w0, w3

    // Epilogue
    ldp x29, x30, [sp], #16
    ret
