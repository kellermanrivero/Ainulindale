cmake_minimum_required(VERSION 3.23)

project(Ainulindale ASM C)

set(TARGET_TRIPLE aarch64-elf)
set(CMAKE_ASM_COMPILER_TARGET ${TARGET_TRIPLE})
set(CMAKE_C_COMPILER_TARGET ${TARGET_TRIPLE})
set(CMAKE_CXX_COMPILER_TARGET ${TARGET_TRIPLE})

# Board detection
add_compile_definitions(BOARD_DETECTION)

# Targets
add_executable(Ainulindale.elf start.asm)
add_executable(Uart.elf
        vendor/raspberry/common/board.asm
        vendor/raspberry/rpi3/gpio/gpio.asm
        vendor/raspberry/rpi3/uart/uart.asm
        demo/uart/start.asm
        demo/uart/bridge.h
        demo/uart/uart.c
        demo/uart/uart.h
        demo/uart/main.c
        demo/uart/gpio.h)

# Linker scripts
set(DEFAULT_LD_SCRIPT_PATH ${CMAKE_SOURCE_DIR}/linker_script.ld)
set(UART_LD_SCRIPT_PATH ${CMAKE_SOURCE_DIR}/demo/uart/link.ld)

# Link flags
set_target_properties(Ainulindale.elf PROPERTIES LINK_FLAGS "-nostdlib -nodefaultlibs -T ${DEFAULT_LD_SCRIPT_PATH}")
set_target_properties(Uart.elf PROPERTIES LINK_FLAGS "-nostdlib -nodefaultlibs -T ${UART_LD_SCRIPT_PATH}")