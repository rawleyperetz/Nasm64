; This code toggles alphabetic characters using nasm x64

section .data
    prompt db "Enter string here: ", 0
    promptlength equ $ - prompt


section .bss
    inputString resb 100
    temp_byte resb 1
    
section .text
    global main
    
main:
    ; Print the prompt "Enter the (c)reate ..."
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, promptlength
    syscall
	

    ; Read user input 
    mov rax, 0
    mov rdi, 0
    mov rsi, inputString
    mov rdx, 100
    syscall
    
    ;mov r14, rax ; Store length of user input
    ;dec r14 ; Actual length
    
    mov r8, 0
    jmp _stringTraversal
    
    
_stringTraversal:
    movzx rbx, byte [inputString + r8]
    
    cmp rbx, 97
    jge toBig
    
    cmp rbx, 65
    jge toSmall
    
    cmp rbx, 10
    je _amEnde
    
    ; Writing to screen
    mov rax, 1
    mov rdi, 1
    mov [temp_byte], bl
    mov rsi, temp_byte
    mov rdx, 1
    syscall
    
    inc r8
    jmp _stringTraversal
    

toBig:
    cmp rbx, 122
    jg nextCharacter
    
    sub rbx, 32
    
    ; Write upperCase to Screen
    mov rax, 1
    mov rdi, 1
    mov [temp_byte], bl
    mov rsi, temp_byte
    mov rdx, 1
    syscall
    
    inc r8
    jmp _stringTraversal
    

toSmall:
    cmp rbx, 90
    jg nextCharacter
    
    add rbx, 32
    
    ; Write lowercase to Screen
    mov rax, 1
    mov rdi, 1
    mov [temp_byte], bl
    mov rsi, temp_byte
    mov rdx, 1
    syscall
    
    inc r8
    jmp _stringTraversal
    
    
nextCharacter:
    inc r8
    jmp _stringTraversal 
 

_amEnde:
    ;Write newline character
    mov rax, 1
    mov rdi, 1
    mov [temp_byte], bl
    mov rsi, temp_byte
    mov rdx, 1
    syscall
    
    jmp _exit
    
_exit:
    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall
    
    
    
    