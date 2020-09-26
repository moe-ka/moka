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
