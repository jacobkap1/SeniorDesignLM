set_device -family {PolarFireSoC} -die {MPFS095T} -speed {-1}
read_adl {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\MPFS_DISCOVERY_KIT.adl}
read_afl {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\MPFS_DISCOVERY_KIT.afl}
map_netlist
read_sdc {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\constraint\MPFS_DISCOVERY_KIT_derived_constraints.sdc}
check_constraints {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\constraint\placer_sdc_errors.log}
estimate_jitter -report {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\place_and_route_jitter_report.txt}
write_sdc -mode layout {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\place_route.sdc}
