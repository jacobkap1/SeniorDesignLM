set_component PF_CCC_C1_PF_CCC_C1_0_PF_CCC
# Microchip Technology Inc.
# Date: 2026-Apr-08 02:23:20
#

# Base clock for PLL #0
create_clock -period 11.4286 [ get_pins { pll_inst_0/REF_CLK_0 } ]
create_generated_clock -multiply_by 4 -divide_by 5 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT0 } ]
