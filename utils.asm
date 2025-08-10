section .text
    global print
    global exit
    global conversion
    global pop_loop
    global int_to_string
    global string_to_int
    global read_input

print:
    ; macOS syscall: write (rax = 0x2000004, rdi = 1 for stdout)
    mov rax, 0x2000004
    mov rdi, 1
    syscall
    ret  ; do not use return in _start, printing will be in loop

exit:
    ; macOS syscall: exit (rax = 0x2000001)
    mov rax, 0x2000001
    xor rdi, rdi  ; or mov rdi, 0
    syscall

; --- Procedure to convert an integer to an ASCII string ---
; Input:  RAX = the number to convert.
;         RDI = the memory address of the buffer to store the string.
; Output: RAX = the length of the resulting string.
int_to_string:
    mov rbx, 10
    mov rcx, 0
conversion:
    xor rdx, rdx
    div rbx
    add rdx, '0'
    push rdx
    inc rcx
    cmp rax, 0
    jnz conversion
    mov rax, rcx
pop_loop:
    pop rdx
    mov [rdi], dl
    inc rdi
    dec rcx
    jnz pop_loop
    ret

; --- Procedure to convert a string of digits to an integer ---
; This version is more robust and stops on non-digit characters.
; Input:  RSI = pointer to the string
; Output: RAX = resulting integer
; Destroys: RCX
string_to_int:
    xor rax, rax        ; Clear RAX to store the result
    xor rcx, rcx        ; Clear RCX (used for digit value)

.next_char:
    movzx rcx, byte [rsi] ; Load current character and zero-extend into RCX
    cmp cl, '0'         ; Check if the character is below '0'
    jl .done            ; If so, we're done (handles null terminator)
    cmp cl, '9'         ; Check if the character is above '9'
    jg .done            ; If so, it's not a digit, so we're done

    sub cl, '0'         ; Convert ASCII character to integer value
    imul rax, rax, 10   ; result = result * 10
    add rax, rcx        ; result = result + new_digit
    inc rsi             ; Move to the next character in the string
    jmp .next_char

.done:
    ret

; --- Procedure to read input from stdin ---
; CORRECTED: This version correctly preserves the buffer address.
; Input: RDI = pointer to the input buffer
; Output: RAX = number of bytes read
read_input:
    mov r9, rdi               ; BUG FIX: Save buffer address from RDI into R9
    mov rax, 0x2000003        ; syscall: read
    mov rdi, 0                ; file descriptor 0 = stdin
    mov rsi, r9               ; Use the saved buffer address from R9
    mov rdx, 32               ; max number of bytes to read
    syscall
    ret


