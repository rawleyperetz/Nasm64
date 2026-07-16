
%include "mymacros.inc"

section .data
	msg db "Hello Earthling", 0
	newline db 10

section .bss
	result   resq 1
	output   resb 20
	
section .text
	global _start

;-------------------------
; String Length function
;------------------------
strlen:
	xor rax, rax       ; accumulator / return register is initialized to zero

.loop:
	cmp byte [rdi + rax], 0
	je NullTerm
	
	inc rax

	jmp .loop

NullTerm:
	ret




_start:

	mov rdi, msg
	call strlen

	mov [result], rax

	print_num output, qword [result]
	print newline, 1
	exit 0
