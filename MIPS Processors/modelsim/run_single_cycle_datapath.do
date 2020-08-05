# Create work library
vlib work

# Source and Testbench files
vcom -work work "../srcs/single_cycle_datapath.vhd"
vcom -work work "../srcs/register_file.vhd"
vcom -work work "../srcs/ALU.vhd"

vcom -work work "../sims/tb_single_cycle_datapath.vhd"

# Call simulator
vsim -voptargs="+acc" -t 1ps -lib work tb_single_cycle_datapath

# Source the wave file
do wave_single_cycle_datapath.do

# Set windows
view wave
view structure
view signals

# Run the simulation
run -all

# End