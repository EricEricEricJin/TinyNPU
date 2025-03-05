# todo: fix all the IPs

set PROJ_PATH /home/eric/Documents/Conformer-FPGA-New/TinyNPU/

set SRC_FILES { design_rtl/interface/rf_ldst_intf.sv  \
                design_rtl/support/plexer_funcs.sv  \
                design_rtl/ctrl_unit/ctrl_unit.sv   \
                design_rtl/ctrl_unit/inst_decode.sv \
                simulation/ctrl_unit_sim/cu_sim_tb.sv }

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
