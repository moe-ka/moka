%define MULTIBOOT_HEADER_FLAGS (MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_VIDEO_MODE)
%define MULTIBOOT_HEADER_CHECKSUM -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

; multiboot header
SECTION .multiboot align=MULTIBOOT_HEADER_ALIGN
	dd MULTIBOOT_HEADER_MAGIC
	dd MULTIBOOT_HEADER_FLAGS
	dd MULTIBOOT_HEADER_CHECKSUM
	times 5 dd 0 ; padding because elf
	; video mode parameters
	dd 1 ; mode type
	dd 1024 ; width
	dd 768 ; height
	dd 32 ; depth

; allocate stack
SECTION .bss align=16
stack_bottom:
resb 16384 ; 16 KiB
stack_top:

SECTION .text
	global _start:function (_start.end - _start)
_start:
	mov esp, stack_top ; setup stack
	
	; OTHER CPU SETUP (enable paging, etc...)
	; Reset EFLAGS. 
	push 0
	popf
	; push mbi* and align stack.
	push 0
	push ebx
	
	; note: ABI requires stack 16 byte alignment before this call
	extern kernel_main
	call kernel_main
 
	; infinite loop
	cli
.hang:	hlt
	jmp .hang
.end:
