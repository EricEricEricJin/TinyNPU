onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cu_sim_tb/i_ctrl_unit/RF_ADDR_W
add wave -noupdate /cu_sim_tb/i_ctrl_unit/clk
add wave -noupdate /cu_sim_tb/i_ctrl_unit/rst_n
add wave -noupdate /cu_sim_tb/i_ctrl_unit/h2f_io
add wave -noupdate /cu_sim_tb/i_ctrl_unit/h2f_write
add wave -noupdate /cu_sim_tb/i_ctrl_unit/rf_ram_sel
add wave -noupdate /cu_sim_tb/i_ctrl_unit/sdram_read_sel
add wave -noupdate /cu_sim_tb/i_ctrl_unit/eu_fetch
add wave -noupdate /cu_sim_tb/i_ctrl_unit/eu_exec
add wave -noupdate /cu_sim_tb/i_ctrl_unit/eu_fetch_addr
add wave -noupdate /cu_sim_tb/i_ctrl_unit/done
add wave -noupdate /cu_sim_tb/i_ctrl_unit/set_ram_sel_move
add wave -noupdate /cu_sim_tb/i_ctrl_unit/set_ram_sel_ldst
add wave -noupdate /cu_sim_tb/i_ctrl_unit/load
add wave -noupdate /cu_sim_tb/i_ctrl_unit/store
add wave -noupdate /cu_sim_tb/i_ctrl_unit/move
add wave -noupdate /cu_sim_tb/i_ctrl_unit/fetch
add wave -noupdate /cu_sim_tb/i_ctrl_unit/exec
add wave -noupdate /cu_sim_tb/i_ctrl_unit/eu_unit
add wave -noupdate /cu_sim_tb/i_ctrl_unit/set_sdram_read_sel
add wave -noupdate /cu_sim_tb/i_ctrl_unit/eu_unit_onehot
add wave -noupdate /cu_sim_tb/i_ctrl_unit/state
add wave -noupdate /cu_sim_tb/i_ctrl_unit/nxt_state
add wave -noupdate -divider {New Divider}
add wave -noupdate /cu_sim_tb/i_rf_move_intf/RF_ADDR_W
add wave -noupdate /cu_sim_tb/i_rf_move_intf/LINE_NUM_W
add wave -noupdate /cu_sim_tb/i_rf_move_intf/start
add wave -noupdate /cu_sim_tb/i_rf_move_intf/src_addr
add wave -noupdate /cu_sim_tb/i_rf_move_intf/dst_addr
add wave -noupdate /cu_sim_tb/i_rf_move_intf/line_num
add wave -noupdate /cu_sim_tb/i_rf_move_intf/src_freeze
add wave -noupdate /cu_sim_tb/i_rf_move_intf/dst_freeze
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
WaveRestoreCursors {{Cursor 1} {132 ps} 0}
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
WaveRestoreZoom {0 ps} {964 ps}
