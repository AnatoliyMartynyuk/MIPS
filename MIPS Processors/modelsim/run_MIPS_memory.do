# Create work library
vlib work

# Source and Testbench files
vcom -work work "../srcs/MIPS_memory.vhd"
vcom -work work "../sims/tb_MIPS_memory.vhd"

# Call simulator
vsim -voptargs="+acc" -t 1ps -lib work tb_MIPS_memory

# Source the wave file
do wave_MIPS_memory.do

# Set windows
view wave
view structure
view signals

# Run the simulation
run -all

# End