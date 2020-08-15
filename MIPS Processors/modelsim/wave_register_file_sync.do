onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_register_file_sync/u_register_file_sync/memory
add wave -noupdate /tb_register_file_sync/data_rd1
add wave -noupdate /tb_register_file_sync/data_rd2
add wave -noupdate /tb_register_file_sync/addr_rd1
add wave -noupdate /tb_register_file_sync/addr_rd2
add wave -noupdate /tb_register_file_sync/addr_wr
add wave -noupdate /tb_register_file_sync/data_wr
add wave -noupdate /tb_register_file_sync/wr_enable
add wave -noupdate /tb_register_file_sync/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {63 ps} 0}
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
WaveRestoreZoom {0 ps} {73984 ps}
