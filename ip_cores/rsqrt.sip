set_global_assignment -entity "rsqrt" -library "lib_rsqrt" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "rsqrt" -library "lib_rsqrt" -name IP_TOOL_VERSION "23.1"
set_global_assignment -entity "rsqrt" -library "lib_rsqrt" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_rsqrt" -name SPD_FILE [file join $::quartus(sip_path) "rsqrt.spd"]

set_global_assignment -library "lib_rsqrt" -name MISC_FILE [file join $::quartus(sip_path) "rsqrt_sim/rsqrt.vo"]
