set_global_assignment -entity "fp16_to_int16" -library "lib_fp16_to_int16" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "fp16_to_int16" -library "lib_fp16_to_int16" -name IP_TOOL_VERSION "23.1"
set_global_assignment -entity "fp16_to_int16" -library "lib_fp16_to_int16" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_fp16_to_int16" -name SPD_FILE [file join $::quartus(sip_path) "fp16_to_int16.spd"]

set_global_assignment -library "lib_fp16_to_int16" -name MISC_FILE [file join $::quartus(sip_path) "fp16_to_int16_sim/fp16_to_int16.vo"]
