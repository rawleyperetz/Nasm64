
; how to run this code
; nasm -f elf64 ./projectile_motion_func.asm -o ./projectile_motion_func
; gcc ./projectile_motion_func.o -o ./projectile_motion_func -lm


%include "mymacros.inc"

extern atof
extern printf
extern sin
extern cos

section .data
	error db "Two cmd line args needed", 0, 10
	errorlen equ $ - error

	PI		  dq 3.14159265359
	g         dq 9.8 ; this is gravity due to acceleration
	two       dq 2.0
	eight     dq 8.0
	oneeighty dq 180.0
	two_g	  dq 19.6
	
	tf_fmt    db "Time of Flight = %f", 10, 0
	mH_fmt    db "Max Height = %f", 10, 0
	range_fmt db "Range = %f", 10, 0
	
section .bss
	vy			   resq 1
	vx			   resq 1
	velocity       resq 1
	angleInRadians resq 1
	tflight        resq 1
	maxH		   resq 1
	range 		   resq 1

section .text
	global _start


	
calculateProjectileValues:
	movsd xmm0, [angleInRadians]
	call sin

	; vy = v0 sin theta where v0 is the given velocity
	movsd xmm1, [velocity]
	mulsd xmm0, xmm1
	movsd [vy], xmm0

	; time of flight = 2vy / g
	mulsd xmm0, [two]
	divsd xmm0, [g]
	movsd [tflight], xmm0

    ; max height = vy^2 / 2g
	movsd xmm0, [vy]
	mulsd xmm0, xmm0
	divsd xmm0, [two_g]
	movsd [maxH], xmm0

	; cos theta
	movsd xmm0, [angleInRadians]
	call cos

	; vx = v0 cos theta where v0 is the given velocity
	movsd xmm1, [velocity]
	mulsd xmm0, xmm1
	movsd [vx], xmm0

	; horizontal range = vx tflight    or v0^2 sin(2theta)/g
	mulsd xmm0, [tflight]
	movsd [range], xmm0

	movsd xmm0, [tflight]
	lea rdi, [rel tf_fmt]
    mov al, 1   		; 1 because we are passing only 1 floating point value
    call printf

    movsd xmm0, [maxH]
   lea rdi, [rel mH_fmt]
   mov al, 1   		; 1 because we are passing only 1 floating point value
   call printf

   movsd xmm0, [range]
   lea rdi, [rel range_fmt]
   mov al, 1   		; 1 because we are passing only 1 floating point value
   call printf
	ret

convertToRadians:
   mulsd xmm0, [PI]
	divsd xmm0, [oneeighty]
	ret
	

_start:
	mov r12, [rsp]

	cmp r12, 3
	je PrepValues

	print error, errorlen
	exit 1

PrepValues:
	sub rsp, 8 ; rsp currently ends in 8. subtracting 8 makes it end in 0 (16-byte alignment)
	
	mov rdi, [rsp + 24]
	call atof
	movsd [velocity], xmm0

	mov rdi, [rsp + 32]
	call atof
	;movsd [angleInDegrees], xmm0

	call convertToRadians

	 ; following System-V ABI style
	movsd [angleInRadians], xmm0
   ;movsd xmm0, [angleInRadians]
   movsd xmm1, [velocity]
   
   call calculateProjectileValues

	; Before exiting or returning, restore stack if needed
	add rsp, 8
	
exitSuccess:	
	exit 0
