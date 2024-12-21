.global count_mul
count_mul:
    // Arguments:
    // x0: pointer to mul array

    // Prologue
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov x1, 0 // index
    mov x2, 0 // total
    mov x7, 1 // enable flag (1 = enabled, 0 = disabled)

loop:
    // check for end of string
    ldrb w3, [x0, x1]
    cmp w3, 0
    beq end

    // check for "do()"
    cmp w3, 'd'
    bne check_dont
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, 'o'
    bne loop
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, '('
    bne loop
    mov x7, 1 // enable future mul instructions
    b skip

check_dont:
    cmp w3, 'd'
    bne check_mul
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, 'o'
    bne loop
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, 'n'
    bne loop
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, '('
    bne loop
    mov x7, 0 // disable future mul instructions
    b skip

check_mul:
    // check for "mul("
    cmp w3, 'm'
    bne skip
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, 'u'
    bne loop
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, 'l'
    bne loop
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, '('
    bne loop

    // process "mul" only if enabled
    cmp x7, 0
    beq skip

    // get first number first digit
    mov x4, 0
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, '0'
    blt loop
    cmp w3, '9'
    bgt loop
    sub w3, w3, '0'
    add x4, x4, w3, uxtw

    // get first number second digit
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, '0'
    blt first_number_done
    cmp w3, '9'
    bgt first_number_done
    sub w3, w3, '0'
    mov x6, #10
    mul x4, x4, x6
    add x4, x4, w3, uxtw

    // get first number third digit
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, '0'
    blt first_number_done
    cmp w3, '9'
    bgt first_number_done
    sub w3, w3, '0'
    mov x6, #10
    mul x4, x4, x6
    add x4, x4, w3, uxtw
    add x1, x1, 1

first_number_done:
    // check for ','
    ldrb w3, [x0, x1]
    cmp w3, ','
    bne loop

    // get second number first digit
    mov x5, 0
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, '0'
    blt loop
    cmp w3, '9'
    bgt loop
    sub w3, w3, '0'
    add x5, x5, w3, uxtw

    // get second number second digit
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, '0'
    blt second_number_done
    cmp w3, '9'
    bgt second_number_done
    sub w3, w3, '0'
    mov x6, #10
    mul x5, x5, x6
    add x5, x5, w3, uxtw

    // get second number third digit
    add x1, x1, 1
    ldrb w3, [x0, x1]
    cmp w3, '0'
    blt second_number_done
    cmp w3, '9'
    bgt second_number_done
    sub w3, w3, '0'
    mov x6, #10
    mul x5, x5, x6
    add x5, x5, w3, uxtw
    add x1, x1, 1

second_number_done:
    // check for ')'
    ldrb w3, [x0, x1]
    cmp w3, ')'
    bne loop

    // add to total
    mul x4, x4, x5
    add x2, x2, x4

skip:
    add x1, x1, 1
    b loop

end:
    mov x0, x2

    // Epilogue
    ldp x29, x30, [sp], #16
    ret
