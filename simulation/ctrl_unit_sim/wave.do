onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cu_sim_tb/RF_ADDR_W
add wave -noupdate /cu_sim_tb/clk
add wave -noupdate /cu_sim_tb/rst_n
add wave -noupdate /cu_sim_tb/h2f_io
add wave -noupdate /cu_sim_tb/h2f_write
add wave -noupdate /cu_sim_tb/isrunning
add wave -noupdate /cu_sim_tb/move_start
add wave -noupdate /cu_sim_tb/move_src_addr
add wave -noupdate /cu_sim_tb/move_dst_addr
add wave -noupdate /cu_sim_tb/move_line_num
add wave -noupdate /cu_sim_tb/ldst_sdram_addr
add wave -noupdate /cu_sim_tb/ldst_rf_addr
add wave -noupdate /cu_sim_tb/ldst_line_num
add wave -noupdate /cu_sim_tb/load_start
add wave -noupdate /cu_sim_tb/store_start
add wave -noupdate /cu_sim_tb/eu_fetch
add wave -noupdate /cu_sim_tb/eu_exec
add wave -noupdate /cu_sim_tb/eu_fetch_addr
add wave -noupdate -divider {New Divider}
add wave -noupdate /cu_sim_tb/i_ctrl_unit/RF_ADDR_W
add wave -noupdate /cu_sim_tb/i_ctrl_unit/clk
add wave -noupdate /cu_sim_tb/i_ctrl_unit/rst_n
add wave -noupdate /cu_sim_tb/i_ctrl_unit/h2f_io
add wave -noupdate /cu_sim_tb/i_ctrl_unit/h2f_write
add wave -noupdate /cu_sim_tb/i_ctrl_unit/isrunning
add wave -noupdate /cu_sim_tb/i_ctrl_unit/move_start
add wave -noupdate /cu_sim_tb/i_ctrl_unit/move_src_addr
add wave -noupdate /cu_sim_tb/i_ctrl_unit/move_dst_addr
add wave -noupdate /cu_sim_tb/i_ctrl_unit/move_line_num
add wave -noupdate /cu_sim_tb/i_ctrl_unit/ldst_sdram_addr
add wave -noupdate /cu_sim_tb/i_ctrl_unit/ldst_rf_addr
add wave -noupdate /cu_sim_tb/i_ctrl_unit/ldst_line_num
add wave -noupdate /cu_sim_tb/i_ctrl_unit/load_start
add wave -noupdate /cu_sim_tb/i_ctrl_unit/store_start
add wave -noupdate /cu_sim_tb/i_ctrl_unit/eu_fetch
add wave -noupdate /cu_sim_tb/i_ctrl_unit/eu_exec
add wave -noupdate /cu_sim_tb/i_ctrl_unit/eu_fetch_addr
add wave -noupdate /cu_sim_tb/i_ctrl_unit/load
add wave -noupdate /cu_sim_tb/i_ctrl_unit/store
add wave -noupdate /cu_sim_tb/i_ctrl_unit/move
add wave -noupdate /cu_sim_tb/i_ctrl_unit/fetch
add wave -noupdate /cu_sim_tb/i_ctrl_unit/exec
add wave -noupdate /cu_sim_tb/i_ctrl_unit/eu_unit
add wave -noupdate /cu_sim_tb/i_ctrl_unit/eu_unit_onehot
add wave -noupdate /cu_sim_tb/i_ctrl_unit/state
add wave -noupdate /cu_sim_tb/i_ctrl_unit/nxt_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {342 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 197
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {875 ps}
