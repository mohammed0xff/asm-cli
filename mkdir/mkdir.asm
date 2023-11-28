; ** .DATA **
section .data
    mode                dd  775o     ; Directory permissions (rwx-rwx-r-x)  
    newline             db  10       ; Newline character '\n'
    success_message     db  "Directory created successfully", 0
    success_message_len equ $ - success_message
    error_message       db  "Error creating directory", 0
    error_message_len   equ $ - error_message


; ** .TEXT **
section .text
    global _start


_start:
    ; Load argc into rax
    mov rax, qword [rsp]
 	; Check if argc >= 2 & there is at least one command-line argument - including the program name -
    cmp rax, 2
    jl exit    ; jump to exit if not enough arguments

    ; Get the directory name from the command-line argument
    mov rsi, [rsp + 16]          

    ; Create the directory
    mov rax, 83                  ; system call number for sys_mkdir
    mov rdi, rsi                 ; pointer to the directory name
    movzx rsi, word [mode]       ; permissions -> 2nd param
    syscall

    ; Check for errors 
    cmp rax, 0                   ; check if rax is non-negative (success)
    jl error                     ; jump to error if an error occurred


success:
    ; Display success message
    mov rdi, 1                   ; file descriptor 1 is stdout
    mov rsi, success_message     ; address of the success message
    mov rdx, success_message_len ; length of the success message
    mov eax, 1                   ; system call number for sys_write
    syscall
    
    jmp exit


error:
    ; Display error message
    mov rdi, 2                   ; file descriptor 2 is stderr
    mov rsi, error_message       ; address of the error message
    mov rdx, error_message_len   ; length of the error message
    mov eax, 1                   ; system call number for sys_write
    syscall


exit:
    ; Display newline
    mov rdi, 1                   ; file descriptor 1 is stdout
    mov rsi, newline             ; address of the newline character
    mov rdx, 1                   ; length of the newline character
    mov eax, 1                   ; system call number for sys_write
    syscall

    ; Exit program
    xor rdi, rdi                   ; system call number for sys_exit
    mov rax, 60                  ; exit code 0
    syscall

