set PROJ_PATH /home/eric/Documents/Conformer-FPGA-New/TinyNPU/

set SRC_FILES {
    design_rtl/ctrl_unit/*.sv             \
    design_rtl/exec_unit/stmm/*.sv        \
    design_rtl/exec_unit/layernorm/*.sv   \
    design_rtl/exec_unit/*.sv             \
    design_rtl/exec_unit/lut/*.sv        \
    design_rtl/interface/*.sv              \
    design_rtl/io/*.sv                     \
    design_rtl/register_file/*.sv          \
    design_rtl/support/*.sv                \
    design_rtl/design_top.sv               \
    ip_cores/mult_int8.v                    \
    ip_cores/ram_512x1408.v                 \
    ip_cores/ram_176x1408.v                 \
    ip_cores/fifo_16x128.v               \
    simulation/testbench/avmm_raw_intf.sv \
    simulation/testbench/avmm_sdram_bfm.sv \
    simulation/testbench/hps_bfm.sv       \
    simulation/testbench/soc_system_bfm.sv  \
    simulation/testbench/top_tb.sv   \
}

set IP_SIM_DIRS { 
    ip_cores/fp16_to_int16_sim         \
    ip_cores/int18_to_fp16_sim         \
    ip_cores/int16_to_fp16_sim         \
    ip_cores/uint16_to_fp16_sim        \
    ip_cores/mult_fp16_sim             \
    ip_cores/rsqrt_sim                 \
}

# compile all IP cores
cd $PROJ_PATH
foreach QSYS_SIMDIR $IP_SIM_DIRS {
    source $QSYS_SIMDIR/mentor/msim_setup.tcl
    dev_com
    com 
}
# unalias -all 

# compile my design
cd $PROJ_PATH
vlog -sv {*}$SRC_FILES
# cd $PROJ_PATH   
