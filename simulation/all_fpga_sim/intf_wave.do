onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/rmio_stmm[0]/INPUT_NUM}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/rmio_stmm[0]/OUTPUT_NUM}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/rmio_stmm[0]/DATA_W}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/rmio_stmm[0]/input_data}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/rmio_stmm[0]/input_we}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/rmio_stmm[0]/output_data}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/rmio_stmm[0]/output_re}
add wave -noupdate -divider {New Divider}
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_sdram_read_intf/SDRAM_DATA_W
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_sdram_read_intf/read_addr
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_sdram_read_intf/read_cnt
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_sdram_read_intf/read_start
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_sdram_read_intf/read_data
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_sdram_read_intf/read_valid
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_sdram_read_intf/read_done
add wave -noupdate -divider {New Divider}
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/eu_fetch
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/eu_exec
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/eu_fetch_addr
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/fetch_done
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/exec_done
add wave -noupdate -divider {New Divider}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/N}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/P}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/DQ}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/Q}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/FP_LATENCY}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/clk}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/rst_n}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/X_in}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/start}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/scale_fp16}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/z_X}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/z_W}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/zero}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/W_addr}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/W_data}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/Y_out}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/out_valid}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/set_out_valid}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/X_ld}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/W_ld}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/vvm_start}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/vvm_out}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/vvm_rdy}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/vvm_out_ff}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/W_cnt}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/W_addr_acc}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/W_addr_clr}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/Y_store_nf}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/set_out_valid_nf}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/vvm_out_fp16}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/scale_out_fp16}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/scale_out_fix}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/vvm_out_nonsat}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/vvm_out_final}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/Y_store}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/Y_idx}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/Y_idx_nf}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/Y_unpacked}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/store_valid_cmd_fifo}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/state}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_stmm[0]/i_stmm/nxt_state}
add wave -noupdate -divider {New Divider}
add wave -noupdate {/all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/blk_instantiate_wmem[0]/i_we}
add wave -noupdate -divider {New Divider}
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/BRAM_W
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/BRAM_L
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/SDRAM_W
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/BLK_NUM
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/clk
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/rst_n
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/scale_fp16
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/z_X
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/z_W
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/zero
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/quant_valid
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/start
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/fetch_addr
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/done
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/line_buf
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/nxt_line
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/line_cnt
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/blk_store
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/blk_cnt
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/state
add wave -noupdate /all_top_tb/i_design_top/i_eu_top/i_stmm_wrapper/i_stmm_fetch/nxt_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {906424419 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 440
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
WaveRestoreZoom {906359508 ps} {907460492 ps}
