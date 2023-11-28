; ** .DATA **
section .data
    path_buffer     db 255      ; Buffer to store the path
    newline         db 10       ; Newline character

; ** .TEXT **
section .text
    global _start


_start:
    ; Syscall to get current working directory
    mov rax, 79             ; syscall number for getcwd
    mov rdi, path_buffer    ; pointer ot buffer for storing the path string returned
    mov rsi, 255            ; size of the buffer
    syscall

    ; Print the path
    mov rax, 1              ; syscall number for write
    mov rdi, 1              ; file descriptor for stdout
    lea rsi, [path_buffer]  ; pointer to the path buffer


    ; clear rcx to use it as a counter
    xor rcx, rcx 

    ; Find the length of the valid string in path_buffer
find_length:
    cmp byte [rsi + rcx], 0
    je  print_path
    inc rcx
    jmp find_length


print_path:
    mov rdx, rcx         ; size of the valid path
    syscall

    ; Display a new line
    mov rdi, 1                   ; file descriptor 1 for stdout
    mov rsi, [newline]           ; address of the newline character
    mov rdx, 1                   ; length of the newline character
    mov rax, 1                   ; system call number for sys_write
    syscall
    
    ; exit the program
    mov rax, 60          ; syscall number for exit
    xor rdi, rdi         ; exit code 0
    syscall

