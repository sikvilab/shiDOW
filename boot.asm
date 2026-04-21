bits 16
org 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; enable A20
    in   al, 0x92
    or   al, 00000010b
    out  0x92, al

    ; load GDT
    lgdt [gdt_descriptor]

    ; switch to protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:protected_mode

; ---------------- GDT ----------------
align 4
gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; ---------------- Protected mode ----------------
bits 32
protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x9FC00

    extern kernel_main
    call kernel_main

.hang:
    cli
    hlt
    jmp .hang

times 510-($-$$) db 0
dw 0xAA55
