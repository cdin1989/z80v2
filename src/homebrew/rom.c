#include <stdlib.h>
#include <string.h>
#include <z80.h>
#include "vdp.h"

uint8_t pattern_table[6144];
uint8_t color_table[6144];
uint8_t name_table[768];
uint8_t sprite_pattern_table[2048];
uint8_t sprite_attribute_table[256];

uint8_t color_pattern[8] = { 
    0x1B, 0x7B, 0xCB, 0xEB,
    0x8B, 0x5B, 0x6B, 0xDB };

struct vdp_device vdp;

void on_vblank_handler() {
}

int main()
{
    for (uint16_t i = 0; i < 6144; i++)
        pattern_table[i] = 0xFF;

    for (uint16_t i = 0; i < 768; i++) {
        uint8_t color = color_pattern[rand() % 8];
        for (uint16_t j = 0; j < 8; j++) {
            color_table[i * 8 + j] = color;
        }
    }

    for (uint16_t i = 0; i < 768; i++)
        name_table[i] = i % 256;

    for (uint16_t i = 0; i < 2048; i++)
        sprite_pattern_table[i] = 0x00;

    for (uint16_t i = 0; i < 256; i++)
        sprite_attribute_table[i] = 0x00;

    // init vdp
    struct vdp_context ctx;
    ctx.mode = VDP_GRAPHIC_MODE_2;
    ctx.size = VDP_SIZE_16_16;
    ctx.mag = VDP_MAG_OFF;
    ctx.interrupt_handler = on_vblank_handler;
    vdp_init(&vdp, &ctx);
    //vdp.interrupt_enable(true);

    vdp.fill_pattern_table(pattern_table, sizeof(pattern_table));
    vdp.fill_color_table(color_table, sizeof(color_table));
    vdp.fill_name_table(name_table, sizeof(name_table));
    vdp.fill_sprite_attribute_table(sprite_attribute_table, sizeof(sprite_attribute_table));
    vdp.fill_sprite_pattern_table(sprite_pattern_table, sizeof(sprite_pattern_table));

    for (;;);
    return 0;
}