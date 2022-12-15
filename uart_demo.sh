qemu-system-aarch64 -d unimp \
    -M raspi3b \
    -kernel build/Uart.elf \
    -m 1G -smp 4 \
    -serial null -serial stdio
