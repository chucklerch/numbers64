; File: numbers.asm
; 64 bit version

SECTION .data               ; Initialized data

    STDIN        equ    0
    STDOUT       equ    1
    STDERR       equ    2

    SYS_exit     equ    60
    SYS_read     equ    3
    SYS_write    equ    4

SECTION .bss                ; Uninitialized data


SECTION .text               ; Code

global _start

_start:
    push rbp                ; Prolog - Align the stack
    mov rbp, rsp            ; Store starting stack pointer into rbp
    nop


end:
    pop rbp                 ; Epilog - Align the stack before exiting
    mov rax, SYS_exit       ; Exit system call
    mov rdx, 0              ; Exit code 0
    syscall                 ; Make system call
