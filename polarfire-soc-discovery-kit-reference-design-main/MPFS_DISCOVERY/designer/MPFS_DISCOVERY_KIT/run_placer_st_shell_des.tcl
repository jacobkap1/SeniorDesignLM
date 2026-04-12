set_device \
    -family  PolarFireSoC \
    -die     PA5SOC095T \
    -package fcsg325 \
    -speed   -1 \
    -tempr   {EXT} \
    -voltr   {EXT}
set_def {VOLTAGE} {1.0}
set_def {VCCI_1.2_VOLTR} {EXT}
set_def {VCCI_1.5_VOLTR} {EXT}
set_def {VCCI_1.8_VOLTR} {EXT}
set_def {VCCI_2.5_VOLTR} {EXT}
set_def {VCCI_3.3_VOLTR} {EXT}
set_def {RTG4_MITIGATION_ON} {0}
set_def USE_CONSTRAINTS_FLOW 1
set_def NETLIST_TYPE EDIF
set_name MPFS_DISCOVERY_KIT
set_workdir {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT}
set_log     {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\MPFS_DISCOVERY_KIT_sdc.log}
set_design_state pre_layout
