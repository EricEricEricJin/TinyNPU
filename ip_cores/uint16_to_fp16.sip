set_global_assignment -entity "uint16_to_fp16" -library "lib_uint16_to_fp16" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "uint16_to_fp16" -library "lib_uint16_to_fp16" -name IP_TOOL_VERSION "23.1"
set_global_assignment -entity "uint16_to_fp16" -library "lib_uint16_to_fp16" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_uint16_to_fp16" -name SPD_FILE [file join $::quartus(sip_path) "uint16_to_fp16.spd"]

set_global_assignment -library "lib_uint16_to_fp16" -name MISC_FILE [file join $::quartus(sip_path) "uint16_to_fp16_sim/uint16_to_fp16.vo"]
