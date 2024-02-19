; File: termio.asm

global readStdinTermios, writeStdinTermios, canonicalOn, canonicalOff, echoOn, echoOff

section .data
    STDIN        equ    0
    STDOUT       equ    1
    STDERR       equ    2

    SYS_read     equ    0
    SYS_write    equ    1
    SYS_ioctl    equ    16

section .bss
    termios:     resb   36          ; store current terminal settings
    ICANON:      equ    1<<1
    ECHO:        equ    1<<3

section .text

readStdinTermios:                   ; https://stackoverflow.com/questions/3305005/how-do-i-read-single-character-input-from-keyboard-using-nasm-assembly-under-u
        push rax
        push rdi
        push rsi
        push rdx

        mov rax,SYS_ioctl
        mov rdi,STDIN
        mov rsi,5401h
        mov rdx,termios
        syscall                      ; ioctl(0, 0x5401, termios)

        pop rdx
        pop rsi
        pop rdi
        pop rax
        ret

writeStdinTermios:
        push rax
        push rdi
        push rsi
        push rdx

        mov rax, SYS_ioctl
        mov rdi, STDIN
        mov rsi, 5402h
        mov rdx, termios
        syscall                       ; ioctl(0, 0x5402, termios)

        pop rdx
        pop rsi
        pop rdi
        pop rax
        ret

canonicalOff:
        call readStdinTermios
        ; clear canonical bit in local mode flags
        and dword [termios+12], ~ICANON
        call writeStdinTermios
        ret

canonicalOn:
        call readStdinTermios
        ; set canonical bit in local mode flags
        or dword [termios+12], ICANON
        call writeStdinTermios
        ret

echoOff:
        call readStdinTermios
        ; clear echo bit in local mode flags
        and dword [termios+12], ~ECHO
        call writeStdinTermios
        ret

echoOn:
        call readStdinTermios
        ; clear echo bit in local mode flags
        and dword [termios+12], ECHO
        call writeStdinTermios
        ret
