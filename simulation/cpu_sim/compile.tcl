# todo: fix all the IPs

set PROJ_PATH /home/eric/Documents/Conformer-FPGA-New/TinyNPU/

set SRC_FILES { design_rtl/cpu/cpu_typedef.sv   \
                design_rtl/cpu/alu.sv           \
                design_rtl/cpu/br_logic.sv      \
                design_rtl/cpu/cpu_typedef.sv   \
                design_rtl/cpu/cpu.sv           \
                design_rtl/cpu/inst_decode.sv   \
                design_rtl/cpu/rf32.sv          \
                design_rtl/cpu/inst_mem.sv      \
                ip_cores/ram_32x256.v           \
                simulation/cpu_sim/cpu_sim_tb.sv }

set IP_SIM_DIRS {  }

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
