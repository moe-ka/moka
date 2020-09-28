#pragma once
#include <multiboot.h>
#include <stddef.h>
#include <stdint.h>

#define KERNEL_VIRTUAL_BASE 0xC0000000

void kernel_main(uint32_t);
