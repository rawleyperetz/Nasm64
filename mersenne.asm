
%include "mymacros.inc"

extern atoi

section .data
	newline db 10
	cmdlineerror db "Three command line arguments needed", 0, 10
	cmdlineerrorlength equ $ - cmdlineerror

section .bss
	output resb 20

section .text
	global _start

_start:
	mov r8, [rsp]

	cmp r8, 4
	je convertToInt

	print cmdlineerror, cmdlineerrorlength
	exit 1

convertToInt:
	mov rdi, [rsp + 16] ; get first cmd line arg, this is a
	call atoi
	mov rbx, rax

	mov rdi, [rsp + 24] ; get second cmd line arg, this is b
	call atoi
	mov r14, rax

	mov rdi, [rsp + 32] ; get third cmd line arg, this is modulus, m such that P=2^m - 1
	call atoi
	;mov r10, rax

	mov rcx, rax

	mov r8, rbx
	mov r9, r14

	jmp beginMersenne
	;mov cl, r10b

beginMersenne:
	imul r8, r9

	mov r11, r8
	shr r11, cl

	mov r12, 1
	shl r12, cl ; r12 = 2^m
	dec r12		; r12 = 2^m - 1 = modulus

	mov r13, r8
	and r13, r12
	
	add r11, r13

	jmp conditionCheck

conditionCheck:
	cmp r11, r12
	jl done

	sub r11, r12
	jmp conditionCheck

done:
	;mov r8, r11
	print_num output, r11
	print newline, 1
	exit 0
