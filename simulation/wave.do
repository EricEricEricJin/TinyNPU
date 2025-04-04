onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/N}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/Q}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/AVG_MUL}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/AVG_BS}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/GAMMA_PATH_LATENCY}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/clk}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/rst_n}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/x_in}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/gamma_scaled_hi}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/gamma_scaled_lo}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/beta_scaled}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/start}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/y_out}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/out_valid}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/x_in_unpacked}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/beta_scaled_unpacked}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/gamma_scaled_unpacked}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/idx_acc}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/idx_clr}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/avg_acc}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/avg_clr}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/ld_x_mean}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/ld_sd_mean}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/avg_sel}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/latency_start}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/store_y_nf}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/store_y}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/sd_valid}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/gamma_path_flop}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/set_out_valid}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/latency_done}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/rsqrt_done}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/index}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/avg_in}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/avg_sum}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/avg_mul}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/avg_out}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/x_mean}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/sd_mean}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/xd}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/y1}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/cs_in}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/cs_out}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/y_idx}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/y_i_raw}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/y_i}
add wave -noupdate -expand {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/y_out_unpacked}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/state}
add wave -noupdate {/top_tb/i_design_top/i_eu_top/i_layernorm_wrapper/blk_instantiate_layernorm[0]/i_layernorm/nxt_state}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {932951679 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 506
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
WaveRestoreZoom {931775312 ps} {934564688 ps}
