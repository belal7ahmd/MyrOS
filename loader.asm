global loader
extern kmain

MAGIC_NUMBER equ 0x1BADB002 ; define the magic number constant
FLAGS equ 0x0               ; multiboot flags
CHECKSUM equ -MAGIC_NUMBER  ; calculate the checksum
                            ; (magic number + checksum + flags should equal 0)

KERNEL_STACK_SIZE equ 4096  ; stack size in bytes

section .bss
align 4                     ; align it for SPEED
kernel_stack:               
    resb KERNEL_STACK_SIZE  ; reserve the stack


section .text               
multiboot:                                 
align 4
    dd MAGIC_NUMBER         
    dd FLAGS                
    dd CHECKSUM             

loader:                 ; the loader label (defined as entry point in linker script)
    mov esp, kernel_stack + KERNEL_STACK_SIZE; set the stack pointer
    
    call kmain          ; call main function

.loop:
    jmp .loop               ; loop forever