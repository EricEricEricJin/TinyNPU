# todo: fix all the IPs

set PROJ_PATH /home/eric/Documents/Conformer-FPGA-New/TinyNPU/

set SRC_FILES { design_rtl/interface/bram_intf.sv       \
                design_rtl/interface/rmio_intf.sv       \
                design_rtl/register_file/rf_ram.sv      \
                simulation/rf_ram_sim/rf_ram_tb.sv      \
                ip_cores/ram_512x1408.v }   

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
