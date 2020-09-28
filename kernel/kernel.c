#include <kernel.h>
#include <stdio.h>

// extern definitions
static multiboot_info_t *mbi;

void kernel_main(uint32_t mbi_addr)
{
    mbi = (multiboot_info_t *)mbi_addr;

    // video buffer information not given
    if (!(mbi->flags & MULTIBOOT_INFO_FRAMEBUFFER_INFO))
        return;

    // initialize vga text buffer
    init_vga(mbi->framebuffer_addr + KERNEL_VIRTUAL_BASE);

    printk("1234\r5678\nabcd");
}
