
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
	;xor rax, rax       ; accumulator / return register is initialized to zero

.factStart:	
	cmp rdi, 1
	jle .returnOne

	;mov rax, 1

	cmp rdi, 2
	je .returnTwo

	mov rsi, rdi
	shr rsi, 1

	mov r8, rsi

	test rdi, 1
	jz .isEven

	inc r8

.isEven:
	mov rax, 1
	xor rcx, rcx

.forLoop:
	cmp rcx, r8
	jge .loopDone

	mov rdx, rcx
	shl rdx, 1

	inc rdx

	imul rax, rdx

	inc rcx
	jmp .forLoop

.loopDone:
	mov rcx, rsi
	shl rax, cl

	push rax
	push rsi

	mov rdi, rsi
	call factorial

	pop rsi
	pop rdx

	imul rax, rdx
	ret
	
.returnTwo:
	mov rax, 2
	ret

.returnOne:
	mov rax, 1
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
