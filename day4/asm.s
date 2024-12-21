.global count_xmas
count_xmas:
    // Arguments:
    // x0: pointer to char* xmas array
    // x1: number of rows
    // x2: number of columns

    // Prologue
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov x3, 0 // y
    mov x5, 0 // result

row_loop:
    mov x4, 0 // x
    // check if we are at the end of the array
    cmp x3, x1
    bge row_loop_end

column_loop:
    // check if we are at the end of the array
    cmp x4, x2
    bge column_loop_end

    // load the current value (xcmas[y * rows + x])
    mul x6, x3, x1
    add x6, x6, x4
    ldrb w7, [x0, x6]

    // check the value is x
    cmp w7, 'X'
    bne column_loop_skip
    
    // right match (XMAS)
    // check M
    add x8, x4, 1
    cmp x8, x2
    bge right_match_skip
    mul x6, x3, x1
    add x6, x6, x8
    ldrb w7, [x0, x6]
    cmp w7, 'M'
    bne right_match_skip
    // check A
    add x8, x8, 1
    cmp x8, x2
    bge right_match_skip
    mul x6, x3, x1
    add x6, x6, x8
    ldrb w7, [x0, x6]
    cmp w7, 'A'
    bne right_match_skip
    // check S
    add x8, x8, 1
    cmp x8, x2
    bge right_match_skip
    mul x6, x3, x1
    add x6, x6, x8
    ldrb w7, [x0, x6]
    cmp w7, 'S'
    bne right_match_skip
    // increase result
    add x5, x5, 1
    b column_loop_skip

right_match_skip:
    // down match X
    //            M
    //            A
    //            S
    // check M
    add x8, x3, 1
    cmp x8, x1
    bge down_match_skip
    mul x6, x8, x1
    add x6, x6, x4
    ldrb w7, [x0, x6]
    cmp w7, 'M'
    bne down_match_skip
    // check A
    add x8, x3, 1
    cmp x8, x1
    bge down_match_skip
    mul x6, x8, x1
    add x6, x6, x4
    ldrb w7, [x0, x6]
    cmp w7, 'A'
    bne down_match_skip
    // check S
    add x8, x3, 1
    cmp x8, x1
    bge down_match_skip
    mul x6, x8, x1
    add x6, x6, x4
    ldrb w7, [x0, x6]
    cmp w7, 'S'
    bne down_match_skip
    // increase result
    add x5, x5, 1

column_loop_skip:
    add x4, x4, 1
    b column_loop

column_loop_end:
    add x3, x3, 1
    b row_loop

row_loop_end:
    mov x0, x5

    // Epilogue
    ldp x29, x30, [sp], #16
    ret
