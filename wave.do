onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {New Divider}
add wave -noupdate /cpu_sim_tb/INST_MEM_FILE
add wave -noupdate /cpu_sim_tb/clk
add wave -noupdate /cpu_sim_tb/rst_n
add wave -noupdate /cpu_sim_tb/cpu_inst_addr
add wave -noupdate /cpu_sim_tb/cpu_inst_data
add wave -noupdate /cpu_sim_tb/tb_inst_addr
add wave -noupdate /cpu_sim_tb/tb_inst_data
add wave -noupdate /cpu_sim_tb/inst_we
add wave -noupdate /cpu_sim_tb/ram_inst_addr
add wave -noupdate /cpu_sim_tb/data_addr
add wave -noupdate /cpu_sim_tb/data_we
add wave -noupdate /cpu_sim_tb/data_d
add wave -noupdate /cpu_sim_tb/data_q
add wave -noupdate /cpu_sim_tb/ebreak
add wave -noupdate -divider {New Divider}
add wave -noupdate /cpu_sim_tb/i_cpu/clk
add wave -noupdate /cpu_sim_tb/i_cpu/rst_n
add wave -noupdate /cpu_sim_tb/i_cpu/inst_addr
add wave -noupdate /cpu_sim_tb/i_cpu/inst_data
add wave -noupdate /cpu_sim_tb/i_cpu/data_addr
add wave -noupdate /cpu_sim_tb/i_cpu/data_we
add wave -noupdate /cpu_sim_tb/i_cpu/data_d
add wave -noupdate /cpu_sim_tb/i_cpu/data_q
add wave -noupdate /cpu_sim_tb/i_cpu/ebreak
add wave -noupdate /cpu_sim_tb/i_cpu/prgm_cnt
add wave -noupdate /cpu_sim_tb/i_cpu/prgm_cnt_d
add wave -noupdate /cpu_sim_tb/i_cpu/br_fun
add wave -noupdate /cpu_sim_tb/i_cpu/alu_fun
add wave -noupdate /cpu_sim_tb/i_cpu/rf_we
add wave -noupdate /cpu_sim_tb/i_cpu/sw_en
add wave -noupdate /cpu_sim_tb/i_cpu/op1_sel
add wave -noupdate /cpu_sim_tb/i_cpu/op2_sel
add wave -noupdate /cpu_sim_tb/i_cpu/wb_sel
add wave -noupdate /cpu_sim_tb/i_cpu/pc_sel
add wave -noupdate /cpu_sim_tb/i_cpu/s_im
add wave -noupdate /cpu_sim_tb/i_cpu/i_im
add wave -noupdate /cpu_sim_tb/i_cpu/b_im
add wave -noupdate /cpu_sim_tb/i_cpu/u_im
add wave -noupdate /cpu_sim_tb/i_cpu/j_im
add wave -noupdate /cpu_sim_tb/i_cpu/ra1
add wave -noupdate /cpu_sim_tb/i_cpu/ra2
add wave -noupdate /cpu_sim_tb/i_cpu/rf_wa
add wave -noupdate /cpu_sim_tb/i_cpu/rf_wd
add wave -noupdate /cpu_sim_tb/i_cpu/rf_rd1
add wave -noupdate /cpu_sim_tb/i_cpu/rf_rd2
add wave -noupdate /cpu_sim_tb/i_cpu/alu_in0
add wave -noupdate /cpu_sim_tb/i_cpu/alu_in1
add wave -noupdate /cpu_sim_tb/i_cpu/alu_out
add wave -noupdate /cpu_sim_tb/i_cpu/bcomp
add wave -noupdate -divider InstDecoder
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/inst
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/br_fun
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/rs1
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/rs2
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/rd
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/alu_fun
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/wb_sel
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/op1_sel
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/op2_sel
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/pc_sel
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/sw_en
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/rf_we
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/i_im
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/s_im
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/b_im
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/u_im
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/j_im
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/err_op_unk
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/op
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/fun3
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/fun7
add wave -noupdate /cpu_sim_tb/i_cpu/i_inst_decode/inst_type
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12317 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 187
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
WaveRestoreZoom {0 ps} {48146 ps}
