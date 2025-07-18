
%include "mymacros.inc"

extern atoi

section .data
	newline db 10
	cmderror db "Error: only one command line argument needed", 0, 10
	cmderrorlength equ $ - cmderror
	revanswer db "In reverse: ", 0
	revanswerlength equ $ - revanswer

section .bss
	output resb 20

	
section .text
	global _start

_start:
	mov r8, [rsp] ; get the number of command line arguments into r8

	cmp r8, 2
	je convertInt

	print cmderror, cmderrorlength

	exit 1

convertInt:
	mov rdi, [rsp + 16] ; get the first command line argument into rdi
	call atoi
	mov r8, rax

	xor rcx, rcx
	
checkoddEven:
	test r8, 1
	jz yesEven

	mov byte [output + rcx], 49
	inc rcx
	jmp multiplying

yesEven:
	mov byte [output + rcx], 48
	inc rcx
	jmp multiplying


multiplying:
	cmp r8, 0
	je done

	shr r8, 1 ; this is division by 2
	jmp checkoddEven
	
done:
	print revanswer, revanswerlength
	print output, rcx
	print newline, 1
	exit 0	
