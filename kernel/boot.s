%define MULTIBOOT_HEADER_FLAGS (MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_VIDEO_MODE)
%define MULTIBOOT_HEADER_CHECKSUM -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)
%define KERNEL_VIRTUAL_BASE 0xC0000000
%define KERNEL_PAGE_NUMBER (KERNEL_VIRTUAL_BASE >> 22)

; multiboot header
SECTION .multiboot.data ALIGN=MULTIBOOT_HEADER_ALIGN
	dd MULTIBOOT_HEADER_MAGIC
	dd MULTIBOOT_HEADER_FLAGS
	dd MULTIBOOT_HEADER_CHECKSUM
	times 5 dd 0 ; padding because elf
	; video mode parameters
	dd 1 ; mode type
	dd 1920 ; width
	dd 1080 ; height
	dd 32 ; depth


SECTION .data ALIGN=0x1000
boot_page_directory:
    dd 0x00000083 ; identity mapped kernel page
    times (KERNEL_PAGE_NUMBER - 1) dd 0 ; non present pages before kernel space.
    dd 0x00000083 ; virtually mapped kernel page
    times (1024 - KERNEL_PAGE_NUMBER - 1) dd 0 ; non present pages after kernel


SECTION .multiboot.text
	global _start
	_start:
	; load page directory
    mov ecx, (boot_page_directory - KERNEL_VIRTUAL_BASE)
    mov cr3, ecx
 
	; enable PSE (4mb pages)
    mov ecx, cr4
    or ecx, 0x00000010
    mov cr4, ecx
 
	; enable paging
    mov ecx, cr0
    or ecx, 0x80000000
    mov cr0, ecx
 
	; jump to virtual address of kernel
    lea ecx, [virtual_start]
    jmp ecx 


SECTION .text
	global virtual_start:function (virtual_start.end - virtual_start)
	virtual_start:
		; unmap the identity mapped page
		mov dword [boot_page_directory], 0
		invlpg [0] ; flush TLD
	
		mov esp, stack_top ; setup stack
	
		; Reset EFLAGS. 
		push 0
		popf
		
		; push mbi* and magic.
		push eax
		add ebx, KERNEL_VIRTUAL_BASE
		push ebx
		
		; call kernel proper
		extern kernel_main
		call kernel_main
		
		; hang after return from kernel
		cli
		.hang:	hlt
			jmp .hang
		.end:
		
		
SECTION .bss ALIGN=0x20 NOBITS
	stack_bottom:
	resb 0x4000 ; 16kb
	stack_top:
