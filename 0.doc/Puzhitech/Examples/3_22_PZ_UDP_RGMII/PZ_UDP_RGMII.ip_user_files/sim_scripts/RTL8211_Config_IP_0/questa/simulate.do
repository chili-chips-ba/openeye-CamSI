onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib RTL8211_Config_IP_0_opt

do {wave.do}

view wave
view structure
view signals

do {RTL8211_Config_IP_0.udo}

run -all

quit -force
