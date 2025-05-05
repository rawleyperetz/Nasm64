; this code computes the factorial of a number

%include "mymacros.inc"

extern atoi

section .data
	error db "Error: only one command line argument needed",0, 10
	errorlength equ $ - error
	newline db 10

section .bss
	output resb 20

section .text
	global _start

_start:
	mov r8, [rsp]

	cmp r8, 2
	je convertInt

	print error, errorlength
	exit 1

convertInt:
	mov rdi, [rsp + 16] ; get first command line argument
	call atoi
	mov r8, rax

	mov r9, 1 ; initializing from one
	mov r10, 1 ; initializing
	jmp calFactorial

calFactorial:
	imul r9, r10

	cmp r10, r8
	je done

	inc r10
	jmp calFactorial


done:
	print_num output, r9
	print newline, 1
	exit 0
