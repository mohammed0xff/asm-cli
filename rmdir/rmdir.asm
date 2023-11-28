; ** .DATA **
section .data
    newline             db  10       ; Newline character
    success_message     db  "Directory removed successfully", 0
    success_message_len equ $ - success_message
    error_message       db  "Error removing directory", 0
    error_message_len   equ $ - error_message


; ** .TEXT **
section .text
    global _start

_start:
	mov rax, qword [rsp]        ; load argc into rax
    cmp rax, 2                  ; checks if there are at least two command-line arguments (argc >= 2)
    							; (including the program name)
    jl  exit		            ; and jump to exit if not enough arguments

    ; Get the directory name from the command-line argument
    mov rsi, [rsp + 16]          ; address of the command-line argument (directory name)

    ; Remove the directory
    mov rax, 84                  ; system call number for sys_rmdir
    mov rdi, rsi                 ; pointer to the directory name
    syscall

    ; Check for errors 
    cmp rax, 0                   ; check if rax is non-negative (success)
    jl error                     ; jump to error if an error occurred

    ; Display success message
    mov rdi, 1                   ; file descriptor 1 for stdout
    mov rsi, success_message     ; address of the success message
    mov rdx, success_message_len ; length of the success message
    mov rax, 1                   ; system call number for sys_write
    syscall
    
    jmp exit


error:
    ; Display error message
    mov rdi, 2                   ; file descriptor 2 for stderr
    mov rsi, error_message       ; address of the error message
    mov rdx, error_message_len   ; length of the error message
    mov rax, 1                   ; system call number for sys_write
    syscall


exit:
    ; Display a new line '\n'
    mov rax, 1                   ; system call number for sys_write
    mov rdi, 1                   ; file descriptor 1 for stdout
    mov rsi, newline             ; address of the newline character
    mov rdx, 1                   ; length of the newline character
    syscall

    xor rdi, rdi                   ; System call number for sys_exit
    mov rax, 60                    ; Exit code 0
    syscall
