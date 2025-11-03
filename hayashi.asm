
%include "mymacros.inc"

extern atoi

section .data
	newline db 10
	argerror db "Error: only two cmd line args needed", 0, 10
	argerrorlen equ $ - argerror

section .bss
	output resb 10

section .text
	global _start

_start:
	mov r8, [rsp] ; get the number of command line arguments
	cmp r8, 3
	je convertInt

	print argerror, argerrorlen
	exit 1

convertInt:
	mov rdi, [rsp + 16] ; get first command line argument
	call atoi
	mov rbx, rax

	mov rdi, [rsp + 24] ; get second command line argument
	call atoi
	mov r9, rax

	mov r15, r9 ; I need this copy of the modulus

	mov r10, r9
	inc r10

	mov r8, rbx

	mod r8, r10
	mov r9, rdx

	inc r10
	mod r8, r10
	mov r8, rdx

	cmp r9, r8
	jge zeroing

	shl r9, 1
	sub r9, r8

	mov r10, 2
	add r9, r10
	jmp reductions

zeroing:
	shl r9, 1
	sub r9, r8


	jmp reductions

reductions:
	cmp r9, r15
	jl done

	sub r9, r15
	jmp reductions

done:
	print_num output, r9
	print newline, 1
	exit 0
