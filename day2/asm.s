.global compute_safe
compute_safe:
    // Arguments:
    // x0: pointer to array reports
    // x1: size of arrays (num_reports)

    // Prologue
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov x3, 0 // safe_reports_counter
    mov x4, 0 // array_index

loop_init:
    mov x5, 1 // increasing flag
    mov x6, 1 // decreasing flag
    mov x7, 1 // max gap of 3 flag

loop_iter:
    // check if we are at the end of the array
    add x10, x4, 1
    cmp x10, x1
    bge loop_end

    // load the current and next report
    ldr w8, [x0, x4, lsl #2]
    ldr w9, [x0, x10, lsl #2]

    // check if we are at the end of the section
    cmp w9, -1
    beq new_line

    // Check if increasing
    cmp w9, w8
    bgt increasing_skip
    mov x5, 0

increasing_skip:
    // Check if decreasing
    cmp w8, w9
    blt decreasing_skip
    mov x6, 0

decreasing_skip:
    // Check if max gap of 3
    sub w10, w9, w8
    cneg w10, w10, mi
    cmp w10, 3
    ble max_gap_skip
    mov x7, 0

max_gap_skip:
    add x4, x4, 1
    b loop_iter

new_line:
    // Check if we can increase the safe counter
    cmp x7, 0
    beq iter_end

    cmp x5, 1
    beq increase_safe_counter

    cmp x6, 1
    beq increase_safe_counter

    b iter_end

increase_safe_counter:
    add x3, x3, 1

iter_end:
    add x4, x4, 2
    b loop_init

loop_end:
    mov x0, x3

    // Epilogue
    ldp x29, x30, [sp], #16
    ret
