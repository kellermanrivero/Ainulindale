.global rpi_uart_init
.global rpi_uart_send

.macro wait
    mov x13, 250
1:  nop
    subs x13, x13, 1
    b.ne 1b
.endm

// Inits the UART device
// More info:
// - BCM2835 ARM Peripherals
//   2) Auxiliaries: UART1 & SPI1, SPI2 (Page 8)
rpi_uart_init:
    adrp x8, rpi_mmio_base_address      // Load MMIO base address
    cmp x8, 0                           // It's 0?
    b.eq _gpio_init                     // Init GPIO
    b _uart_init
_gpio_init:
    bl rpi_gpio_init                    // Init GPIO
    cmp x0, -1                          // Check for error
    b.eq _error                         // Go to error
_uart_init:
    ldr x8, [x8]                        // Load MMIO base address

    movz x10, 0x5000
    movk x10, 0x21, LSL 16              // Load UART offset (0x215000)
    and x10, x8, x10                    // X10 => UART/AUX register base

    // Set AUX_ENABLES (0x04) |= 1
    ldr w11, [x10, 0x04]
    orr w11, w11, 0x1                   // Enables Mini UART module
    str w11, [x10, 0x04]

    // Set AUX_MU_IER_REG (0x44) = 0
    str wzr, [x10, 0x44]                // Enables receive interrupts

    // Set AUX_MU_IIR_REG (0x48) = 0xC6 (Disable interrupts)
    ldr w11, [x10, 0x48]
    mov w11, 0xC6
    str w11, [x10, 0x48]

    // Set AUX_MU_LCR_REG (0x4C) = 3 (8 bit)
    ldr w11, [x10, 0x4C]
    mov w11, 3
    str w11, [x10, 0x4C]

    // Set AUX_MU_MCR_REG (0x50) = 0
    str wzr, [x10, 0x50]

    // Set AUX_MU_CNTL_REG (0x60) = 0
    str wzr, [x10, 0x60]

    // Set AUX_MU_BAUD_REG (0x68) = 270 (115200 baud rate)
    ldr w11, [x10, 0x68]
    mov w11, 270
    str w11, [x10, 0x68]

    // Load GPIO offset
    mov x12, xzr
    movk x12, 0x20, LSL 16
    and x12, x8, x12

    // Configure GPIO pins)
    // Set GPFSEL1
    ldr w11, [x12, 0x04]
    bic w11, w11, 0x3F000           // Clear bits 12-14 (PIN 14) & 15-17 (PIN 15)
    orr w11, w11, 0x2000            // Set bits 12-14 & 15-17 to 2 (010), ALT5
    orr w11, w11, 0x10000           //
    str w11, [x12, 0x04]

    // Set GPPUD
    str wzr, [x12, 0x94]
    wait

    // Set GPPUDCLK0
    mov w11, wzr
    movk w11, 0xC, LSL 16
    str w11, [x12, 0x98]
    wait

    str wzr, [x12, 0x98]           // Flush GPIO setup

    // Set AUX_MU_CNTL_REG (0x60) = 3
    mov w11, 3
    str w11, [x10, 0x60]           // Enable Tx & Rx
    b _success

_success:
    mov x0, 0
    b _end
_error:
    mov x0, -1
    b _end
_end:
    ret

rpi_uart_send:
    adrp x8, rpi_mmio_base_address      // Load MMIO base address
    ret


