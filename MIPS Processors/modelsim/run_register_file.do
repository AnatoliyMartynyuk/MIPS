# Create work library
vlib work

# Source and Testbench files
vcom -work work "../srcs/register_file.vhd"
vcom -work work "../sims/tb_register_file.vhd"

# Call simulator
vsim -voptargs="+acc" -t 1ps -lib work tb_register_file

# Source the wave file
do wave_register_file.do

# Set windows
view wave
view structure
view signals

# Run the simulation
run -all

# End