read_sdc -scenario "timing_analysis" -netlist "optimized" -pin_separator "/" -ignore_errors {C:/Users/Danug/Documents/Code/SecureVISION-polarfire-reference-design/MPFS_DISCOVERY/designer/MPFS_DISCOVERY_KIT/timing_analysis.sdc}
set_options -analysis_scenario "timing_analysis" 
save
source {MPFS_DISCOVERY_KIT_run_timrpt_st_shell_txt.tcl}
