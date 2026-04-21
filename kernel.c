#include <stdint.h>

#define VGA_MEMORY (uint16_t*)0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

static uint16_t* const vga = VGA_MEMORY;

static uint8_t make_color(uint8_t fg, uint8_t bg) {
    return fg | (bg << 4);
}

static uint16_t make_vga_entry(char c, uint8_t color) {
    return (uint16_t)c | ((uint16_t)color << 8);
}

void clear_screen(uint8_t color) {
    uint16_t entry = make_vga_entry(' ', color);
    for (int y = 0; y < VGA_HEIGHT; y++) {
        for (int x = 0; x < VGA_WIDTH; x++) {
            vga[y * VGA_WIDTH + x] = entry;
        }
    }
}

void print_string(const char* str, int row, int col, uint8_t color) {
    int pos = row * VGA_WIDTH + col;
    while (*str) {
        vga[pos++] = make_vga_entry(*str++, color);
    }
}

void kernel_main(void) {
    uint8_t blue_bg = 1;
    uint8_t white_fg = 15;
    uint8_t color = make_color(white_fg, blue_bg);

    clear_screen(color);

    print_string("Welcome", 10, 35, color);
    print_string("Dobro pozhalovat'", 12, 30, color);

    for (volatile uint64_t i = 0; i < (uint64_t)1e9; i++);

    uint8_t green_bg = 2;
    uint8_t desktop_color = make_color(white_fg, green_bg);
    clear_screen(desktop_color);

    print_string("Desktop mock", 0, 0, desktop_color);

    while (1) {
        __asm__ __volatile__("hlt");
    }
}
