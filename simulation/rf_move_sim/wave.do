onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rf_move_tb/i_rf_move/ADDR_W
add wave -noupdate /rf_move_tb/i_rf_move/LINE_NUM_W
add wave -noupdate /rf_move_tb/i_rf_move/clk
add wave -noupdate /rf_move_tb/i_rf_move/rst_n
add wave -noupdate /rf_move_tb/i_rf_move/done
add wave -noupdate /rf_move_tb/i_rf_move/line_cnt_dec
add wave -noupdate /rf_move_tb/i_rf_move/line_cnt
add wave -noupdate /rf_move_tb/i_rf_move/src_addr
add wave -noupdate /rf_move_tb/i_rf_move/dst_addr
add wave -noupdate /rf_move_tb/i_rf_move/state
add wave -noupdate /rf_move_tb/i_rf_move/nxt_state
add wave -noupdate /rf_move_tb/i_rf_move/rf_move/RF_ADDR_W
add wave -noupdate /rf_move_tb/i_rf_move/rf_move/LINE_NUM_W
add wave -noupdate /rf_move_tb/i_rf_move/rf_move/TEST_PARAM
add wave -noupdate /rf_move_tb/i_rf_move/rf_move/start
add wave -noupdate /rf_move_tb/i_rf_move/rf_move/src_addr
add wave -noupdate /rf_move_tb/i_rf_move/rf_move/dst_addr
add wave -noupdate /rf_move_tb/i_rf_move/rf_move/line_num
add wave -noupdate /rf_move_tb/i_rf_move/ram/ADDR_W
add wave -noupdate /rf_move_tb/i_rf_move/ram/DATA_W
add wave -noupdate /rf_move_tb/i_rf_move/ram/addr
add wave -noupdate /rf_move_tb/i_rf_move/ram/data
add wave -noupdate /rf_move_tb/i_rf_move/ram/q
add wave -noupdate /rf_move_tb/i_rf_move/ram/we
add wave -noupdate /rf_move_tb/i_rf_move/ram/re
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1058848 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 182
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
WaveRestoreZoom {1013314 ps} {1225616 ps}
