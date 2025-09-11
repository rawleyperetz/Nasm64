; this code prints the uptime since boot

%include "mymacros.inc"

section .data
	uptime db "Total seconds since system boot: ", 0
	uptime_len equ $ - uptime
	idleTime db "Total seconds all CPUs have spent idle: ", 0
	idleTime_len equ $ - idleTime

	filename db "/proc/uptime", 0
	file_error db "Error opening the /proc/uptime file", 0, 10
	file_error_len equ $ - file_error

	newline db 10

section .bss
	allchars resb 64
	uptime_var resb 32
	idleTime_var resb 32


section .text
	global _start

_start:
	; opening the /proc/uptime file
	mov rax, 2
	mov rdi, filename
	mov rsi, 0
	syscall

	; check whether opening failed
	test rax, rax
	js error

	; store file descriptor in r12
	mov r12, rax

	; reading file content
	jmp read_file


read_file:
	; read all chars of /proc/uptime file into allchar variable
	mov rax, 0
	mov rdi, r12
	mov rsi, allchars
	mov rdx, 64
	syscall

	; move file descriptor into r15
	mov r15, rax

	; check if eof reached
	test rax, rax
	jz close_file

	; initialize variables
	xor r8, r8

getUptime:
	mov al, byte [allchars + r8]
	mov byte [uptime_var + r8], al

	cmp al, 32
	je printUptime

	inc r8
	jmp getUptime

printUptime:
	print uptime, uptime_len
	print uptime_var, r8
	print newline, 1
	mov r9, r8
	inc r8

getIdle:
	mov al, byte [allchars + r8]
	mov byte [idleTime_var + r8], al

	cmp al, 0x20
	je printIdle

	inc r8
	jmp getIdle

printIdle:
	print idleTime, idleTime_len
	sub r8, r9
	print idleTime_var, r8
	;print newline, 1
	exit 0

close_file:
	; close /proc/uptime file
	mov rax, 3
	mov rdi, r12
	syscall
	exit 0

error:
	print file_error, file_error_len
	exit 1
