onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rf_ldst_tb/i_sdram_intf/SDRAM_DATA_W
add wave -noupdate /rf_ldst_tb/i_sdram_intf/SDRAM_ADDR_W
add wave -noupdate /rf_ldst_tb/i_sdram_intf/address
add wave -noupdate /rf_ldst_tb/i_sdram_intf/burstcount
add wave -noupdate /rf_ldst_tb/i_sdram_intf/waitrequest
add wave -noupdate /rf_ldst_tb/i_sdram_intf/readdata
add wave -noupdate /rf_ldst_tb/i_sdram_intf/readdatavalid
add wave -noupdate /rf_ldst_tb/i_sdram_intf/read
add wave -noupdate /rf_ldst_tb/i_sdram_intf/writedata
add wave -noupdate /rf_ldst_tb/i_sdram_intf/byteenable
add wave -noupdate /rf_ldst_tb/i_sdram_intf/write
add wave -noupdate -divider {New Divider}
add wave -noupdate /rf_ldst_tb/i_rf_ldst_intf/RF_ADDR_W
add wave -noupdate /rf_ldst_tb/i_rf_ldst_intf/LINE_NUM_W
add wave -noupdate /rf_ldst_tb/i_rf_ldst_intf/SDRAM_ADDR_W
add wave -noupdate /rf_ldst_tb/i_rf_ldst_intf/load_start
add wave -noupdate /rf_ldst_tb/i_rf_ldst_intf/store_start
add wave -noupdate /rf_ldst_tb/i_rf_ldst_intf/rf_addr
add wave -noupdate /rf_ldst_tb/i_rf_ldst_intf/sdram_addr
add wave -noupdate /rf_ldst_tb/i_rf_ldst_intf/line_num
add wave -noupdate -divider {New Divider}
add wave -noupdate /rf_ldst_tb/i_rf_ram/RF_DATA_W
add wave -noupdate /rf_ldst_tb/i_rf_ram/RF_ADDR_W
add wave -noupdate /rf_ldst_tb/i_rf_ram/REAL_RAM_ADDR_W
add wave -noupdate /rf_ldst_tb/i_rf_ram/clk
add wave -noupdate /rf_ldst_tb/i_rf_ram/is_real_ram_addr
add wave -noupdate /rf_ldst_tb/i_rf_ram/addr_ff
add wave -noupdate -divider {New Divider}
add wave -noupdate /rf_ldst_tb/i_rf_ldst/RF_ADDR_W
add wave -noupdate /rf_ldst_tb/i_rf_ldst/LINE_NUM_W
add wave -noupdate /rf_ldst_tb/i_rf_ldst/SDRAM_DATA_W
add wave -noupdate /rf_ldst_tb/i_rf_ldst/RF_DATA_W
add wave -noupdate /rf_ldst_tb/i_rf_ldst/clk
add wave -noupdate /rf_ldst_tb/i_rf_ldst/rst_n
add wave -noupdate /rf_ldst_tb/i_rf_ldst/done
add wave -noupdate /rf_ldst_tb/i_rf_ldst/line_nxt
add wave -noupdate /rf_ldst_tb/i_rf_ldst/line_buf_ld_from_sdram
add wave -noupdate /rf_ldst_tb/i_rf_ldst/line_buf_ld_from_rf
add wave -noupdate /rf_ldst_tb/i_rf_ldst/line_buf_idx_inc
add wave -noupdate /rf_ldst_tb/i_rf_ldst/line_buf_idx_clr
add wave -noupdate /rf_ldst_tb/i_rf_ldst/sdram_addr
add wave -noupdate /rf_ldst_tb/i_rf_ldst/rf_addr
add wave -noupdate /rf_ldst_tb/i_rf_ldst/line_cnt
add wave -noupdate /rf_ldst_tb/i_rf_ldst/rf_ram_q_unpacked
add wave -noupdate /rf_ldst_tb/i_rf_ldst/line_buf
add wave -noupdate /rf_ldst_tb/i_rf_ldst/line_buf_packed
add wave -noupdate /rf_ldst_tb/i_rf_ldst/line_buf_idx
add wave -noupdate /rf_ldst_tb/i_rf_ldst/state
add wave -noupdate /rf_ldst_tb/i_rf_ldst/nxt_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12871250 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 241
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
WaveRestoreZoom {12840884 ps} {12901617 ps}
