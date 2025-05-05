; this code checks whether a string is a palindrome

%include "mymacros.inc"


section .data
	prompt db "Enter string here: ",0
	promptlength equ $ - prompt
	isPalindrome db "The string is a Palindrome", 10, 0
	islength equ $ - isPalindrome
	isnotPalindrome db "The string is not a Palindrome", 10, 0
	notlength equ $ - isnotPalindrome

section .bss
	inputString resb 20

section .text
	global _start

_start:
	print prompt, promptlength
	getinput inputString, 20
	mov r8, rax ; the length of the input string
	
	sub r8, 2 ; skip the null terminator
	mov r9, 0 ; from the front
	jmp check

check:
	mov bl, [inputString + r8]
	mov al, [inputString + r9]

	cmp al, bl
	jne notPal

	dec r8
	inc r9

	cmp r8, -1
	je isPal

	jmp check

notPal:
	print isnotPalindrome, notlength
	exit 1

isPal:
	print isPalindrome, islength
	exit 0
