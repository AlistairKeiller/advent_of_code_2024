.global compute_safe
compute_safe:
    // Arguments:
    // x0: pointer to array levels
    // x1: size of arrays (num_reports)

    // Prologue
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov x2, 1 // array_index
    mov x3, 3 // increasing flag (3 == safe, 2 == skipping, 1 == skipped, 0 == unsafe)

increasing_loop:
    // check if we are at the end of the array
    cmp x2, x1
    bge decreasing_init

    // load the current and next level
    sub x7, x2, 1
    cmp x3, 2
    bne increasing_skipping
    sub x7, x7, 1
    mov x3, 1

increasing_skipping:
    ldr w5, [x0, x7, lsl #2]
    ldr w6, [x0, x2, lsl #2]

    // Check if 1 <= increasing <= 3
    cmp w5, w6
    bge not_increasing
    mov x7, 0
    sub w8, w6, w5
    cmp w8, 3
    bgt not_increasing
    b increasing

not_increasing:
    sub x3, x3, 1

increasing:
    add x2, x2, 1
    b increasing_loop

decreasing_init:
    mov x2, 1 // array_index
    mov x4, 3 // decreasing flag (3 == safe, 2 == skipping, 1 == skipped, 0 == unsafe)

decreasing_loop:
    // check if we are at the end of the array
    cmp x2, x1
    bge end

    // load the current and next level
    sub x7, x2, 1
    cmp x4, 2
    bne decreasing_skipping
    sub x7, x7, 1
    mov x4, 1

decreasing_skipping:
    ldr w6, [x0, x7, lsl #2]
    ldr w5, [x0, x2, lsl #2]

    // Check if 1 <= decreasing <= 3
    cmp w5, w6
    bge not_decreasing
    mov x7, 0
    sub w8, w6, w5
    cmp w8, 3
    bgt not_decreasing
    b decreasing

not_decreasing:
    sub x4, x4, 1

decreasing:
    add x2, x2, 1
    b decreasing_loop

end:
    mov x0, 1
    cmp x3, 0
    bgt safe
    cmp x4, 0
    bgt safe
    mov x0, 0
safe:
    // Epilogue
    ldp x29, x30, [sp], #16
    ret
