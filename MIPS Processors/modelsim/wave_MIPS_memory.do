onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips_memory/data_rd1
add wave -noupdate /tb_mips_memory/data_rd2
add wave -noupdate /tb_mips_memory/clk
add wave -noupdate /tb_mips_memory/addr1
add wave -noupdate /tb_mips_memory/addr2
add wave -noupdate /tb_mips_memory/data_wr
add wave -noupdate /tb_mips_memory/wr_enable
add wave -noupdate /tb_mips_memory/u_MIPS_memory/memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16904 ps} 0}
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
WaveRestoreZoom {0 ps} {70912 ps}
