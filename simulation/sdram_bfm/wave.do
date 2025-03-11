onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sdram_bfm_test/clk
add wave -noupdate /sdram_bfm_test/rst_n
add wave -noupdate /sdram_bfm_test/sdram/SDRAM_DATA_W
add wave -noupdate /sdram_bfm_test/sdram/SDRAM_ADDR_W
add wave -noupdate /sdram_bfm_test/sdram/address
add wave -noupdate /sdram_bfm_test/sdram/burstcount
add wave -noupdate /sdram_bfm_test/sdram/waitrequest
add wave -noupdate /sdram_bfm_test/sdram/readdata
add wave -noupdate /sdram_bfm_test/sdram/readdatavalid
add wave -noupdate /sdram_bfm_test/sdram/read
add wave -noupdate /sdram_bfm_test/sdram/writedata
add wave -noupdate /sdram_bfm_test/sdram/byteenable
add wave -noupdate /sdram_bfm_test/sdram/write
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5460 ps} 0}
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
WaveRestoreZoom {2841 ps} {5640 ps}
