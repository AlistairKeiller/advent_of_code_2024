.global count_xmas
count_xmas:
    // Arguments:
    // x0: pointer to char* xmas array
    // x1: number of rows
    // x2: number of columns

    // Prologue
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    mov     x3, 1 // y
    mov     x5, 0 // xmas count

row_loop: // for (int y = 0; y < rows; y++)
    mov     x4, 1 // x
    add     x3, x3, 1
    cmp     x3, x1
    sub     x3, x3, 1
    bge     row_loop_end

column_loop: // for (int x = 0; x < columns; x++)
    add     x4, x4, 1
    cmp     x4, x2
    sub     x4, x4, 1
    bge     column_loop_end

    // check we have an A
    mul     x6, x3, x2
    add     x6, x6, x4
    ldrb    w7, [x0, x6]
    cmp     w7, 'A'
    bne     column_loop_skip

    // check that (x+1, y+1) is either an M or an S
    add     x8, x3, 1
    add     x9, x4, 1
    mul     x6, x8, x2
    add     x6, x6, x9
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    beq     either_M_or_S_1
    cmp     w7, 'S'
    beq     either_M_or_S_1
    b       column_loop_skip

either_M_or_S_1:
    // check that (x-1, y+1) is either an M or an S
    add     x8, x3, 1
    sub     x9, x4, 1
    mul     x6, x8, x2
    add     x6, x6, x9
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    beq     either_M_or_S_2
    cmp     w7, 'S'
    beq     either_M_or_S_2
    b       column_loop_skip
    
either_M_or_S_2:
    // check that (x-1, y-1) is either an M or an S
    sub     x8, x3, 1
    sub     x9, x4, 1
    mul     x6, x8, x2
    add     x6, x6, x9
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    beq     either_M_or_S_3
    cmp     w7, 'S'
    beq     either_M_or_S_3
    b       column_loop_skip

either_M_or_S_3:
    // check that (x+1, y-1) is either an M or an S
    sub     x8, x3, 1
    add     x9, x4, 1
    mul     x6, x8, x2
    add     x6, x6, x9
    ldrb    w7, [x0, x6]
    cmp     w7, 'M'
    beq     either_M_or_S_4
    cmp     w7, 'S'
    beq     either_M_or_S_4
    b       column_loop_skip

either_M_or_S_4:
    // check that (x-1, y-1) != (x+1, y+1)
    sub     x8, x3, 1
    sub     x9, x4, 1
    mul     x6, x8, x2
    add     x6, x6, x9
    ldrb    w7, [x0, x6]
    add     x8, x3, 1
    add     x9, x4, 1
    mul     x6, x8, x2
    add     x6, x6, x9
    ldrb    w8, [x0, x6]
    cmp     w7, w8
    beq     column_loop_skip 

    // found
    add     x5, x5, 1

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
