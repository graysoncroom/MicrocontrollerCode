# GDB command file
# use: gdb -q -x debug.gdb ELF-file

set mem inaccessible-by-default off
set confirm off
set target-async on

set listsize 100

target remote localhost:3333
monitor reset halt
load

tbreak Reset_Handler
commands
echo Hardware mode (F4): Type continue\n
end

tbreak main
commands
tbreak all_done
layout src
layout reg
end

continue
