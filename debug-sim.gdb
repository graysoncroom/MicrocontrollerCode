# GDB command file
# use: gdb -q -x debug.gdb ELF-file

echo gdb: bin/p2.elf (v0.0.2)\n

set mem inaccessible-by-default off
set confirm off
set target-async on

## connect to qemu default port

target remote | exec qemu-system-gnuarmeclipse -gdb stdio -M STM32F4-Discovery -monitor null -serial null -semihosting -S -kernel bin/p2.elf
file bin/p2.elf
set listsize 50
load

tbreak Reset_Handler
commands
echo Simulation mode (qemu-m3): Type continue\n
end

tbreak main
commands
tbreak all_done
layout src
layout reg
end

continue
