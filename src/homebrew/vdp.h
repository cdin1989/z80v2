/***********************************************************************
 * TMS9118 MEMORY MAP                                                  *
 *                          TEXT                                       *
 * PATTERN TABLE     : 0x0000 - 0x07FF                          2KB    *
 * NAME TABLE        : 0x0800 - 0x0BBF                          960    *
 * UNUSED            : 0x0BC0 - 0x3FFF                                 *
 ***********************************************************************                                                                     *
 *                         GRAPHIC I                                   *
 * SPRITE PATTERNS   : 0x0000 - 0x07FF                          2KB    *
 * PATTERN TABLE     : 0x0800 - 0x0FFF                          2KB    *
 * SPRITE ATTRIBUTE  : 0x1000 - 0x107F                          128    *
 * UNUSED            : 0x1080 - 0x13FF                                 *
 * NAME TABLE        : 0x1400 - 0x17FF                          1KB    *
 * UNUSED            : 0x1800 - 0x1FFF                                 *
 * COLOR TABLE       : 0x2000 - 0x201F                          32     *
 * UNUSED            : 0x2020 - 0x3FFF                                 *
 ***********************************************************************
 *                         GRAPHIC II                                  *
 * PATTERN TABLE     : 0x0000 - 0x17FF                          6KB    *
 * SPRITE PATTERN    : 0x1800 - 0x1FFF                          2KB    *
 * COLOR TABLE       : 0x2000 - 0x37FF                          6KB    *
 * NAME TABLE        : 0x3800 - 0x3AFF                          768    *
 * SPRITE ATTRIBUTES : 0x3B00 - 0x3BFF                          256    *
 * UNUSED            : 0x3C00 - 0x3FFF                                 *
 * *********************************************************************
 *                        MULTICOLOR                                   *
 * SPRITE PATTERN    : 0x0000 - 0x07FF                          2KB    *
 * PATTERN TABLE     : 0x0800 - 0x0DFF                          1536   *
 * UNUSED            : 0x0E00 - 0x0FFF                                 *
 * SPRITE ATTRIBUTES : 0x1000 - 0x107F                          128    *
 * UNUSED            : 0x1080 - 0x13FF                                 *
 * NAME TABLE        : 0x1400 - 0x16FF                          768    *
 * UNUSED            : 0x1700 - 0x3FFF                                 *
 * *********************************************************************
 */
#ifndef VDP_H
#define VDP_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

// vdp status bits
enum vdp_status_bits {
    VDP_INT = 0x80,
    VDP_5S = 0x40,
    VDP_C = 0x20,
    VDP_FS4 = 0x10,
    VDP_FS3 = 0x08,
    VDP_FS2 = 0x04,
    VDP_FS1 = 0x02,
    VDP_FS0 = 0x01
};

// vdp display mode
enum vdp_mode {
    VDP_TEXT_MODE,
    VDP_GRAPHIC_MODE_1,
    VDP_GRAPHIC_MODE_2,
    VDP_MULTICOLOR_MODE
};

// sprite size
enum vdp_sprite_size {
    VDP_SIZE_8_8,
    VDP_SIZE_16_16
};

// sprite magnification
enum vdp_sprite_mag {
    VDP_MAG_OFF,
    VDP_MAG_ON
};

// color
enum vdp_color {
    VDP_CLR_TRANSPARENT = 0x00,
    VDP_CLR_BLACK = 0x01,
    VDP_CLR_MEDIUM_GREEN = 0x02,
    VDP_CLR_LIGHT_GREEN = 0x03,
    VDP_CLR_DARK_BLUE = 0x04,
    VDP_CLR_LIGHT_BLUE = 0x05,
    VDP_CLR_DARK_RED = 0x06,
    VDP_CLR_CYAN = 0x07,
    VDP_CLR_MEDIUM_RED = 0x08,
    VDP_CLR_LIGHT_RED = 0x09,
    VDP_CLR_DARK_YELLOW = 0x0A,
    VDP_CLR_LIGHT_YELLOW = 0x0B,
    VDP_CLR_DARK_GREEN = 0x0C,
    VDP_CLR_MAGENTA = 0x0D,
    VDP_CLR_GRAY = 0x0E,
    VDP_CLR_WHITE = 0x0F
};

// vdp init data
struct vdp_context {
    enum vdp_mode mode;
    enum vdp_sprite_size size;
    enum vdp_sprite_mag mag;
    enum vdp_color text_color;
    enum vdp_color back_color;
    void (*interrupt_handler)(void);
};

struct vdp_device {
    uint8_t (*status)(void);
    void (*vram_address)(uint16_t addr);
    void (*vram_write)(void* data, uint16_t len);
    void (*interrupt_enable)(bool enable);
    void (*fill_name_table)(void *data, uint16_t len);
    void (*fill_color_table)(void *data, uint16_t len);
    void (*fill_pattern_table)(void *data, uint16_t len);
    void (*fill_sprite_attribute_table)(void *data, uint16_t len);
    void (*fill_sprite_pattern_table)(void *data, uint16_t len);
};

void vdp_init(struct vdp_device *dev, struct vdp_context *ctx);

#endif // VDP_H