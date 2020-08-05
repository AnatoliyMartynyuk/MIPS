onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_single_cycle_datapath/instr
add wave -noupdate /tb_single_cycle_datapath/mem_data
add wave -noupdate /tb_single_cycle_datapath/alu_out
add wave -noupdate /tb_single_cycle_datapath/data_wr
add wave -noupdate /tb_single_cycle_datapath/u_single_cycle_datapath/u_register_file/memory
add wave -noupdate /tb_single_cycle_datapath/clk
add wave -noupdate /tb_single_cycle_datapath/reset
add wave -noupdate -radix binary /tb_single_cycle_datapath/alu_ctrl
add wave -noupdate /tb_single_cycle_datapath/pc_src
add wave -noupdate /tb_single_cycle_datapath/mem_to_reg
add wave -noupdate /tb_single_cycle_datapath/alu_src
add wave -noupdate /tb_single_cycle_datapath/reg_dst
add wave -noupdate /tb_single_cycle_datapath/reg_wr
add wave -noupdate /tb_single_cycle_datapath/jump
add wave -noupdate /tb_single_cycle_datapath/pc
add wave -noupdate /tb_single_cycle_datapath/zero
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {138161 ps} 0}
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
WaveRestoreZoom {115200 ps} {179200 ps}
