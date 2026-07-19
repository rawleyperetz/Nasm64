
; how to run this code
; nasm -f elf64 ./stddev.asm -o ./stddev
; ./run.sh ./stddev


%include "mymacros.inc"

extern atof
extern printf

section .data
	error              db "At least two cmd line args needed", 10, 0
	errorlen           equ $ - error
	newline			   db 10

	MAX_SIZE           equ 100	; Maximum number of floats the array can hold
	array_count        dq  0		; Tracks the current number of elements appended to array
	
	stddev_fmt         db "Std deviation = %f", 10, 0
	mean_fmt           db "Mean = %f", 10, 0
	var_fmt			   db "Variance = %f", 10, 0
	array_full_fmt     db "Array is full, re-adjust MAX_SIZE in code",10, 0
	array_full_fmt_len equ $ - array_full_fmt
	
section .bss
	float_array    resq MAX_SIZE   ; Reserve space for 100 double-precision floating point numbers
	meanValue	   resq 1   	   ; Reserve space for the mean value
	stddevValue	   resq 1 		   ; Reserve space for the standard deviation value
	varValue	   resq 1

	output		   resb 20
	
section .text
	global _start


	
Stddev:
	xorpd xmm2, xmm2 ; this will contain the mean
	xor rcx, rcx  ; floating array loop counter

	
.meanLoop:
	cmp rcx, [array_count]
	je .computestd
	
	addsd xmm2, [float_array + rcx * 8]
	inc rcx

	jmp .meanLoop

.computestd:
	divsd xmm2, xmm0
	movsd [meanValue], xmm2 ; move the mean value in xmm2 to meanValue reserved space
	xor rcx, rcx  ; reset floating array loop counter

	xorpd xmm2, xmm2 ; reset xmm2, this will contain the sum difference of points and mean
	xorpd xmm3, xmm3 ; to hold the difference between points and mean

.sumDiff:
	cmp rcx, [array_count]
	je .divNAndSQRT

	movsd xmm3, [float_array + rcx * 8]
	subsd xmm3, [meanValue]   ; better way is to keep meanValue in an xmm register for better performance
	mulsd xmm3, xmm3
	addsd xmm2, xmm3

	inc rcx

	jmp .sumDiff

.divNAndSQRT:
	divsd xmm2, xmm0
	movsd [varValue], xmm2
	sqrtsd xmm2, xmm2

	movsd [stddevValue], xmm2
	jmp .stddone

.stddone:
	movsd xmm0, [stddevValue]
	lea rdi, [rel stddev_fmt]
    mov al, 1   		; 1 because we are passing only 1 floating point value
    call printf

    movsd xmm0, [varValue]
	lea rdi, [rel var_fmt]
    mov al, 1   		; 1 because we are passing only 1 floating point value
    call printf

    movsd xmm0, [meanValue]
    lea rdi, [rel mean_fmt]
    mov al, 1   		; 1 because we are passing only 1 floating point value
    call printf
	ret
	

_start:
	mov r12, [rsp]

	cmp r12, 3
	jge PrepValues  ; at least 3 cmd args including program name

	print error, errorlen
	exit 1

PrepValues:


	mov r13, 1  ; Using a non-volatile register for looping through argc i.e. rsp

	dec r12

ArgcLoop:
	cmp r13, r12
	jg computeParameters
	
	; U_n = a + (n-1)*d where a is 8 and d is 8
	mov r14, r13
	dec r14
	imul r14, 8
	add r14, 16
	
	mov rdi, [rsp + r14]

	sub rsp, 8 ; rsp currently ends in 8. subtracting 8 makes it end in 0 (16-byte alignment)
	call atof
	; Before exiting or returning, restore stack if needed
	add rsp, 8
		
	mov r15, [array_count]
	cmp r15, MAX_SIZE
	jge ArrayFull

	; Since each double is 8 bytes (qword), offset = current_count * 8
	movsd [float_array + r15 * 8], xmm0

	;print_num output, [rsp+r14]
	; increase counter
	inc r15
	mov [array_count], r15

	inc r13
	jmp ArgcLoop

computeParameters:
	;movsd xmm0, float_array
	print_num output, qword[array_count]
	print newline, 1
		
	cvtsi2sd xmm0, qword [array_count]

	sub rsp, 8
    call Stddev
	add rsp, 8
	

exitSuccess:	
	exit 0
	
ArrayFull:
	print array_full_fmt, array_full_fmt_len
	jmp exitSuccess
	

