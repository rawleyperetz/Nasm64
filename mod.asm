; the following code computes the remainder given the two values as command line arguments

%include "mymacros.inc"

extern atoi ; C function to convert to int

section .data
	cmdlineerror db "Error: two command line arguments needed", 0,10
	cmdlineerrorlength equ $ - cmdlineerror
	newline db 10 ; add newline

section .bss
	output resb 20

section .text
	global _start

_start:
	mov r8, [rsp] ; contains argc, the number of command line arguments

	cmp r8, 3
	je convertInt

	print cmdlineerror, cmdlineerrorlength
	exit 1

convertInt:
	mov rdi, [rsp + 16]
	call atoi
	mov r12, rax

	mov rdi, [rsp + 24]
	call atoi
	mov r9, rax

	mov r8, r12

	cmp r8, r9
	jl done
	je done

	xor r10, r10 ; a simple counter for the doubling
	jmp doubling


doubling:
	shl r9, 1 ; this is multiplication by 2

	cmp r9, r8
	jge prep

	inc r10
	jmp doubling


prep:
	shr r9, 1
	dec r10

	jmp rep_subtraction


rep_subtraction:
	cmp r9, r8
	jg skipthis

	sub r8, r9

skipthis:
	shr r9, 1
	dec r10
	cmp r10, -2
	jg rep_subtraction

done:
	print_num output, r8
	print newline, 1
	exit 0



