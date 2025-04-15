; This code is a fahrenheit to celsius converter and vice versa


section .data
    prompt db "To Celsius (c), to Fahrenheit (f): ", 0
    promptlength equ $ - prompt
    tempPrompt db "Enter the temperature: ", 0
    tempPromptlength equ $ - tempPrompt
    newline db 10    

section .bss
    choice resb 3
    buffer resb 20

section .text
    global _start
    

_start:
    ; Print the 'enter the temperature' prompt 
    mov rax, 1
    mov rdi, 1
    mov rsi, tempPrompt
    mov rdx, tempPromptlength
    syscall
    
    ; Read user input and store in buffer
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 4
    syscall

    xor rcx, rcx
    xor rbx, rbx
    jmp .convert_loop

    
.convert_loop:
   ; convert from ascii to integer and store in rbx
    mov al, [buffer + rcx] ; load byte at input[rcx]
    cmp al, 10            ; is it newline? (ASCII '\n')
    je .done              ; yes -> we're done
    sub al, '0'           ; convert from ASCII to digit
    imul rbx, rbx, 10     ; result *= 10
    add rbx, rax          ; result += digit
    inc rcx               ; next char
    jmp .convert_loop

    
.done:
   ; I don't like it in rbx just because ...
    mov r8, rbx
    jmp _nextprompt

    
_nextprompt:
    ; Print the 'To celsius or fahrenheit' prompt 
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, promptlength
    syscall
    
    ; Read user input and store in choice
    mov rax, 0
    mov rdi, 0
    mov rsi, choice
    mov rdx, 2
    syscall
	
    mov al, [choice]    
    cmp al, 'c'      ; if 'c' then do .toCelsius
    je .toCelsius
    
    cmp al, 'f'     ; if 'f' then do .toFahren
    je .toFahren
    
    jmp _exit      ; else exit the program, ain't got time for you and your bull

        
    
.toFahren:
   ; the following expresses F = (C*9/5) + 32 = (9*C + 160)/5 and stores the result in rax
    mov rax, r8 ; moving r8 into rax
    imul rax, rax, 9 ; rax = rax * 9
    add rax,  160    ; rax += 160
    mov rdx, 0     ; clear remainder
    mov rcx, 5
    div rcx
    
    jmp .printResult
    
    

.toCelsius:
    ; the following expresses C = ((F-32)*5)/9 and stores the result in rax
    mov rax, r8
    sub rax, 32
    imul rax, rax, 5
    xor rdx, rdx
    mov rcx, 9
    div rcx
    jmp .printResult


.printResult:
    ; convert number in rax to ASCII string in buffer (reversed)
    mov rcx, buffer
    add rcx, 19
    mov byte [rcx], 0
    dec rcx

.convert_to_ascii:
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add dl, '0'
    mov [rcx], dl
    dec rcx
    test rax, rax
    jnz .convert_to_ascii
    inc rcx

    ; Print the number
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, buffer
    add rdx, 20
    sub rdx, rcx
    ;mov rdx, buffer + 20 - rcx
    syscall

    ; print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    jmp _exit

_exit:
    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall
    
