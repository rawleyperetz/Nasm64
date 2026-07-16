
%include "mymacros.inc"

extern atoi

section .data
	error db "Two command line arguments needed", 0
	errorlength equ $ - error
	newline db 10

section .bss
	n        resq 1
	result   resq 1
	output   resb 20
	
section .text
	global _start

;-------------------------
; Collatz_steps function
;------------------------
collatz_steps:	
	xor rax, rax    ; rax = 0

whileLoop:
	cmp rdi, 1
	je Done

	test rdi, 1
	jz toEven

	imul rdi, 3
	inc rdi

	inc rax
	jmp whileLoop 

toEven:
	shr rdi, 1  ; N / 2
	inc rax
	jmp whileLoop


Done:	
	ret





_start:
	mov r8, [rsp]

	cmp r8, 2
	je compute

	print error, errorlength
	exit 1

compute:
	mov rdi, [rsp + 16]
	call atoi
	mov [n], rax

	mov rdi, [n]
	
	call collatz_steps

	mov [result], rax

	print_num output, qword [result]
	print newline, 1
	exit 0
