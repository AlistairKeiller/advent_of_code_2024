.global count_xmas
count_xmas:
    // Arguments:
    // x0: pointer to char* xmas array
    // x1: number of rows
    // x2: number of columns

    // Prologue
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    mov     x3, 0          // y
    mov     x5, 0          // xmas count

row_loop: // for (int y = 0; y < rows; y++)
    mov     x4, 0          // x
    cmp     x3, x1
    bge     row_loop_end

column_loop: // for (int x = 0; x < columns; x++)
    cmp     x4, x2
    bge     column_loop_end

    //------------------------------------------------------------------
    // check we have X
    //------------------------------------------------------------------
    mul     x6, x3, x2
    add     x6, x6, x4
    ldrb    w7, [x0, x6]
    cmp     w7, 'X'
    bne     column_loop_skip

    //------------------------------------------------------------------
    // right match: X M A S
    //------------------------------------------------------------------
    add     x8, x4, 3
    cmp     x8, x2
    bge     right_match_skip

    // check M at (y, x+1)
    add     x8, x4, 1
    mul     x6, x3, x2
    add     x6, x6, x8
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    bne     right_match_skip

    // check A at (y, x+2)
    add     x8, x4, 2
    mul     x6, x3, x2
    add     x6, x6, x8
    ldrb    w7, [x0, x6]
    cmp     w7, 'A'
    bne     right_match_skip

    // check S at (y, x+3)
    add     x8, x4, 3
    mul     x6, x3, x2
    add     x6, x6, x8
    ldrb    w7, [x0, x6]
    cmp     w7, 'S'
    bne     right_match_skip

    // found "XMAS" going right
    add     x5, x5, 1

right_match_skip:

    //------------------------------------------------------------------
    // down match:
    //    X
    //    M
    //    A
    //    S
    //------------------------------------------------------------------
    add     x8, x3, 3
    cmp     x8, x1
    bge     down_match_skip

    // check M at (y+1, x)
    add     x8, x3, 1
    mul     x6, x8, x2
    add     x6, x6, x4
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    bne     down_match_skip

    // check A at (y+2, x)
    add     x8, x3, 2
    mul     x6, x8, x2
    add     x6, x6, x4
    ldrb    w7, [x0, x6]
    cmp     w7, 'A'
    bne     down_match_skip

    // check S at (y+3, x)
    add     x8, x3, 3
    mul     x6, x8, x2
    add     x6, x6, x4
    ldrb    w7, [x0, x6]
    cmp     w7, 'S'
    bne     down_match_skip

    // found
    add     x5, x5, 1

down_match_skip:

    //------------------------------------------------------------------
    // left match:  S A M X
    //------------------------------------------------------------------
    sub     x8, x4, 3
    cmp     x8, 0
    blt     left_match_skip

    // check M at (y, x-1)
    sub     x8, x4, 1
    mul     x6, x3, x2
    add     x6, x6, x8
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    bne     left_match_skip

    // check A at (y, x-2)
    sub     x8, x4, 2
    mul     x6, x3, x2
    add     x6, x6, x8
    ldrb    w7, [x0, x6]
    cmp     w7, 'A'
    bne     left_match_skip

    // check S at (y, x-3)
    sub     x8, x4, 3
    mul     x6, x3, x2
    add     x6, x6, x8
    ldrb    w7, [x0, x6]
    cmp     w7, 'S'
    bne     left_match_skip

    // found
    add     x5, x5, 1

left_match_skip:

    //------------------------------------------------------------------
    // up match:
    //    S
    //    A
    //    M
    //    X
    //------------------------------------------------------------------
    sub     x8, x3, 3
    cmp     x8, 0
    blt     up_match_skip

    // check M at (y-1, x)
    sub     x8, x3, 1
    mul     x6, x8, x2
    add     x6, x6, x4
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    bne     up_match_skip

    // check A at (y-2, x)
    sub     x8, x3, 2
    mul     x6, x8, x2
    add     x6, x6, x4
    ldrb    w7, [x0, x6]
    cmp     w7, 'A'
    bne     up_match_skip

    // check S at (y-3, x)
    sub     x8, x3, 3
    mul     x6, x8, x2
    add     x6, x6, x4
    ldrb    w7, [x0, x6]
    cmp     w7, 'S'
    bne     up_match_skip

    // found
    add     x5, x5, 1

up_match_skip:

    //------------------------------------------------------------------
    // down-right match:
    //       X
    //         M
    //           A
    //             S
    //------------------------------------------------------------------
    add     x9, x3, 3
    cmp     x9, x1
    bge     down_right_match_skip

    add     x9, x4, 3
    cmp     x9, x2
    bge     down_right_match_skip

    // check M at (y+1, x+1)
    add     x9, x3, 1
    add     x10, x4, 1
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    bne     down_right_match_skip

    // check A at (y+2, x+2)
    add     x9, x3, 2
    add     x10, x4, 2
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'A'
    bne     down_right_match_skip

    // check S at (y+3, x+3)
    add     x9, x3, 3
    add     x10, x4, 3
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'S'
    bne     down_right_match_skip

    // found
    add     x5, x5, 1

down_right_match_skip:

    //------------------------------------------------------------------
    // down-left match:
    //           X
    //         M
    //       A
    //     S
    //------------------------------------------------------------------
    add     x9, x3, 3
    cmp     x9, x1
    bge     down_left_match_skip

    sub     x9, x4, 3
    cmp     x9, 0
    blt     down_left_match_skip

    // check M at (y+1, x-1)
    add     x9, x3, 1
    sub     x10, x4, 1
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    bne     down_left_match_skip

    // check A at (y+2, x-2)
    add     x9, x3, 2
    sub     x10, x4, 2
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'A'
    bne     down_left_match_skip

    // check S at (y+3, x-3)
    add     x9, x3, 3
    sub     x10, x4, 3
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'S'
    bne     down_left_match_skip

    // found
    add     x5, x5, 1

down_left_match_skip:

    //------------------------------------------------------------------
    // up-left match:
    //     S
    //       A
    //         M
    //           X
    //------------------------------------------------------------------
    sub     x9, x3, 3
    cmp     x9, 0
    blt     up_left_match_skip

    sub     x9, x4, 3
    cmp     x9, 0
    blt     up_left_match_skip

    // check M at (y-1, x-1)
    sub     x9, x3, 1
    sub     x10, x4, 1
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    bne     up_left_match_skip

    // check A at (y-2, x-2)
    sub     x9, x3, 2
    sub     x10, x4, 2
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'A'
    bne     up_left_match_skip

    // check S at (y-3, x-3)
    sub     x9, x3, 3
    sub     x10, x4, 3
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'S'
    bne     up_left_match_skip

    // found
    add     x5, x5, 1

up_left_match_skip:

    //------------------------------------------------------------------
    // up-right match:
    //       S
    //     A
    //   M
    // X
    //------------------------------------------------------------------
    sub     x9, x3, 3
    cmp     x9, 0
    blt     up_right_match_skip

    add     x9, x4, 3
    cmp     x9, x2
    bge     up_right_match_skip

    // check M at (y-1, x+1)
    sub     x9, x3, 1
    add     x10, x4, 1
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    bne     up_right_match_skip

    // check A at (y-2, x+2)
    sub     x9, x3, 2
    add     x10, x4, 2
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'A'
    bne     up_right_match_skip

    // check S at (y-3, x+3)
    sub     x9, x3, 3
    add     x10, x4, 3
    mul     x6, x9, x2
    add     x6, x6, x10
    ldrb    w7, [x0, x6]
    cmp     w7, 'S'
    bne     up_right_match_skip

    // found
    add     x5, x5, 1

up_right_match_skip:

column_loop_skip:
    add     x4, x4, 1
    b       column_loop

column_loop_end:
    add     x3, x3, 1
    b       row_loop

row_loop_end:
    mov     x0, x5

    // Epilogue
    ldp     x29, x30, [sp], #16
    ret
