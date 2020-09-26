#include <kernel.h>
#include <multiboot.h>
#include <stdio.h>

void init_vga(void)
{
    video = (vga_glyph_t *)VGA_START;
    for (size_t idx = 0; idx < VGA_WIDTH * VGA_HEIGHT; idx++)
        (video + idx)->value = 0;
    xpos = 0;
    ypos = 0;
}

void kernel_main(unsigned long addr)
{
    multiboot_info_t *mbi = (multiboot_info_t *)addr;
    init_vga();

    printk("1234\r5678\nabcd");
}
