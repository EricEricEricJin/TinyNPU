set TOP_LEVEL_NAME cu_sim_tb
set PROJ_PATH /home/eric/Documents/Conformer-FPGA-New/TinyNPU/

cd $PROJ_PATH

# vsim -voptargs="+acc" -t ps \
#     -L work -L work_lib -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver \
#     $TOP_LEVEL_NAME
vsim -voptargs="+acc" -t ps \
    -L work -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver \
    $TOP_LEVEL_NAME
