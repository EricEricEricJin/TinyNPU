onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cu_sim_tb/RF_ADDR_W
add wave -noupdate /cu_sim_tb/clk
add wave -noupdate /cu_sim_tb/rst_n
add wave -noupdate /cu_sim_tb/h2f_io
add wave -noupdate /cu_sim_tb/h2f_write
add wave -noupdate /cu_sim_tb/isrunning
add wave -noupdate /cu_sim_tb/eu_fetch
add wave -noupdate /cu_sim_tb/eu_exec
add wave -noupdate /cu_sim_tb/eu_fetch_addr
add wave -noupdate -divider {New Divider}
add wave -noupdate /cu_sim_tb/i_rf_move_intf/RF_ADDR_W
add wave -noupdate /cu_sim_tb/i_rf_move_intf/LINE_NUM_W
add wave -noupdate /cu_sim_tb/i_rf_move_intf/start
add wave -noupdate /cu_sim_tb/i_rf_move_intf/src_addr
add wave -noupdate /cu_sim_tb/i_rf_move_intf/dst_addr
add wave -noupdate /cu_sim_tb/i_rf_move_intf/line_num
add wave -noupdate -divider {New Divider}
add wave -noupdate /cu_sim_tb/i_rf_ldst_intf/RF_ADDR_W
add wave -noupdate /cu_sim_tb/i_rf_ldst_intf/LINE_NUM_W
add wave -noupdate /cu_sim_tb/i_rf_ldst_intf/SDRAM_ADDR_W
add wave -noupdate /cu_sim_tb/i_rf_ldst_intf/load_start
add wave -noupdate /cu_sim_tb/i_rf_ldst_intf/store_start
add wave -noupdate /cu_sim_tb/i_rf_ldst_intf/rf_addr
add wave -noupdate /cu_sim_tb/i_rf_ldst_intf/sdram_addr
add wave -noupdate /cu_sim_tb/i_rf_ldst_intf/line_num
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {178 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
