onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_4096x32_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_4096x32.udo}

run -all

quit -force
