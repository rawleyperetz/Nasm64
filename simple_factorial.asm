
%include "mymacros.inc"

extern atoi

section .data
	;msg db "Hello Earthling", 0
	error db "One command line argument needed", 0, 10
	errorlength equ $ - error
	
	newline db 10

section .bss
	result   resq 1
	output   resb 20
	
section .text
	global _start

;-------------------------
; Factorial function
;------------------------
factorial:
	cmp rdi, 0
	jl .negValue
	je .exactlyZero

	mov rax, 1
	mov rcx, 1
	
.loop:
	cmp rcx, rdi
	je .done

	inc rcx
	imul rax, rcx

	jmp .loop
	

.done:
	ret	

.exactlyZero:
	mov rax, 1
	ret

.negValue:
	mov rax, 0
	ret



_start:
	mov r8, [rsp]

	cmp r8, 2
	je computeFactorial

	print error, errorlength
	exit 1

computeFactorial:
	mov rdi, [rsp + 16]
	call atoi
	mov rdi, rax
	
	call factorial
	mov [result], rax

	print_num output, qword [result]
	print newline, 1
	exit 0
