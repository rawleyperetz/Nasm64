
%include "mymacros.inc"

extern atoi

section .data
	newline db 10
	cmdlineerror db "Four command line arguments needed", 0, 10
	cmdlineerrorlength equ $ - cmdlineerror

section .bss
	output resb 20

section .text
	global _start

_start:
	mov r8, [rsp] ; get no of command line arguments

	cmp r8, 6
	je convertToInt

	print cmdlineerror, cmdlineerrorlength
	exit 1

convertToInt:
	mov rdi, [rsp + 16] ; A, first command line argument
	call atoi
	mov r12, rax

	mov rdi, [rsp + 24]
	call atoi
	mov r13, rax ; B, second command line argument

	mov rdi, [rsp + 32]
	call atoi
	mov r14, rax ; P, third command line argument

	mov rdi, [rsp + 40]
	call atoi
	mov r15, rax ; R, fourth command line argument

	mov rdi, [rsp + 48]
	call atoi
	mov rcx, rax ; n, fifth command line argument


beginBarrett:
	imul r12, r13 ; C = A*B

	mov r13, r12

	imul r13, r15

	;mov rax, 1
	imul rcx, 2
	;shl rax, cl

	;div r13
	shr r13, cl

	imul r13, r14

	sub r12, r13

conditionCheck:
	cmp r12, r14
	jl done

	sub r12, r14
	jmp conditionCheck

done:
	mov r8, r12
	print_num output, r8
	print newline, 1
	exit 0
