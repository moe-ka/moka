#include <kernel.h>
#include <stdio.h>

/* vga variables */
static volatile vga_glyph_t *video = NULL;
static volatile size_t xpos = 0;
static volatile size_t ypos = 0;

void init_vga(uint32_t vga_addr)
{
    // initialize video buffer to correct addr
    video = (vga_glyph_t *)vga_addr;

    // clear screen
    for (size_t idx = 0; idx < VGA_WIDTH * VGA_HEIGHT; idx++)
        (video + idx)->value = 0;

    printk("Framebuffer setup complete.\n");
}

size_t strlen(const char *s)
{
    const char *p = s;
    while (*s)
        ++s;
    return s - p;
}

void putchar(unsigned char c)
{
    switch (c)
    {
    case '\n':
        goto newline;
    case '\r':
        goto carriage_return;
    default:
        *(video + (xpos + ypos * VGA_WIDTH)) =
            (vga_glyph_t){.entry.character = c,
                          .entry.background = VGA_COLOR_BLACK,
                          .entry.foreground = VGA_COLOR_WHITE};
    }

    xpos++;
    if (xpos >= VGA_WIDTH)
    {
    newline:
        ypos++;
        if (ypos >= VGA_HEIGHT)
            ypos = 0;

    carriage_return:
        xpos = 0;
        return;
    }
}

void printk(const char *str)
{
    while (*str)
        putchar(*(str++));
}
