abs_srctree := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

CC := i686-elf-gcc
CFLAGS := -ffreestanding -O2 -I$(abs_srctree)/include -g -Wall -Wextra 
LFLAGS := -ffreestanding -O2 -nostdlib

MKDIR   := mkdir -p
RMDIR   := rm -rf
INCLUDE := ./include
SRCS    := $(wildcard ./*/*.c)
OBJS    := $(patsubst %.c,%.o,$(SRCS))
EXE     := moka.bin

.PHONY: all clean
all: $(EXE) clean

$(EXE): $(OBJS)
	nasm -felf32 ./kernel/boot.s -p ./kernel/multiboot.inc -o ./kernel/boot.o
	$(CC) -T linker.ld -o $@ $(LFLAGS) ./kernel/boot.o $^ -lgcc
	$(RMDIR) ./kernel/boot.o

$(OBJS) : %.o : %.c 
	$(CC) -c $< -o $@ $(CFLAGS)

$(OBJ):
	$(MKDIR) $@
	
iso: all
	$(MKDIR) isodir/boot/grub
	cp moka.bin isodir/boot/moka.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o moka.iso isodir
	$(RMDIR) isodir

clean:
	$(RMDIR) $(OBJS)