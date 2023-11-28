; **  .DATA  **
section .data
    error_message       db  "Couldn't Read File :(", 0
    error_message_len   equ $ - error_message
    newline             db  10       ; Newline character '\n'
	buffer_size equ     5120 		 ; 5 KBs 
	 

; **  .BSS  **
section .bss
	buffer resb 5120


; **  .TEXT  **
section .text
	global _start

_start:    
	mov rax, qword [rsp]        ; load argc into rax
    cmp rax, 2                  ; checks if there are at least two command-line arguments (argc >= 2)
    							; (including the program name)
    jl  exit		            ; and jump to exit if not enough arguments


open: 
	mov rax, 2			; specify open syscall number	
	mov rdi, [rsp+16]	; placing argv[1] (the file name) in dest index for syscall (as a frist argument)
	mov rsi, 0			; setting flags to 0 in src index, read only (as a second argument) 
	mov rdx, 0			; setting mode specification (as a third argument)
	syscall			


	; check for errors
	cmp rax, 0		; rax contains the return value	
	jl error		; if the return value is less than zero, we got an error!
	mov rbx, rax	; saving file descriptor into rbx where it is safe across calls


read:
	; try read the file
	mov rax, 0				; specify read syscall number 
	mov rdi, rbx			; placing file descriptor into 
	mov rsi, buffer			; moving buffer address to rsi 
	mov rdx, buffer_size	; specity to read 256 bytes 
	syscall			


	cmp rax, 0		; check for EOF 
	jl error		; if less than zero, error 
	jne print		; if not EOF, jump over to print 



print:	
	; Print file contents 
	mov rdx, rax		; mov number of bytes read to rdx
	mov rax, 1			; specify print (sys_write) syscall 
	mov rdi, 1			; specify stdout file descriptor 
	mov rsi, buffer		; mov buffer address to rsi to prepare for printing syscall
	syscall			
	

	cmp rax, 0		; check for errors
	jl error		; if less than zero, error


close:
	; Close file and jump to exit 
	mov rax, 3			; specify close syscall 
	mov rdi, rbx		; specify file descriptor 
	Syscall

	cmp rax, 0		; check for errors 
	jl error		; if less than zero, error 
	jmp exit


error:
    ; Display error message
    mov rdi, 2                   ; file descriptor 2 is stderr
    mov rsi, error_message       ; address of the error message
    mov rdx, error_message_len   ; length of the error message
    mov eax, 1                   ; system call number for sys_write
    syscall


exit:
    ; Display a new line '\n'
    mov eax, 1                   ; system call number for sys_write
    mov rdi, 2                   ; file descriptor 2 is stderr
    mov rsi, newline             ; address of the newline character
    mov rdx, 1                   ; length of the newline character
    syscall

	mov rax, 60			; specify read syscall number for sys_exit
	xor rdi, rdi		; exit code 0
	syscall			