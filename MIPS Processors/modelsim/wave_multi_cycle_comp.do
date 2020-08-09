onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/ps
add wave -noupdate /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_datapath/pc
add wave -noupdate /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_datapath/pc_n
add wave -noupdate /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/instr
add wave -noupdate -group memory /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_memory/memory
add wave -noupdate -group memory -label reg_file /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_datapath/u_register_file/memory
add wave -noupdate -group interface /tb_multi_cycle_comp/u_multi_cycle_comp/mem_word
add wave -noupdate -group interface /tb_multi_cycle_comp/u_multi_cycle_comp/mem_addr
add wave -noupdate -group interface /tb_multi_cycle_comp/u_multi_cycle_comp/data_wr
add wave -noupdate -group control /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/branch
add wave -noupdate -group control /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/pc_wr
add wave -noupdate -group control /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/i_or_d
add wave -noupdate -group control /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/instr_wr
add wave -noupdate -group control /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/reg_wr
add wave -noupdate -group control /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/mem_to_reg
add wave -noupdate -group control /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/reg_dst
add wave -noupdate -group control /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/mem_write
add wave -noupdate -group control /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/src_a_ctrl
add wave -noupdate -group control -radix binary /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/pc_src
add wave -noupdate -group control -radix binary /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/src_b_ctrl
add wave -noupdate -group control -radix binary /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/u_multi_cycle_control/alu_ctrl
add wave -noupdate /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/clk
add wave -noupdate /tb_multi_cycle_comp/u_multi_cycle_comp/u_MIPS_multi_cycle/reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {605000 ps} 0}
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
WaveRestoreZoom {543 ns} {607 ns}
