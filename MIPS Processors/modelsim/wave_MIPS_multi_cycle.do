onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label reg_file /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/u_register_file/memory
add wave -noupdate -group interface /tb_mips_multi_cycle/mem_word
add wave -noupdate -group interface /tb_mips_multi_cycle/mem_addr
add wave -noupdate -group interface /tb_mips_multi_cycle/data_wr
add wave -noupdate -expand -group state /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/ps
add wave -noupdate -expand -group state /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/ns
add wave -noupdate -group registers /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/pc
add wave -noupdate -group registers /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/pc_n
add wave -noupdate -group registers /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/mem_data
add wave -noupdate -group registers /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/sign_imm
add wave -noupdate -group registers /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/reg_rd1
add wave -noupdate -group registers /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/reg_rd2
add wave -noupdate -group registers /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/alu_out
add wave -noupdate -group ALU /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/u_ALU/a
add wave -noupdate -group ALU /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/u_ALU/b
add wave -noupdate -group ALU /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/u_ALU/funct
add wave -noupdate -group ALU /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_datapath/u_ALU/output
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/branch
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/pc_wr
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/i_or_d
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/instr_wr
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/reg_wr
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/mem_to_reg
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/reg_dst
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/mem_write
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/src_a_ctrl
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/pc_src
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/src_b_ctrl
add wave -noupdate -group control /tb_mips_multi_cycle/u_MIPS_multi_cycle/u_multi_cycle_control/alu_ctrl
add wave -noupdate /tb_mips_multi_cycle/clk
add wave -noupdate /tb_mips_multi_cycle/reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94603 ps} 0}
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
WaveRestoreZoom {71724 ps} {132012 ps}
