; ** .DATA **
section .data
    mode                dd  775o     ; File permissions (rwx-rwx-r-x)
    newline             db  10       ; Newline character '\n'
    success_message     db  "File created successfully", 0
    success_message_len equ $ - success_message
    error_message       db  "Error creating file", 0
    error_message_len   equ $ - error_message


; ** .TEXT **
section .text
    global _start

_start:
	mov rax, qword [rsp]        ; load argc into rax
    cmp rax, 2                  ; checks if there are at least two command-line arguments (argc >= 2)
    							; (including the program name)
    jl  exit		            ; and jump to exit if not enough arguments


    ; Get the file name from the command-line argument
    mov rsi, [rsp + 16]          ; Address of the command-line argument (file name)

    ; Open or create the file
    mov rax, 85                  ; system call number for sys_open
    mov rdi, rsi                 ; pointer to the file name
    movzx rsi, word [mode]       ; permissions -> 2nd param
    syscall

    ; Check for errors (rax contains the return value)
    cmp rax, 0                   ; Check if rax is non-negative (success)
    jl error              ; Jump to error if an error occurred

    ; Close the file descriptor
    mov rax, 3                   ; system call number for sys_close
    mov rdi, rax                 ; file descriptor to close
    syscall

    ; Display success message
    mov rdi, 1                   ; file descriptor 1 is stdout
    mov rsi, success_message     ; address of the success message
    mov rdx, success_message_len ; length of the success message
    mov rax, 1                   ; system call number for sys_write
    syscall

    jmp exit


error:
    ; Display error message
    mov rdi, 2                   ; file descriptor 2 is stderr
    mov rsi, error_message       ; address of the error message
    mov rdx, error_message_len   ; length of the error message
    mov rax, 1                   ; system call number for sys_write
    syscall


exit:
    ; Display a new line '\n'
    mov rax, 1                   ; system call number for sys_write
    mov rdi, 2                   ; file descriptor 2 is stderr
    mov rsi, newline             ; address of the newline character
    mov rdx, 1                   ; length of the newline character
    syscall

    xor rdi, rdi                 ; System call number for sys_exit
    mov rax, 60                  ; Exit code 0
    syscall
