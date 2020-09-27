#pragma once
#include <stddef.h>
#include <stdint.h>

/* Hardware text mode color constants. */
enum vga_color
{
    VGA_COLOR_BLACK = 0,
    VGA_COLOR_BLUE = 1,
    VGA_COLOR_GREEN = 2,
    VGA_COLOR_CYAN = 3,
    VGA_COLOR_RED = 4,
    VGA_COLOR_MAGENTA = 5,
    VGA_COLOR_BROWN = 6,
    VGA_COLOR_LIGHT_GREY = 7,
    VGA_COLOR_DARK_GREY = 8,
    VGA_COLOR_LIGHT_BLUE = 9,
    VGA_COLOR_LIGHT_GREEN = 10,
    VGA_COLOR_LIGHT_CYAN = 11,
    VGA_COLOR_LIGHT_RED = 12,
    VGA_COLOR_LIGHT_MAGENTA = 13,
    VGA_COLOR_LIGHT_BROWN = 14,
    VGA_COLOR_WHITE = 15,
};

union vga_glyph
{
    struct
    {
        uint8_t character;
        uint8_t foreground : 4;
        uint8_t background : 4;
    } entry;

    uint16_t value;
} __attribute__((packed));

typedef union vga_glyph vga_glyph_t;

// const expressions
#define VGA_WIDTH 80
#define VGA_HEIGHT 24

void init_vga(uint32_t);
size_t strlen(const char *);
void putchar(unsigned char);
void printk(const char *);
