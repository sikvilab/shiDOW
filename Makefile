all: os.bin

boot.o: boot.asm
<TAB>nasm -f bin boot.asm -o boot.o

kernel.o: kernel.c
<TAB>i686-elf-gcc -ffreestanding -m32 -c kernel.c -o kernel.o

kernel.elf: boot.o kernel.o linker.ld
<TAB>i686-elf-ld -m elf_i386 -T linker.ld -o kernel.elf boot.o kernel.o

os.bin: kernel.elf
<TAB>objcopy -O binary kernel.elf os.bin

clean:
<TAB>rm -f *.o *.elf *.bin
