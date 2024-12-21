        .global count_mul
count_mul:
    // Arguments:
    //   x0: pointer to the (corrupted) input string

    // Prologue
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // x1 = index, x2 = total, x7 = mul_enabled flag
    mov     x1, 0
    mov     x2, 0
    mov     x7, 1

loop:
    // Check for end of string
    ldrb    w3, [x0, x1]
    cmp     w3, 0
    beq     end

check_do_dont:
    cmp     w3, 'd'          // first letter 'd' for "do" or "don't"
    bne     check_mul
    // Next char
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, 'o'
    bne     skip_one_char    // not "do", so skip
    // Next char
    add     x1, x1, 1
    ldrb    w3, [x0, x1]

    cmp     w3, '('
    beq     maybe_do_paren

    // If it's "n" then we might have "don't"
    cmp     w3, 'n'
    bne     skip_one_char    // not "don't"

    // Next char
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, '\''
    bne     skip_one_char    // must have apostrophe "don't"

    // Next char
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, 't'
    bne     skip_one_char

    // Next char should be '('
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, '('
    bne     skip_one_char

    // Next char should be ')'
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, ')'
    bne     skip_one_char

    // If we got here, we matched "don't()"
    mov     x7, 0            // disable future mul
    b       skip_one_char

maybe_do_paren:
    // we saw "do("
    // next char should be ')'
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, ')'
    bne     skip_one_char

    // matched "do()"
    mov     x7, 1            // enable future mul
    b       skip_one_char

    // If we didn't find "do()" or "don't()",
    // we fall through to check for "mul(" next.

check_mul:
    cmp     w3, 'm'
    bne     skip_one_char

    // Check for 'u'
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, 'u'
    bne     loop

    // Check for 'l'
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, 'l'
    bne     loop

    // Check for '('
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, '('
    bne     loop

    // Parse the first integer
    mov     x4, 0            // first number
    // read first digit
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, '0'
    blt     loop
    cmp     w3, '9'
    bgt     loop

    // w3 is a digit
    sub     w3, w3, '0'
    add     x4, x4, w3, uxtw

    // Try second digit
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, '0'
    blt     first_number_done
    cmp     w3, '9'
    bgt     first_number_done

    sub     w3, w3, '0'
    mov     x6, 10
    mul     x4, x4, x6
    add     x4, x4, w3, uxtw

    // Try third digit
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, '0'
    blt     first_number_done
    cmp     w3, '9'
    bgt     first_number_done

    sub     w3, w3, '0'
    mov     x6, 10
    mul     x4, x4, x6
    add     x4, x4, w3, uxtw
    add     x1, x1, 1

first_number_done:
    // Check for comma
    ldrb    w3, [x0, x1]
    cmp     w3, ','
    bne     loop

    // Parse the second integer
    mov     x5, 0            // second number
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, '0'
    blt     loop
    cmp     w3, '9'
    bgt     loop

    // w3 is a digit
    sub     w3, w3, '0'
    add     x5, x5, w3, uxtw

    // Try second digit
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, '0'
    blt     second_number_done
    cmp     w3, '9'
    bgt     second_number_done

    sub     w3, w3, '0'
    mov     x6, 10
    mul     x5, x5, x6
    add     x5, x5, w3, uxtw

    // Try third digit
    add     x1, x1, 1
    ldrb    w3, [x0, x1]
    cmp     w3, '0'
    blt     second_number_done
    cmp     w3, '9'
    bgt     second_number_done

    sub     w3, w3, '0'
    mov     x6, 10
    mul     x5, x5, x6
    add     x5, x5, w3, uxtw
    add     x1, x1, 1

second_number_done:
    // Check for ')'
    ldrb    w3, [x0, x1]
    cmp     w3, ')'
    bne     loop

    // Multiply and add to total only
    // if mul is currently enabled (x7)
    cmp     x7, 0
    beq     skip_one_char      // if disabled, skip

    // If enabled, multiply and accumulate
    mul     x4, x4, x5
    add     x2, x2, x4

skip_one_char:
    add     x1, x1, 1
    b       loop

end:
    mov     x0, x2

    // Epilogue
    ldp     x29, x30, [sp], #16
    ret
