
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
; follows the usual factorial algo. multiply numbers until some n where n is stored in rdi

factorial:
	cmp rdi, 0
	jl .negValue     ; negative input check
	je .exactlyZero  ; zero input check

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
	mov r8, [rsp]   ; get argc

	cmp r8, 2
	je computeFactorial

	; print error and return 1
	print error, errorlength
	exit 1

computeFactorial:
	mov rdi, [rsp + 16]
	call atoi
	mov rdi, rax
	
	call factorial
	mov [result], rax

	print_num output, qword [result]  ; print output to stdout
	print newline, 1   ; add a newline char for pretty printing
	exit 0   ; exit gracefully
