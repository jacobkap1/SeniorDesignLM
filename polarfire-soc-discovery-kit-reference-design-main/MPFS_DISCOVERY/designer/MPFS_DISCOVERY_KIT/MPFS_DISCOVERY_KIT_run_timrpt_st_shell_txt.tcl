
set max_timing_multi_corner [report \
    -type     timing \
    -analysis max \
    -multi_corner yes \
    -format   text \
    {MPFS_DISCOVERY_KIT_timing_r33_s16.rpt}]
set max_timing_violations_multi_corner [report \
    -type     timing_violations \
    -analysis max \
    -multi_corner yes \
    -format   text \
    -use_slack_threshold no \
    -max_paths 100 \
    {MPFS_DISCOVERY_KIT_timing_violations_max_r33_s16.rpt}]
set min_timing_violations_multi_corner [report \
    -type     timing_violations \
    -analysis min \
    -multi_corner yes \
    -format   text \
    -use_slack_threshold no \
    -max_paths 100 \
    {MPFS_DISCOVERY_KIT_timing_violations_min_r33_s16.rpt}]
set has_violations {MPFS_DISCOVERY_KIT_has_violations}
set fp [open $has_violations w]
puts $fp "_max_timing_violations_multi_corner $max_timing_violations_multi_corner"
puts $fp "_max_timing_multi_corner $max_timing_multi_corner"
puts $fp "_min_timing_violations_multi_corner $min_timing_violations_multi_corner"
close $fp
