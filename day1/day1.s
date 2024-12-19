.data

filename: .ascii "input.txt\0"

read_buffer: .space 8192

out_str: .space 64

.text
.global _start
_start:
    mov     x0, -100
    adrp    x1, filename
    add     x1, x1, :lo12:filename
    mov     x2, 0          // O_RDONLY
    mov     x3, 0          // mode
    mov     x8, 56         // sys_openat
    svc     #0

    // _exit(0)
    mov     x0, #0         // status := 0
    mov     w8, #93        // exit is syscall #93
    svc     #0             // make syscall
