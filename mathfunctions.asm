
global factorial
global strlength

;-------------------------
; Factorial function
;------------------------
factorial:
	cmp rdi, 0
	jl .negValue
	je .exactlyZero

	mov rax, 1
	mov rcx, 1
	
.loop:
	cmp rcx, rdi
	je .done

	inc rcx
	imul rax, rcx

	jmp .loop
	

.done:
	ret	

.exactlyZero:
	mov rax, 1
	ret

.negValue:
	mov rax, 0
	ret


;-------------------------
; String Length function
;------------------------
strlength:
	xor rax, rax       ; accumulator / return register is initialized to zero

.loop:
	cmp byte [rdi + rax], 0
	je NullTerm
	
	inc rax

	jmp .loop

NullTerm:
	ret

section .note.GNU-stack noalloc noexec nowrite progbits
