/*
 * Copyright (C) 2018 bzt (bztsrc@github)
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 */

#include "bridge.h"
#include "uart.h"

void main()
{
    // set up serial console
    uart_init();

    // say hello
    uart_puts("Hello World!!!\n");

#ifdef BOARD_DETECTION
    unsigned long mmio_base_address = rpi_get_mmio_base_address();
    if (mmio_base_address == 0x20000000) {
        uart_puts("MMIO Address: 0x20000000\n");
    } else if (mmio_base_address == 0x3F000000) {
        uart_puts("MMIO Address: 0x3F000000\n");
    } else if (mmio_base_address == 0xFE000000) {
        uart_puts("MMIO Address: 0xFE000000\n");
    } else if (mmio_base_address == 0xDEADBEEF) {
        uart_puts("MMIO Address: 0x3F000000\n");
    }
#endif

    // echo everything back
    while(1) {
        uart_send(uart_getc());
    }
}