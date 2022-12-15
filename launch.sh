qemu-system-aarch64 \
    -M raspi3b \
    -cpu cortex-a72 \
    -dtb hw/bcm2710-rpi-3-b-plus.dtb \
    -kernel build/Ainulindale.elf \
    -m 1G -smp 4 \
    -serial null -serial stdio