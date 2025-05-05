; to add macro to your project you need
; %include "mymacros.inc" at the top like a header file

%macro print 2
	mov rax, 1 ; sys_write
	mov rdi, 1 ; stdout
	mov rsi, %1 ; pointer to string
	mov rdx, %2 ; length
	syscall
%endmacro

%macro getinput 2
	mov rax, 0 ; sys_read
	mov rdi, 0 ; stdin
	mov rsi, %1 ; pointer to string
	mov rdx, %2 ; length
	syscall
%endmacro

%macro print_num 2
	mov rcx, 10
	mov rbx, %1
	add rbx, 19
	mov byte [rbx], 0
	mov rax, %2

.next_digit:
	dec rbx
	xor rdx, rdx ; clear remainder
	div rcx
	add dl, '0'
	mov [rbx], dl
	test rax, rax
	jnz .next_digit

	mov rax, 1
	mov rdi, 1
	mov rsi, rbx
	mov rdx, %1
	add rdx, 20
	sub rdx, rbx
	syscall
%endmacro

%macro exit 1
	mov rax, 60
	mov rdi, %1
	syscall
%endmacro
