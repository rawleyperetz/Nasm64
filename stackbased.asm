; this code runs the reversed polish notation

section .data
	prompt db "Enter question: ", 0
	promptlength equ $ - prompt
	outputprompt db "Result is: ", 0
	outputpromptlength equ $ - outputprompt
	zerodiv db "Error: Division by Zero", 0
	zerodivlength equ $ - zerodiv
	newline db 10

section .bss
	userinput resb 20
	output resb 20

section .text
	global _start

_start:
	; print prompt
	mov rax, 1
	mov rdi, 1
	mov rsi, prompt
	mov rdx, promptlength
	syscall

	; read user input
	mov rax, 0
	mov rdi, 0
	mov rsi, userinput
	mov rdx, 20
	syscall

	xor rcx, rcx ; initializing rcx as counter, rcx = 0, to run through input
	jmp .nextelem


.nextelem:
	mov al, [userinput + rcx]

	cmp al, 48
	jge .mightbenumber

	cmp al, 42 ; if true, do multiplication
	je .multiplication

	cmp al, 43 ; if true, do addition
	je .addition

	cmp al, 45 ; if true, do subtraction
	je .subtraction

	cmp al, 47 ; if true, do division
	je .division

	cmp al, 10 ; if true, do 'done'
	je .done

	cmp al, 0
	je .done

	inc rcx
	jmp .nextelem


.mightbenumber:
	cmp al, 57
	jle .convertToInt

	inc rcx
	jmp .nextelem


.convertToInt:
	sub al, 48
	movzx rax, al
	push rax

	inc rcx
	jmp .nextelem


.multiplication:
	pop rbx
	pop rax
	imul rax, rbx ; rax = rax * rbx

	push rax

	inc rcx
	jmp .nextelem


.addition:
	pop rbx
	pop rax
	add rax, rbx

	push rax
	inc rcx
	jmp .nextelem


.subtraction:
	pop rbx
	pop rax
	sub rax, rbx

	push rax
	inc rcx
	jmp .nextelem


.division:
	pop rbx
	cmp rbx, 0
	je .divzero

	pop rax
	xor rdx, rdx ; clear remainder register
	div rbx
	push rax
	inc rcx
	jmp .nextelem

.divzero:
	; print division by zero prompt
	mov rax, 1
	mov rdi, 1
	mov rsi, zerodiv
	mov rdx, zerodivlength
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, newline
	mov rdx, 1
	syscall

	jmp _exit

.done:
	jmp .printResult

.printResult:
	pop rax ; final result
	mov rcx, output
	add rcx, 20
	mov rbx, 10
	xor rdx, rdx
	jmp .convert_loop

.convert_loop:
	xor rdx, rdx ; rcxear remainder again
	div rbx		; rax/ 10
	add rdx, '0'	; convert remainder to ascii
	dec rcx
	mov [rcx], dl ; store character
	test rax, rax
	jnz .convert_loop

	; now rcx points to beginning of string
	mov rax, 1
	mov rdi, 1
	mov rsi, rcx
	mov rdx, output
	add rdx, 20
	sub rdx, rcx
	syscall

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
