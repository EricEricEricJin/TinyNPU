set_global_assignment -entity "mult_fp16" -library "lib_mult_fp16" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "mult_fp16" -library "lib_mult_fp16" -name IP_TOOL_VERSION "23.1"
set_global_assignment -entity "mult_fp16" -library "lib_mult_fp16" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_mult_fp16" -name SPD_FILE [file join $::quartus(sip_path) "mult_fp16.spd"]

set_global_assignment -library "lib_mult_fp16" -name MISC_FILE [file join $::quartus(sip_path) "mult_fp16_sim/mult_fp16.vo"]
