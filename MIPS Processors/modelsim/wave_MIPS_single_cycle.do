onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips_single_cycle/mem_data
add wave -noupdate /tb_mips_single_cycle/alu_out
add wave -noupdate /tb_mips_single_cycle/data_wr
add wave -noupdate /tb_mips_single_cycle/mem_write
add wave -noupdate /tb_mips_single_cycle/u_MIPS_single_cycle/u_single_cycle_datapath/u_register_file/memory
add wave -noupdate /tb_mips_single_cycle/instr
add wave -noupdate /tb_mips_single_cycle/pc
add wave -noupdate /tb_mips_single_cycle/clk
add wave -noupdate /tb_mips_single_cycle/reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22267 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 100
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {6400 ps} {70400 ps}
