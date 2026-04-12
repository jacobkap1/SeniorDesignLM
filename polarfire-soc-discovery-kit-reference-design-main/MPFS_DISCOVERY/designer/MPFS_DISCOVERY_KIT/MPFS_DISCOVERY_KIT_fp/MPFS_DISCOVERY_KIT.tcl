open_project -project {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\MPFS_DISCOVERY_KIT_fp\MPFS_DISCOVERY_KIT.pro}
enable_device -name {MPFS095T} -enable 1
set_programming_file -name {MPFS095T} -file {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\MPFS_DISCOVERY_KIT.ppd}
set_programming_action -action {PROGRAM} -name {MPFS095T} 
run_selected_actions
save_project
close_project
