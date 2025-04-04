set_global_assignment -entity "int16_to_fp16" -library "lib_int16_to_fp16" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "int16_to_fp16" -library "lib_int16_to_fp16" -name IP_TOOL_VERSION "23.1"
set_global_assignment -entity "int16_to_fp16" -library "lib_int16_to_fp16" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_int16_to_fp16" -name SPD_FILE [file join $::quartus(sip_path) "int16_to_fp16.spd"]

set_global_assignment -library "lib_int16_to_fp16" -name MISC_FILE [file join $::quartus(sip_path) "int16_to_fp16_sim/int16_to_fp16.vo"]
