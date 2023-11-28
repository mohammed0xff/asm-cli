; ** .DATA **
section .data
    newline         db  10       ; Newline character

; ** .TEXT **
section .text
    global _start


_start:
    
	mov rax, qword [rsp]        ; load argc into rax
    cmp rax, 2                  ; checks if there are at least two command-line arguments (argc >= 2)
    							; (including the program name)
    jl  exit		            ; and jump to exit if not enough arguments


ehco:
    ; Display output (command-line argument)
    
    mov rsi, [rsp + 16]          ; placing argv[1] (the input string) into si

    ; Calculate the length of the string
    
    xor rdx, rdx                 ; clear rdx to use it as a counter

    find_length:
        cmp byte [rsi + rdx], 0  ; check for the null terminator 0
        je  found_length          ; if null terminator found, exit loop
        inc rdx                   ; increment the counter
        jmp find_length           ; continue loop
    found_length:

    ; Display output
    mov rdi, 1                   ; file descriptor 1 is stdout
    mov eax, 1                   ; system call number for sys_write
    syscall

    ; Display a new line
    mov rdi, 1                   ; file descriptor 1 is stdout
    mov rsi, newline             ; address of the newline character
    mov rdx, 1                   ; length of the newline character
    mov eax, 1                   ; system call number for sys_write
    syscall


exit:
    xor rdi, rdi                   ; system call number for sys_exit
    mov rax, 60                    ; exit code 0
    syscall

