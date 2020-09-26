#include <kernel.h>
#include <stdio.h>

size_t strlen(const char *s)
{
    const char *p = s;
    while (*s)
        ++s;
    return s - p;
}

void putchar(unsigned char c)
{
    if (c == '\n' || c == '\r')
    {
    newline:
        xpos = 0;
        ypos++;
        if (ypos >= VGA_HEIGHT)
            ypos = 0;
        return;
    }

    *(video + (xpos + ypos * VGA_WIDTH)) = (vga_glyph_t){.entry.character = c,
                                                         .entry.background = VGA_COLOR_BLACK,
                                                         .entry.foreground = VGA_COLOR_WHITE};
                                                         
    xpos++;
    if (xpos >= VGA_WIDTH)
        goto newline;
}

void printk(const char *str)
{
    while(str < strlen(str) + str)
        putchar(*(str++));
}
