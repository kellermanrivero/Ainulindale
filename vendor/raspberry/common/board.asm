.global rpi_get_mmio_base_address

rpi_get_mmio_base_address:
    mrs x0, midr_el1    // read system register,
                        // manufacturer is encoded in bits 31:24
                        // model is encoded in bits 15:4
    asr x0, x0, 4  // shift x0 register to extract model
    ands x0, x0, 0xFFF // bit mask to extract model
    b.eq _error
    cmp x0, 0xB76       // compares to Rpi 1 (Model: 0xB76)
    b.eq _rpi1_board_code
    cmp x0, 0xC07       // compares to Rpi 2 (Model: 0xC07)
    b.eq _rpi2_board_code
    cmp x0, 0xD03       // compares to Rpi 3 (Model: 0xD03)
    b.eq _rpi3_board_code
    cmp x0, 0xD08       // compares to Rpi 4 (Model: 0xD08)
    b.eq _rpi4_board_code
_error:
    movz x0, 0xBEEF
    movk x0, 0xDEAD, lsl 16 // error code
    ret

_rpi1_board_code:
    mov x0, 0x20000000
    ret

_rpi2_board_code:
    mov x0, 0x3F000000
    ret

_rpi3_board_code:
    mov x0, 0x3F000000
    ret

_rpi4_board_code:
    mov x0, 0xFE000000
    ret




