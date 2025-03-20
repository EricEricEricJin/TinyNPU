# todo: fix all the IPs

set PROJ_PATH /home/eric/Documents/Conformer-FPGA-New/TinyNPU/

set SRC_FILES { design_rtl/interface/sdram_intf.sv                 \
                design_rtl/interface/sdram_read_intf.sv            \
                design_rtl/io/avmm_sdram_read_wrapper.sv           \
                simulation/sdram_bfm/sdram_bfm_test.sv             \
                simulation/sdram_bfm/sdram_slave_bfm.sv  }

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
