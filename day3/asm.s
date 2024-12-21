.global count_mul
count_mul:
    // Arguments:
    // x0: pointer to array levels
    // x1: size of arrays (num_reports)

    // Prologue
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    
    // Epilogue
    ldp x29, x30, [sp], #16
    ret
