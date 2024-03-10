; File printValue.asm

GLOBAL printHex, printBinary, printDecimal, clearBuff
EXTERN input

section .data

    outputBinMsg db " Binary: "
    outputBinMsgLength equ $ - outputBinMsg
    outputHexMsg db " Hex: "
    outputHexMsgLength equ $ - outputHexMsg
    outputDecMsg db " Dec: "
    outputDecMsgLength equ $ - outputDecMsg
    hexTable db "0123456789ABCDEF"

    STDIN        equ    0
    STDOUT       equ    1
    STDERR       equ    2

    SYS_read     equ    0
    SYS_write    equ    1
    SYS_exit     equ    60

section .bss

    buff resb 20
    buffLength equ $ - buff

section .text

printBinary:
    mov rax, SYS_write              ; sys_write system call
    mov rdi, STDOUT                 ; use stdout
    mov rsi, outputBinMsg           ; addres of bin message
    mov rdx, outputBinMsgLength     ; store message length
    syscall                         ; make the syscall
      
    mov al, byte [input]            ; read input into al
    mov ecx, 8                      ; loop over 8 bits in a byte
    mov edi, buff                   ; put address of start of buff into edi  ; Chalkynm / MonkeyFace
.loop:
    rol al, 1                       ; rotate left 1, into cf
    jnc .setZero                    ; check carry flag
.setOne:
    mov byte [edi], '1'
    jmp .next
.setZero:
    mov byte [edi], '0'
.next:
    inc edi                         ; move to next address of buff
    dec ecx                         ; decrement the loop counter
    jnz .loop                       ; loop back if not done

.output:
    mov rax, SYS_write              ; select 'write' syscall
    mov rdi, STDOUT                 ; use stdout
    mov rsi, buff                   ; buffer is message
    mov rdx, buffLength             ; store message length
    syscall                         ; make the syscall
    ret

printHex:
    mov rax, SYS_write              ; select 'write' syscall
    mov rdi, STDOUT                 ; use stdout
    mov rsi, outputHexMsg           ; buffer is message
    mov rdx, outputHexMsgLength     ; store message length
    syscall                         ; make the syscall

    mov edi, buff
    mov al, byte [input]            ; read input into al
    shr al, 4
    mov ebx, hexTable
    xlat
    mov byte [edi], al
    inc edi
    mov al, byte [input]
    and al, 0x0f
    xlat
    mov byte [edi], al

.output:
    mov rax, SYS_write              ; select 'write' syscall
    mov rdi, STDOUT                 ; use stdout
    mov rsi, buff                   ; buffer is message
    mov rdx, 2                      ; store message length
    syscall                         ; make the syscall    
    ret

printDecimal:                       ; https://codereview.stackexchange.com/questions/283090/print-decimal-integer
    mov rax, SYS_write              ; select 'write' syscall
    mov rdi, STDOUT                 ; use stdout
    mov rsi, outputDecMsg           ; buffer is message
    mov rdx, outputDecMsgLength     ; store message length
    syscall                         ; make the syscall
debug:

    mov rcx, 10                     ; we are going to divide by 10
    mov rdi, buff + 19              ; buff to store the ascii output, in reverse order
    movzx rax, byte [input]          ; put the input into rax

.loop:
    xor rdx, rdx                    ; zero rdx
    div rcx                         ; unsigned divide rdx:rax by rcx
                                    ; rax := quotient, rdx := remainder
    add rdx, '0'                    ; convert remainder to ascii digit
    mov byte [rdi], dl              ; and store it
    dec rdi
    cmp rax, 0
    jne .loop                        ; do while (rax != 0)

.output:
    mov rax, SYS_write              ; select 'write' syscall
    mov rdi, STDOUT                 ; use stdout
    mov rsi, buff                   ; buffer is message
    mov rdx, 20                     ; store message length
    syscall                         ; make the syscall
    ret

; clear the buff to zeros
clearBuff:
    push rax                        ; save registers
    push rcx
    push rdi

    cld                             ; clear DF; count up-memory
    mov al, 0                       ; byte to store
    mov rdi, buff                   ; destination index = buff address
    mov rcx, buffLength             ; count of chars to store
    rep stosb                       ; blast byte length chars at buff

    pop rdi                         ; restore registers
    pop rcx
    pop rax
    ret                             ; return
; Old way
;     mov rdi, buffLength
; .loop:
;     mov byte [buff  + rdi], 0
;     dec rdi
;     jnz .loop
