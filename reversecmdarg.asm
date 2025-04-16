; this code reverses command line input
; example: input 'hello' output 'olleh'

section .data
	error db "Error: only one command line argument needed",0
	errorlength equ $ - error ; get error length
	newline db 10 ; add newline


section .bss
	onechar resb 1

section .text
	global _start

_start:
	mov r8, [rsp] ; [rsp] contains argc which is the number of command line arguments. in this case 2 including the program

	cmp r8, 2
	je initialize

	mov rax, 1
	mov rdi, 1
	mov rsi, error
	mov rdx, errorlength
	syscall

	jmp printnewline


initialize:
	mov r13, [rsp + 16] ; move command line argument [1] address into r13

	xor rcx, rcx ; initializing register rcx
	xor bl, bl   ; initializing register bl
	jmp lenloop

lenloop:
         ; run through the argv 1 to get the length. length is stored in rcx
	mov al, [r13 + rcx]
	cmp al, 0    ; if null terminator do gotlength. thus stop and continue
	je gotlength

	inc rcx
	jmp lenloop

gotlength:
         ; move rcx into r12 because in decloop after the syscall, rcx (and r11 according to chatgpt) changes drastically
         ; but r12-r15 are not affected. Chatgpt named it callee something. the same applies to rsi
	dec rcx
	mov r12, rcx
	xor rcx, rcx
	jmp decloop

decloop:
         ; pointer starts from behind and prints characters
	cmp r12, 0
	jl printnewline


	mov bl, [r13 + r12]
	mov [onechar], bl

	mov rax, 1
	mov rdi, 1
	mov rsi, onechar
	mov rdx, 1
	syscall

	dec r12
	jmp decloop


printnewline:
	; printing newline
	mov rax, 1
	mov rdi, 1
	mov rsi, newline
	mov rdx, 1
	syscall

	jmp _exit

_exit:
	mov rax, 60
	xor rdi, rdi
	syscall
