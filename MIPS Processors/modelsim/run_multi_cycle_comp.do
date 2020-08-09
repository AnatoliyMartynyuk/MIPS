# Create work library
vlib work

# Source and Testbench files
vcom -work work "../srcs/multi_cycle_comp.vhd"
vcom -work work "../srcs/MIPS_multi_cycle.vhd"
vcom -work work "../srcs/multi_cycle_datapath.vhd"
vcom -work work "../srcs/register_file.vhd"
vcom -work work "../srcs/ALU.vhd"
vcom -work work "../srcs/multi_cycle_control.vhd"

vcom -work work "../sims/tb_multi_cycle_comp.vhd"

vcom -work work "../srcs/MIPS_memory.vhd"

# Call simulator
vsim -voptargs="+acc" -t 1ps -lib work tb_multi_cycle_comp

# Source the wave file
do wave_multi_cycle_comp.do

# Set windows
view wave
view structure
view signals

# Run the simulation
run -all

# End