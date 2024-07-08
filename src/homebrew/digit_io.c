#include <z80.h>
#include "digit_io.h"

// port address
enum digit_io_port {
    DIGIT_REG = 0xFF
};

static void digit_io_write(uint8_t value)
{
    z80_outp(DIGIT_REG, value);
}

void digit_io_init(struct digit_io_device* dev)
{
    dev->write = digit_io_write;
}