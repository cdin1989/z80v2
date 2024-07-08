#include <z80.h>
#include "vdp.h"

// port address
enum vdp_port {
    VDP_VREG = 0xBF,
    VDP_VRAM = 0xBE,
    VDP_R0   = 0x80,
    VDP_R1   = 0x81,
    VDP_R2   = 0x82,
    VDP_R3   = 0x83,
    VDP_R4   = 0x84,
    VDP_R5   = 0x85,
    VDP_R6   = 0x86,
    VDP_R7   = 0x87
};

// registers
struct vdp_registers {
    uint8_t r0;
    uint8_t r1;
    uint8_t r2;
    uint8_t r3;
    uint8_t r4;
    uint8_t r5;
    uint8_t r6;
    uint8_t r7;
} _regs;

// interrupt handler
static void (*_vdp_interrupt_handler)(void) = 0;

// rst38 interrupt service routine
void z80_rst_38h(void) __critical __interrupt(0)
{
    if (_vdp_interrupt_handler != NULL) {
        _vdp_interrupt_handler();
    }
}

static uint8_t vdp_status(void)
{
    return z80_inp(VDP_VREG);
}

static void vdp_vram_address(uint16_t addr)
{
    z80_outp(VDP_VREG, addr & 0xFF);
    z80_outp(VDP_VREG, ((addr >> 8) & 0xFF) | 0x40);
}

static void vdp_vram_write(void* data, uint16_t len)
{
    for (uint16_t i = 0; i < len; i++) {
        z80_outp(VDP_VRAM, ((uint8_t*)data)[i]);
    }
}

static void vdp_interrupt_enable(bool enable)
{
    _regs.r1 = enable ? (_regs.r1 | 0x20) : (_regs.r1 & ~0x20);
    z80_outp(VDP_VREG, _regs.r1);
    z80_outp(VDP_VREG, VDP_R1);
}

static void vdp_fill_name_table(void *data, uint16_t len)
{
    // R2 * 400(16) = START ADDRESS
    vdp_vram_address(_regs.r2 * 0x400);
    vdp_vram_write(data, len);
}

static void vdp_fill_color_table(void *data, uint16_t len)
{
    // (R3) * 40(16) STARTING ADDRESS
    vdp_vram_address((_regs.r0 & 0x02) != 0 ? 0x2000 : _regs.r3 * 0x40);
    vdp_vram_write(data, len);
}

static void vdp_fill_pattern_table(void *data, uint16_t len)
{
    // (R4) * 800(16) STARTING ADDRESS
    vdp_vram_address((_regs.r0 & 0x02) != 0 ? 0x0000 : _regs.r4 * 0x800);
    vdp_vram_write(data, len);
}

static void vdp_fill_sprite_attribute_table(void *data, uint16_t len)
{
    // (R5) * 80(16) STARTING ADDRESS
    vdp_vram_address(_regs.r5 * 0x80);
    vdp_vram_write(data, len);
}

static void vdp_fill_sprite_pattern_table(void *data, uint16_t len)
{
    // (R6) * 800(16) STARTING ADDRESS
    vdp_vram_address(_regs.r6 * 0x800);
    vdp_vram_write(data, len);
}

void vdp_init(struct vdp_device *dev, struct vdp_context *ctx)
{
    if (ctx == NULL)
        return;

    dev->status = vdp_status;
    dev->vram_address = vdp_vram_address;
    dev->vram_write = vdp_vram_write;
    dev->interrupt_enable = vdp_interrupt_enable;
    dev->fill_name_table = vdp_fill_name_table;
    dev->fill_color_table = vdp_fill_color_table;
    dev->fill_pattern_table = vdp_fill_pattern_table;
    dev->fill_sprite_attribute_table = vdp_fill_sprite_attribute_table;
    dev->fill_sprite_pattern_table = vdp_fill_sprite_pattern_table;

    // set interrupt handler
    _vdp_interrupt_handler = ctx->interrupt_handler;

    // set 8 registers
    _regs.r0 = 0x00;
    _regs.r1 = 0xC0;
    _regs.r2 = 0x00;
    _regs.r3 = 0x00;
    _regs.r4 = 0x00;
    _regs.r5 = 0x00;
    _regs.r6 = 0x00;
    _regs.r7 = ((ctx->text_color << 4) & 0xF0) | (ctx->back_color & 0x0F);

    // M1 M2 M3
    switch (ctx->mode) {
    case VDP_TEXT_MODE:
        _regs.r1 |= 0x10; // M1 = 1
        _regs.r2 = 0x02;  // Name Table: 2*400(16) = 0x800
        _regs.r3 = 0x00;  // Unused
        _regs.r4 = 0x00;  // Pattern Table: 3*800(16) = 0xC00
        _regs.r5 = 0x20;  // Unused
        _regs.r6 = 0x00;  // Unused
        break;
    case VDP_GRAPHIC_MODE_1:
        _regs.r2 = 0x05;  // Name Table: 5*400(16) = 0x1400
        _regs.r3 = 0x80;  // Color Table: 80*40(16) = 0x2000
        _regs.r4 = 0x01;  // Pattern Table: 1*800(16) = 0x0800
        _regs.r5 = 0x20;  // Sprite Attribute Table: 20*80(16) = 0x1000
        _regs.r6 = 0x00;  // Sprite Pattern Table: 0*800(16) = 0x0000
        _regs.r7 = 0x01;  // Backdrop Color = Black
        break;
    case VDP_GRAPHIC_MODE_2:
        _regs.r0 |= 0x02;
        _regs.r2 = 0x0E;  // Name Table: 0E*400(16) = 0x3800
        _regs.r3 = 0xFF;  // Color Table: 0x2000
        _regs.r4 = 0x03;  // Pattern Table: 0x0000
        _regs.r5 = 0x76;  // Sprite Attribute Table: 76*80(16) = 0x3B00
        _regs.r6 = 0x03;  // Sprite Pattern Table: 3*800(16) = 0x1800
        _regs.r7 = 0x0F;  // Backdrop Color = White
        break;
    case VDP_MULTICOLOR_MODE:
        _regs.r1 |= 0x08;
        _regs.r2 = 0x05;  // Name Table: 5*400(16) = 0x1400
        _regs.r3 = 0x00;  // Unused
        _regs.r4 = 0x01;  // Pattern Table: 1*800(16) = 0x0800
        _regs.r5 = 0x20;  // Sprite Attribute Table: 20*80(16) = 0x1000
        _regs.r6 = 0x00;  // Sprite Pattern Table: 0*800(16) = 0x0000
        _regs.r7 = 0x04;  // Backdrop Color = Dark Blue
        break;
    default:
        break;
    }

    // SIZE
    switch (ctx->size)
    {
    case VDP_SIZE_8_8:
        break;
    case VDP_SIZE_16_16:
        _regs.r1 |= 0x02;
        break;
    }

    // MAG
    switch (ctx->mag)
    {
    case VDP_MAG_OFF:
        break;
    case VDP_MAG_ON:
        _regs.r1 |= 0x01;
        break;
    }

    // set registers
    z80_outp(VDP_VREG, _regs.r0);
    z80_outp(VDP_VREG, VDP_R0);

    z80_outp(VDP_VREG, _regs.r1);
    z80_outp(VDP_VREG, VDP_R1);

    z80_outp(VDP_VREG, _regs.r2);
    z80_outp(VDP_VREG, VDP_R2);

    z80_outp(VDP_VREG, _regs.r3);
    z80_outp(VDP_VREG, VDP_R3);

    z80_outp(VDP_VREG, _regs.r4);
    z80_outp(VDP_VREG, VDP_R4);

    z80_outp(VDP_VREG, _regs.r5);
    z80_outp(VDP_VREG, VDP_R5);

    z80_outp(VDP_VREG, _regs.r6);
    z80_outp(VDP_VREG, VDP_R6);

    z80_outp(VDP_VREG, _regs.r7);
    z80_outp(VDP_VREG, VDP_R7);
}