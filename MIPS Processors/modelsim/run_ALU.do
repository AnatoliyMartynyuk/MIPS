# Create work library
vlib work

# Source and Testbench files
vcom -work work "../srcs/ALU.vhd"
vcom -work work "../sims/tb_ALU.vhd"

# Call simulator
vsim -voptargs="+acc" -t 1ps -lib work tb_ALU

# Source the wave file
do wave_ALU.do

# Set windows
view wave
view structure
view signals

# Run the simulation
run -all

# End