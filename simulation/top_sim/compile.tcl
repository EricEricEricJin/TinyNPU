set PROJ_PATH /home/eric/Documents/Conformer-FPGA-New/TinyNPU/

set SRC_FILES { design_rtl/interface/sdram_intf.sv          \
                design_rtl/interface/bram_intf.sv           \
                design_rtl/interface/rf_ldst_intf.sv        \
                design_rtl/interface/rf_move_intf.sv        \
                design_rtl/interface/rmio_intf.sv           \
                ip_cores/ram_512x1408.v                     \
                design_rtl/register_file/rf_ram.sv          \
                design_rtl/register_file/rf_ldst.sv         \
                design_rtl/register_file/rf_move.sv         \
                design_rtl/register_file/rf_wrapper.sv      \
                design_rtl/ctrl_unit/ctrl_unit.sv           \
                design_rtl/ctrl_unit/inst_decode.sv         \
                design_rtl/design_top.sv                    \
                design_rtl/support/plexer.sv                \
                simulation/sdram_bfm/sdram_slave_bfm.sv     \
                simulation/top_sim/top_tb.sv        }

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
