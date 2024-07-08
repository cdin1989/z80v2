#ifndef DIGIT_IO_H
#define DIGIT_IO_H

#include <stdint.h>

struct digit_io_device {
    void (*write)(uint8_t value);
};

void digit_io_init(struct digit_io_device* dev);

#endif // DIGIT_IO_H