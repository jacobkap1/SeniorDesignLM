read_sdc -scenario "place_and_route" -netlist "optimized" -pin_separator "/" -ignore_errors {C:/Users/Danug/Documents/Code/SecureVISION-polarfire-reference-design/MPFS_DISCOVERY/designer/MPFS_DISCOVERY_KIT/place_route.sdc}
set_options -tdpr_scenario "place_and_route" 
save
set_options -analysis_scenario "place_and_route"
report -type combinational_loops -format xml {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\MPFS_DISCOVERY_KIT_layout_combinational_loops.xml}
report -type slack {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\pinslacks.txt}
set coverage [report \
    -type     constraints_coverage \
    -format   xml \
    -slacks   no \
    {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\MPFS_DISCOVERY_KIT_place_and_route_constraint_coverage.xml}]
set reportfile {C:\Users\Danug\Documents\Code\SecureVISION-polarfire-reference-design\MPFS_DISCOVERY\designer\MPFS_DISCOVERY_KIT\coverage_placeandroute}
set fp [open $reportfile w]
puts $fp $coverage
close $fp