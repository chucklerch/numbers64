; File: numbers.asm
; 64 bit version

global _start
global input:data

EXTERN printHex, printBinary, printDecimal, clearBuff
EXTERN readStdinTermios, writeStdinTermios, canonicalOn, canonicalOff, echoOn, echoOff

SECTION .data               ; Initialized data

    startupMsg:  db "Numbers Thingy64, v0.0.1", 0x0A            ; startup message with newline at end
    startupMsgLength: equ $ - startupMsg                        ; length of message
    promtMsg:    db "Enter a char (0 to exit): "                ; prompt message
    promtMsgLength equ $ - promtMsg                             ; length of prompt
    newline      db     0x0A                                    ; newline character

    STDIN        equ    0
    STDOUT       equ    1
    STDERR       equ    2

    SYS_read     equ    0
    SYS_write    equ    1
    SYS_exit     equ    60

SECTION .bss                        ; Uninitialized data
    input        resb   1           ; 

SECTION .text                       ; Code

_start:
    push rbp                        ; Prolog - Align the stack
    mov rbp, rsp                    ; Store starting stack pointer into rbp

    mov rax, SYS_write              ; sys_write system call
    mov rdi, STDOUT                 ; use stdout
    mov rsi, startupMsg
    mov rdx, startupMsgLength
    syscall
    call printNewLine
    call canonicalOff               ; enable reading a char at a time

prompt:
    ; Display prompt
    mov rax, SYS_write              ; select 'write' syscall
    mov rdi, STDOUT                 ; use stdout
    mov rsi, promtMsg               ; address of prompt message
    mov rdx, promtMsgLength         ; store message length
    syscall                         ; make the syscall

    ; Read input
    mov rax, SYS_read               ; 'read' syscall
    mov rdi, STDIN                  ; use stdin
    mov rsi, input                  ; put data into input
    mov rdx, 1                      ; read 1 byte
    syscall                         ; make syscall
    cmp rax, 0                      ; check sys_read's return value
    je exit                         ; exit if EOF
    call printNewLine

    cmp byte [input], '0'           ; if input is '0' then exit
    je exit

    call printHex
    call clearBuff
    call printBinary
    call clearBuff
    call printDecimal
    call printNewLine
    
    call printNewLine
    jmp prompt                      ; loop back to prompt

exit:
    pop rbp                         ; Epilog - Align the stack before exiting
    mov rax, SYS_exit               ; Exit system call
    mov rdi, 0                      ; Exit code 0
    syscall                         ; Make system call

printNewLine:
    ; function to print a newline
    mov rax, SYS_write              ; select 'write' syscall
    mov rdi, STDOUT                 ; use stdout
    mov rsi, newline                ; address of newline 
    mov rdx, 1                      ; store message length
    syscall                         ; make the syscall
    ret