onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sdram_bfm_test/SDRAM_W
add wave -noupdate /sdram_bfm_test/clk
add wave -noupdate /sdram_bfm_test/rst_n
add wave -noupdate /sdram_bfm_test/address
add wave -noupdate /sdram_bfm_test/burstcount
add wave -noupdate /sdram_bfm_test/waitrequest
add wave -noupdate /sdram_bfm_test/readdata
add wave -noupdate /sdram_bfm_test/readdatavalid
add wave -noupdate /sdram_bfm_test/read
add wave -noupdate /sdram_bfm_test/writedata
add wave -noupdate /sdram_bfm_test/byteenable
add wave -noupdate /sdram_bfm_test/write
add wave -noupdate /sdram_bfm_test/i_sdram_read_intf/SDRAM_DATA_W
add wave -noupdate /sdram_bfm_test/i_sdram_read_intf/read_addr
add wave -noupdate /sdram_bfm_test/i_sdram_read_intf/read_cnt
add wave -noupdate /sdram_bfm_test/i_sdram_read_intf/read_done
add wave -noupdate /sdram_bfm_test/i_sdram_read_intf/read_start
add wave -noupdate /sdram_bfm_test/i_sdram_read_intf/read_valid
add wave -noupdate /sdram_bfm_test/i_sdram_read_intf/read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {605 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2288 ps}
