; this program converts decimals to their hexadecimal counterparts
; it is run using the following command: ./tohex <number>

%include  "mymacros.inc"

extern atoi ; C function for converting string or char to int

section .data
	newline db 10
	cmdlineerror db "Only one command line argument needed", 0, 10
	cmdlineerrorlength equ $ - cmdlineerror
	extraletters db "ABCDEF"
	revString db "In reverse: ", 0
	revStringlength equ $ - revString

section .bss
	output resb 20

section .text
	global _start

_start:
	mov r8, [rsp] ; get number of command line arguments into r8

	cmp r8, 2
	je convertToInt

	; print out error message and return with error code 1
	print cmdlineerror, cmdlineerrorlength
	exit 1

convertToInt:
	mov rdi, [rsp + 16] ; get first command line argument into rdi
	call atoi
	mov r8, rax

	xor r9, r9
	xor rcx, rcx
	xor al, al
	xor r12, r12

divOperation:
	mov r9, r8

	cmp r9, 16
	jl done

	shr r9, 4 ; this is integer division by 16 or 2^4. this yields a quotient

	imul r9, 16    ; quotient * 16
	sub r8, r9     ; remainder = number - quotient * 16


	cmp r8, 10     ; if remainder >= 10
	jge extraside  ; then jump to extraside so that we can use the letter 'ABCDEF' to represent remainder >= 10

	; convert integer to ascii char
	mov al, r8b
	add al, '0'
	;add r9, '0'
	mov byte [output + rcx], al
	inc rcx

	shr r9, 4

	cmp r9, 16
	jl done

	mov r8, r9
	jmp divOperation

extraside:
	mov r12, r8
	sub r12, 10
	;xor al, al
	mov al, [extraletters + r12]
	mov byte [output + rcx], al
	inc rcx

	shr r9, 4
	mov r8, r9
	jmp divOperation

onetime:
	;mov al, r9b
	;add al, '0'
	;mov r12, r9
	sub r9, 10
	mov al, [extraletters + r9]
	mov byte [output + rcx], al
	print revString, revStringlength
	print output, 20
	print newline, 1
	exit 0

done:
	;shr r9, 4
	cmp r9, 10
	jge onetime

	add r9b, '0'
	mov byte [output + rcx], r9b
	print revString, revStringlength
	print output, 20
	print newline, 1
	exit 0


