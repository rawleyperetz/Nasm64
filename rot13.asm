
%include "mymacros.inc"

section .data
	newline db 10
	cmdlineerror db "Only one command line argument needed", 0, 10
	cmdlineerrorlength equ $ - cmdlineerror

section .bss
	output resb 32

section .text
	global _start

_start:
	mov r8, [rsp]

	cmp r8, 2
	je beginrot

	print cmdlineerror, cmdlineerrorlength
	exit 1

beginrot:
	mov r8, [rsp + 16]

	xor rcx, rcx
	jmp arglength

arglength:
	mov al, [r8 + rcx]

	cmp al, 0
	je gotlength

	inc rcx
	jmp arglength

gotlength:
	;dec rcx
	mov r12, rcx
	xor rcx, rcx

	jmp asciihandle


asciihandle:
	mov bl, [r8 + rcx]

	cmp rcx, r12
	je done

	cmp bl, 97
	jge lowerascii

	cmp bl, 65
	jge capitalascii

	call addchar

	jmp asciihandle


lowerascii:
	cmp bl, 122
	jg otherchar

	add bl, 13

	cmp bl, 122
	jg managelower


	mov byte [output + rcx], bl
	inc rcx
	jmp asciihandle

managelower:
	sub bl, 122
	add bl, 96

	call addchar
	jmp asciihandle

addchar:
	mov byte [output + rcx], bl
	inc rcx
	ret

capitalascii:
	cmp bl, 90
	jg otherchar

	add bl, 13

	cmp bl, 90
	jg manageupper

	call addchar
	jmp asciihandle

manageupper:
	sub bl, 90
	add bl, 64

	call addchar
	jmp asciihandle

otherchar:
	call addchar
	jmp asciihandle

done:
	print output, r12
	print newline, 1
	exit 0
