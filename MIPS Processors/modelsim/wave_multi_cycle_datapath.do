onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label reg_file /tb_multi_cycle_datapath/u_multi_cycle_datapath/u_register_file/memory
add wave -noupdate /tb_multi_cycle_datapath/u_multi_cycle_datapath/u_ALU/a
add wave -noupdate /tb_multi_cycle_datapath/u_multi_cycle_datapath/u_ALU/b
add wave -noupdate /tb_multi_cycle_datapath/u_multi_cycle_datapath/u_ALU/output
add wave -noupdate /tb_multi_cycle_datapath/u_multi_cycle_datapath/instr
add wave -noupdate /tb_multi_cycle_datapath/u_multi_cycle_datapath/pc
add wave -noupdate /tb_multi_cycle_datapath/u_multi_cycle_datapath/pc_n
add wave -noupdate /tb_multi_cycle_datapath/u_multi_cycle_datapath/mem_data
add wave -noupdate /tb_multi_cycle_datapath/u_multi_cycle_datapath/reg_rd1
add wave -noupdate /tb_multi_cycle_datapath/u_multi_cycle_datapath/reg_rd2
add wave -noupdate -radix binary /tb_multi_cycle_datapath/alu_ctrl
add wave -noupdate /tb_multi_cycle_datapath/u_multi_cycle_datapath/sign_imm
add wave -noupdate /tb_multi_cycle_datapath/mem_word
add wave -noupdate /tb_multi_cycle_datapath/data_wr
add wave -noupdate /tb_multi_cycle_datapath/mem_addr
add wave -noupdate -group Control -radix binary /tb_multi_cycle_datapath/pc_src
add wave -noupdate -group Control -radix binary /tb_multi_cycle_datapath/src_a_ctrl
add wave -noupdate -group Control -radix binary /tb_multi_cycle_datapath/src_b_ctrl
add wave -noupdate -group Control /tb_multi_cycle_datapath/branch
add wave -noupdate -group Control /tb_multi_cycle_datapath/pc_wr
add wave -noupdate -group Control /tb_multi_cycle_datapath/i_or_d
add wave -noupdate -group Control /tb_multi_cycle_datapath/instr_wr
add wave -noupdate -group Control /tb_multi_cycle_datapath/reg_wr
add wave -noupdate -group Control /tb_multi_cycle_datapath/mem_to_reg
add wave -noupdate -group Control /tb_multi_cycle_datapath/reg_dst
add wave -noupdate -group Control /tb_multi_cycle_datapath/zero
add wave -noupdate /tb_multi_cycle_datapath/reset
add wave -noupdate /tb_multi_cycle_datapath/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {216750 ps} 0}
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
WaveRestoreZoom {189200 ps} {253200 ps}
