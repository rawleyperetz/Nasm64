
%include "mymacros.inc"

extern atoi

section .data
	cmderror db "Error: only one command line argument needed", 0, 10
	cmderrorlength equ $ - cmderror
	isEven db "The value is even", 0, 10
	isEvenlength equ $ - isEven
	isOdd db "The value is odd", 0, 10
	isOddlength equ $ - isOdd


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

	jmp oddEven

oddEven:
	test r8, 1
	jz yesEven

	print isOdd, isOddlength
	exit 0

yesEven:
	print isEven, isEvenlength
	exit 0
