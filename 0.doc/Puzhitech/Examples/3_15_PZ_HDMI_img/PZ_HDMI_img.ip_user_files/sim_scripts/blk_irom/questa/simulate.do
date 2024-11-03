onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib blk_irom_opt

do {wave.do}

view wave
view structure
view signals

do {blk_irom.udo}

run -all

quit -force
