section .data
	prompt db "Enter (c)reate, (r)ead, (u)pdate (d)elete, task or (e)xit: ", 0
	promptLen equ $ - prompt
	choiceArray db 'crude', 0	;'c','r','u','d','e'
	choiceArrayLen equ 5
	newline db 10, 0
	not_found_msg db "Invalid Choice", 10, 0
	not_found_msglen equ $ - not_found_msg 
	filename db "todolist.txt", 0
	createprompttext db "Enter task here: ", 0
	createprompttextlen equ $ - createprompttext
	printbuffer times 1024 db 0
	upprompt db "Enter line number for update: ", 0
	uppromptLen equ $ - upprompt
	uppprompt db "Enter the update task: ", 0
	upppromptLen equ $ - uppprompt
        delprompt db "Enter line number for deletion: ", 0
        delpromptLen equ $ - delprompt
	debug_message db "Success ", 10, 0
	debug_length equ $ - debug_message
	secondfilename db "temp.txt", 0
	upsuccess db "Update Successful!", 10, 0
	upsuccesslen equ $ - upsuccess
         delsuccess db "Deletion Successful!", 10, 0
	delsuccesslen equ $ - delsuccess
	tempbuffer times 1024 db 0

section .bss
	choice resb 3 ; Reserve 10 bytes for user input
	createText resb 30	; Reserve 31 bytes for user input for task creation
	upchoice resb 2 ; Reserve 2 bytes for user input in update
	upval resb 1024
	temp_byte resb 1 ; Temporary storage for writing a single byte
        

section .text
	global _start



_start:
	call _printchoiceprompt
	call _readuserinput

	
	mov al, [choice]

	mov rsi, 0
	mov rcx, choiceArrayLen
	jmp check_loop

check_loop:
	cmp rsi, rcx
	jge not_found
	mov bl, [choiceArray + rsi]
	cmp al, bl
	je found
	inc rsi
	jmp check_loop

not_found:
	; Printing 'Invalid Choice'
	mov rax, 1
	mov rdi, 1
	mov rsi, not_found_msg
	mov rdx, not_found_msglen
	syscall
	jmp _exit

found:
	;fix code here
	cmp rsi, 0
	je _creating
	cmp rsi, 1
	je _reading
	cmp rsi, 2
	je _updating
	cmp rsi, 3
	je _deleting
	cmp rsi, 4
	je _exit


_printchoiceprompt:
	; Print the prompt "Enter the (c)reate ..."
	mov rax, 1
	mov rdi, 1
	mov rsi, prompt
	mov rdx, promptLen
	syscall
	ret

_readuserinput:
	; Read user input on whether choice is 'c','r','u','d', or 'e'
	mov rax, 0
	mov rdi, 0
	mov rsi, choice
	mov rdx, 3
	syscall
	ret

_creating:
	; Print the prompt 'enter the task here'
	mov rax, 1
	mov rdi, 1
	mov rsi, createprompttext
	mov rdx, createprompttextlen
	syscall
	

        ; accept user input into variable createText and store length in r14
	mov rax, 0
	mov rdi, 0
	mov rsi, createText
	mov rdx, 30
	syscall
        mov r14, rax ; store in r14
        

        jmp _createwritefile

;;;;;;;;;;;; solved problem after changing rcx to r14, I am not returning to nasm 64 again. took me over a 1 month of depression

;;;;;;;;;;;; apparently registers have their unique purposes

_createwritefile:
        ; open (or create if not exists) todolist.txt with permissions 777 and store file descriptor in r12
	mov rax, 2
	mov rdi, filename
	mov rsi, 0x441     ;0x441
	mov rdx, 0777o
	syscall
        mov r12, rax ; store file descriptor in r12
        
        ; write createText chars into todolist.txt
        mov rax, 1
        mov rdi, r12
        mov rsi, createText
        mov rdx, r14
        syscall

     
        ; close todolist.txt
        mov rax, 3      ; sys_close is 3
        mov rdi, r12
        syscall
	
	jmp _start


_reading:
        ; open todolist.txt and store its file descriptor in r12
	mov rax, 2
	mov rdi, filename
	mov rsi, 0
	syscall
	test rax, rax ; check whether opening failed
	js error
	mov r12, rax ; store file descriptor in r12
	jmp read_loop

read_loop:
        ; read todolist.txt and read into printbuffer to display later
	mov rax, 0
	mov rdi, r12
	mov rsi, printbuffer
	mov rdx, 1024
	syscall
	jc error ; check whether error occurred in reading into printbuffer
	;cmp rax, 0
	;jle close_file_read
	test rax, rax ; check error 
	jz close_file_read
	js error

	push rax
        ; write to stdout printbuffer which now contains chars of todolist.txt
	mov rdx, rax
	mov rax, 1
	mov rdi, 1
	mov rsi, printbuffer
	
	syscall
	pop rax
	jc error
	jmp read_loop


close_file_read:
        ; close todolist.txt
	mov rax, 3
	mov rdi, r12
	syscall
	jmp _start

error:
	; exit with status 1
	mov rax, 60
	mov rdi, 1
	syscall


_updating:
	; Print the prompt 'enter line number'
	mov rax, 1
	mov rdi, 1
	mov rsi, upprompt
	mov rdx, uppromptLen
	syscall

	; Read user input in update line
	mov rax, 0
	mov rdi, 0
	mov rsi, upchoice
	mov rdx, 2
	syscall

	; Print the prompt 'enter the update task'
	mov rax, 1
	mov rdi, 1
	mov rsi, uppprompt
	mov rdx, upppromptLen
	syscall

	; Read user input in update
	mov rax, 0
	mov rdi, 0
	mov rsi, upval
	mov rdx, 1024
	syscall

	mov r14, rax ; Store actual length of upval input
        

	; Open todolist.txt file
	mov rax, 2
	mov rdi, filename
	mov rsi, 0 	; O_RONLY 
	syscall
	test rax, rax
	js error
	mov r12, rax ; store file descriptor in r12

	; Open temp file or dest file with permissions 644
	mov rax, 2
	mov rdi, secondfilename
	mov rsi, 577
	mov rdx, 0644o
	syscall

	mov r13, rax ; store file descriptor of temp.txt in r13

	;xor rbx, rbx
	jmp read_text

read_text:
        ; read all chars of todolist.txt into tempbuffer
	mov rax, 0
	mov rdi, r12
	mov rsi, tempbuffer
	mov rdx, 1024
	syscall
        mov r15, rax ; store file descriptor into r15
	; check if eof reached
	test rax, rax
	jz close_files
	xor r8, r8 ; zero r8 just in case
	
	jmp _initvar

_initvar:
        ; convert upchoice first char into integer for r9
	xor r10, r10
	inc r10
	movzx r9, byte [upchoice]
	sub r9, 48
        jmp _uploop
        
_uploop:
        ; check whether we are at the end
	cmp r8, r15
	jge close_files

	movzx rbx, byte [tempbuffer + r8] ; one character of tempbuffer at a time

	cmp rbx, 10 ; check if the character is a newline if yes go to cond_line if no skip next line
	je cond_line

	; write each character to dest file or temp.txt
	mov rax, 1
	mov rdi, r13
	mov [temp_byte], bl ; store the byte in memory
	mov rsi, temp_byte
	mov rdx, 1
	syscall
	
	inc r8 ; increase r8 so that line 284 can go to the next character

	jmp _uploop

cond_line:
        ; r10 checks for the newlines
	inc r10
	cmp r10, r9 ; if newline corresponding to upchoice integer, then immediate next line else skip next line
	je write_line
	
	inc r8

        ; write characters as usual
	mov byte [temp_byte], 10
	mov rsi, temp_byte
	mov rdx, 1
	mov rax, 1
	mov rdi, r13
	syscall

	; add a newline character here i think
	jmp _uploop

write_line:
        ; print newline character
	mov rax, 1
	mov rdi, r13
	mov rsi, newline
	mov rdx, 1
	syscall

	; write modified line to dest file or temp.txt
	mov rax, 1
	mov rdi, r13
	mov rsi, upval
	mov rdx, r14
	syscall
        
	jmp _skipuntilnewline

_skipuntilnewline:
        ; skips until a newline character is found before going back to uploop through the _increase label
	inc r8
	cmp r8, r15
	jge close_files

	movzx rbx, byte [tempbuffer + r8]

	cmp bl, 10
	je _increase
     
        ;movzx rbx, byte [tempbuffer + r8]
	jmp _skipuntilnewline

_increase:
        inc r8
        ;inc r8
        jmp _uploop
        
close_files:
	; Print success
	mov rax, 1
	mov rdi, 1
	mov rsi, upsuccess
	mov rdx, upsuccesslen
	syscall

	; Close source file or todolist.txt
	mov rax, 3
	mov rdi, r12
	syscall

	; close destination file or temp.txt
	mov rax, 3
	mov rdi, r13
	syscall

        ; delete source or todolist.txt
        mov rax, 87
        lea rdi, [filename]
        syscall
        
        ; rename destination file or temp.txt as todolist.txt
        mov rax, 82             ; syscall for rename
        lea rdi, [secondfilename] ; old filename
        lea rsi, [filename]     ; new filename
        syscall

	jmp _start



; deleting essentially follows the same route as update except instead of writing an update we just newline and skipping until another newline and continue writing
_deleting:
	; Print the prompt
	mov rax, 1
	mov rdi, 1
	mov rsi, delprompt
	mov rdx, delpromptLen
	syscall

	; Read user input in update line
	mov rax, 0
	mov rdi, 0
	mov rsi, upchoice
	mov rdx, 2
	syscall

        ; Open file
	mov rax, 2
	mov rdi, filename
	mov rsi, 0 	; O_RONLY 
	syscall
	test rax, rax
	js error
	mov r12, rax

	; Open temp file
	mov rax, 2
	mov rdi, secondfilename
	mov rsi, 577
	mov rdx, 0644o
	syscall

	mov r13, rax

        jmp dread_text
        
        
dread_text:
	mov rax, 0
	mov rdi, r12
	mov rsi, tempbuffer
	mov rdx, 1024
	syscall
        mov r15, rax
	; check if eof reached
	test rax, rax
	jz dclose_files
	xor r8, r8
	
	jmp _dinitvar

_dinitvar:
	xor r10, r10
	inc r10
	movzx r9, byte [upchoice]
	sub r9, 48
        jmp _duploop
        
_duploop:

	cmp r8, r15
	jge dclose_files

	movzx rbx, byte [tempbuffer + r8]

	cmp rbx, 10
	je dcond_line

	; write to dest file
	mov rax, 1
	mov rdi, r13
	mov [temp_byte], bl ; store the byte in memory
	mov rsi, temp_byte
	mov rdx, 1
	syscall
	
	inc r8 

	jmp _duploop

dcond_line:
	inc r10
	cmp r10, r9
	je dwrite_line
	
	inc r8

	mov byte [temp_byte], 10
	mov rsi, temp_byte
	mov rdx, 1
	mov rax, 1
	mov rdi, r13
	syscall

	; add a newline character here i think
	jmp _duploop

dwrite_line:

        ; print newline
	mov rax, 1
	mov rdi, r13
	mov rsi, newline
	mov rdx, 1
	syscall

        jmp _dskipuntilnewline


_dskipuntilnewline:
	inc r8
	cmp r8, r15
	jge dclose_files

	movzx rbx, byte [tempbuffer + r8]

	cmp bl, 10
	je _dincrease
     
       
	jmp _dskipuntilnewline

_dincrease:
        inc r8
      
        jmp _duploop
        
dclose_files:
	; Print success
	mov rax, 1
	mov rdi, 1
	mov rsi, delsuccess
	mov rdx, delsuccesslen
	syscall

	; Close source file
	mov rax, 3
	mov rdi, r12
	syscall

	; close destination file
	mov rax, 3
	mov rdi, r13
	syscall

        ; delete source or todolist.txt
        mov rax, 87
        lea rdi, [filename]
        syscall
        
        ; rename destination file or temp.txt as todolist.txt
        mov rax, 82             ; syscall for rename
        lea rdi, [secondfilename] ; old filename
        lea rsi, [filename]     ; new filename
        syscall

	jmp _start

_exit:
	; Exit
	mov rax, 60
	xor rdi, rdi
	syscall
