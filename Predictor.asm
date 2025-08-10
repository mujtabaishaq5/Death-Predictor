
extern print, exit, string_to_int, int_to_string, read_input, red_color, redlen, reset_color,resetlen, cyan_color, cyanlen

section .data
    ; --- Constants ---
    base_lifespan   dq 85     ; Starting lifespan in years
    current_year    dq 2025   ; The current year for calculation
    smoke_penalty   dq 10     ; Years lost to smoking
    disease_penalty dq 5      ; Years lost to chronic disease
    exercise_bonus  dq 5      ; Years gained from exercise
    diet_penalty    dq 7      ; Years lost to poor diet
    stress_penalty  dq 4      ; Years lost to high stress

    ; --- Questions and Messages ---
    age_prompt      db "Enter your current age: "
    age_prompt_len  equ $ - age_prompt

    smoke_prompt    db "Do you smoke? (y/n): "
    smoke_prompt_len equ $ - smoke_prompt

    disease_prompt  db "Do you have a chronic disease? (y/n): "
    disease_prompt_len equ $ - disease_prompt

    exercise_prompt db "Do you exercise regularly? (y/n): "
    exercise_prompt_len equ $ - exercise_prompt

    diet_prompt     db "Do you have a poor diet (lots of junk food)? (y/n): "
    diet_prompt_len equ $ - diet_prompt

    stress_prompt   db "Do you have a high-stress lifestyle? (y/n): "
    stress_prompt_len equ $ - stress_prompt

    result_msg      db "Predicated(Death-year): "
    result_msg_len  equ $ - result_msg

    invalid_age_msg db "Invalid age. Please enter a number greater than 0.", 0xA
        invalid_age_msg_len equ $ - invalid_age_msg

    newline         db 0xA

section .bss
    ; Buffers for user input
    age_input       resb 32   ; For multi-digit age
    yes_no_input    resb 8    ; For single 'y' or 'n' character

section .text
    global _start

_start:
    ; --- Initialize lifespan ---
    mov r12, qword [rel base_lifespan]

    ; --- Get user's current age ---
    mov rsi, age_prompt
    mov rdx, age_prompt_len
    call print

    mov rdi, age_input
    mov r9, rdi
    call read_input
    mov rdi, r9
    mov byte [rdi + rax - 1], 0
   ; ...
    mov rsi, age_input
    call string_to_int          ; rax now holds the integer value of the age

       ; --- Add this validation block ---
    cmp rax, 0                  ; Compare the age with 0
    je .invalid_age             ; If it's zero, jump to the error handler
       ; --- End of validation block ---

    mov r13, rax                ; If age is valid, store it in r13 and continue
       ; ...

    ; --- Question 1: Smoking ---
    mov rsi, smoke_prompt
    mov rdx, smoke_prompt_len
    call print

    mov rdi, yes_no_input
    mov r9, rdi
    call read_input
    mov rdi, r9
    cmp byte [rdi], 'y'
    jne .skip_smoke_penalty
    sub r12, qword [rel smoke_penalty]

.skip_smoke_penalty:
    ; --- Question 2: Chronic Disease ---
    mov rsi, disease_prompt
    mov rdx, disease_prompt_len
    call print

    mov rdi, yes_no_input
    mov r9, rdi
    call read_input
    mov rdi, r9
    cmp byte [rdi], 'y'
    jne .skip_disease_penalty
    sub r12, qword [rel disease_penalty]

.skip_disease_penalty:
    ; --- Question 3: Exercise ---
    mov rsi, exercise_prompt
    mov rdx, exercise_prompt_len
    call print

    mov rdi, yes_no_input
    mov r9, rdi
    call read_input
    mov rdi, r9
    cmp byte [rdi], 'y'
    jne .skip_exercise_bonus
    add r12, qword [rel exercise_bonus]

.skip_exercise_bonus:
    ; --- NEW Question 4: Poor Diet ---
    mov rsi, diet_prompt
    mov rdx, diet_prompt_len
    call print

    mov rdi, yes_no_input
    mov r9, rdi
    call read_input
    mov rdi, r9
    cmp byte [rdi], 'y'
    jne .skip_diet_penalty
    sub r12, qword [rel diet_penalty]

.skip_diet_penalty:
    ; --- NEW Question 5: High Stress ---
    mov rsi, stress_prompt
    mov rdx, stress_prompt_len
    call print

    mov rdi, yes_no_input
    mov r9, rdi
    call read_input
    mov rdi, r9
    cmp byte [rdi], 'y'
    jne .skip_stress_penalty
    sub r12, qword [rel stress_penalty]

.skip_stress_penalty:
    ; --- Final Calculation ---
    mov rax, r12
    sub rax, r13
    add rax, qword [rel current_year]

    ; --- Print the result ---
    mov rdi, age_input
    call int_to_string
    mov r9, rax

    lea rsi, [rel cyan_color]
    mov rdx, cyanlen
    call print

    mov rsi, result_msg
    mov rdx, result_msg_len
    call print

    lea rsi, [rel reset_color]
    mov rdx, resetlen
    call print

    lea rsi, [rel red_color]
    mov rdx, redlen

    ;print method manually writing
    mov rax, 0x2000004
    mov rdi, 1
    syscall

    mov rsi, age_input
    mov rdx, r9
    call print


    lea rsi, [rel reset_color]
    mov rdx, resetlen

; ... (this is after all the normal print result calls)

    jmp .end_program            ; If program ran successfully, skip the error handler

.invalid_age:
    lea rsi, [rel red_color]
    mov rdx, redlen
    call print
    lea rsi, [rel invalid_age_msg]
    mov rdx, invalid_age_msg_len
    call print
    lea rsi, [rel reset_color]
    mov rdx, resetlen
    call print

.end_program:
    call exit
