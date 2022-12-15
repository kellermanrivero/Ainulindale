.global rpi_mmio_base_address
.global rpi_gpio_init

rpi_gpio_init:
    adrp x8, rpi_mmio_base_address          // Load from memory mmio_base_address
    bl rpi_get_mmio_base_address        // Get MMIO base address
    mov x9, x0                          // Copy to X9 the base address
    movz x10, 0xBEEF
    movk x10, 0xDEAD, lsl 16            // Unknown board?
    cmp x9, x10                         // is unknown?
    b.eq _error
    mov x0, 0
    ret

_error:
    mov x0, -1
    ret

rpi_mmio_base_address: .word 0