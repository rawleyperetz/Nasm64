
%include "mymacros.inc"

extern atoi

section .data
	error db "Two command line arguments needed", 0
	errorlength equ $ - error
	newline db 10

section .bss
	a      resq 1
	b      resq 1
	c      resq 1
	output resb 20
	
section .text
	global _start

sq_pythagoras:
	imul rdi, rdi
	imul rsi, rsi

	xor rax, rax
	add rax, rdi
	add rax, rsi
	
	ret

_start:
	mov r8, [rsp]

	cmp r8, 3
	je compute

	print error, errorlength
	exit 1

compute:
	mov rdi, [rsp + 16]
	call atoi
	mov [a], rax

	mov rdi, [rsp + 24]
	call atoi
	mov [b], rax

	mov rdi, [a]
	mov rsi, [b]
	
	call sq_pythagoras

	mov [c], rax

	print_num output, qword [c]
	print newline, 1
	exit 0
