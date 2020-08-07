# Create work library
vlib work

# Source and Testbench files
vcom -work work "../srcs/multi_cycle_control.vhd"
vcom -work work "../sims/tb_multi_cycle_control.vhd"

# Call simulator
vsim -voptargs="+acc" -t 1ps -lib work tb_multi_cycle_control

# Source the wave file
do wave_multi_cycle_control.do

# Set windows
view wave
view structure
view signals

# Run the simulation
run -all

# End