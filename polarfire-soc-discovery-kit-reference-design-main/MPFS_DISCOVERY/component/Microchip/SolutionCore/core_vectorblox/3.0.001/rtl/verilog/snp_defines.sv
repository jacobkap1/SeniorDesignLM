//=================================================================================================
// Targeted device                     : Microchip FPGAs
// Author                              : Solutions Team
//
// COPYRIGHT 2024 BY MICROCHIP
// THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROCHIP
// CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROCHIP FOR USE OF THIS
// FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//
//=================================================================================================


//------------------------------------------------------------------------------
`ifndef SNP_DEFINES_SV
 `define SNP_DEFINES_SV

//`define NEUMAGIC_NN  // influence on configuration mapping lines

//`define USE_WLUT_RAM_DEFINE
`define USE_XILINX_IP_DEFINE

// Uncomment for two clock domains
`define USE_DUAL_CLOCK_DOMAIN

// In clock domain crossing, how many sync regs will there be
`define CDC_FF_CNT 4      

// Depth of fifo connecting datamover and AXI full controller
`define LP_FIFO_DEPTH 16  

//`define USE_DEBUG_CORE

//`define SNP_ENG_BB

`endif //  `ifndef SNP_DEFINES_SV

