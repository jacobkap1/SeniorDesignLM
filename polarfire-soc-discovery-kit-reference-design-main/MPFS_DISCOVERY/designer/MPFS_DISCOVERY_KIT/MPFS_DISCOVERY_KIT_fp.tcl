new_project \
         -name {MPFS_DISCOVERY_KIT} \
         -location {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\MPFS_DISCOVERY_KIT_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {MPFS095T} \
         -name {MPFS095T}
enable_device \
         -name {MPFS095T} \
         -enable {TRUE}
save_project
close_project
