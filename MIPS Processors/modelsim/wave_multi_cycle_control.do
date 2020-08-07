onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_multi_cycle_control/u_multi_cycle_control/ps
add wave -noupdate /tb_multi_cycle_control/u_multi_cycle_control/ns
add wave -noupdate -radix binary /tb_multi_cycle_control/alu_ctrl
add wave -noupdate -radix binary /tb_multi_cycle_control/opcode
add wave -noupdate -radix binary /tb_multi_cycle_control/funct
add wave -noupdate /tb_multi_cycle_control/branch
add wave -noupdate /tb_multi_cycle_control/pc_wr
add wave -noupdate /tb_multi_cycle_control/i_or_d
add wave -noupdate /tb_multi_cycle_control/instr_wr
add wave -noupdate /tb_multi_cycle_control/reg_wr
add wave -noupdate /tb_multi_cycle_control/mem_to_reg
add wave -noupdate /tb_multi_cycle_control/reg_dst
add wave -noupdate /tb_multi_cycle_control/mem_write
add wave -noupdate /tb_multi_cycle_control/src_a_ctrl
add wave -noupdate /tb_multi_cycle_control/pc_src
add wave -noupdate /tb_multi_cycle_control/src_b_ctrl
add wave -noupdate /tb_multi_cycle_control/reset
add wave -noupdate /tb_multi_cycle_control/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28943 ps} 0}
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
WaveRestoreZoom {0 ps} {128 ns}
