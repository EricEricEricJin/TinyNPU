onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fifo_tb/clk
add wave -noupdate /fifo_tb/rst_n
add wave -noupdate /fifo_tb/data_in
add wave -noupdate /fifo_tb/we_in
add wave -noupdate /fifo_tb/done
add wave -noupdate /fifo_tb/i_bram_intf/ADDR_W
add wave -noupdate /fifo_tb/i_bram_intf/DATA_W
add wave -noupdate /fifo_tb/i_bram_intf/addr
add wave -noupdate /fifo_tb/i_bram_intf/data
add wave -noupdate /fifo_tb/i_bram_intf/q
add wave -noupdate /fifo_tb/i_bram_intf/we
add wave -noupdate /fifo_tb/i_bram_intf/re
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {61563799438 ps} 0}
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
WaveRestoreZoom {61563799050 ps} {61563800050 ps}
