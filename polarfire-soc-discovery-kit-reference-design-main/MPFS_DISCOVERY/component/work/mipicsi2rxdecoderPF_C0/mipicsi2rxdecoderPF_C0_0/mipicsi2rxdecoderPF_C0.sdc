set_component mipicsi2rxdecoderPF_C0
set_false_path -through [ get_pins { */*/*ctrl_reg*}]
set_false_path -through [ get_pins { */*/*glbl_int_en*}]
set_false_path -through [ get_pins { */*/*int_en*}]
set_false_path -through [ get_pins { */*/*int_status_clr*}]
set_false_path -through [ get_pins { */*/*mem_rd_data*}]
