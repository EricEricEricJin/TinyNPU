set PROJ_PATH /home/eric/Documents/Conformer-FPGA-New/TinyNPU/

set SRC_FILES {
    design_rtl/interface/bram_intf.sv \
    design_rtl/exec_unit/lut/lut_fetch_fifo.sv \
    ip_cores/fifo_16x128.v \
    fifo_test/fifo_tb.sv \
}

cd $PROJ_PATH
vlog -sv {*}$SRC_FILES