----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Sun Mar 22 21:43:10 2026
-- Parameters for core_vectorblox
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant FAMILY : integer := 26;
    constant HDL_license : string( 1 to 1 ) := "O";
    constant M0_AXI_DATA_WIDTH : integer := 64;
    constant M1_AXI_DATA_WIDTH : integer := 256;
    constant M_AXI_PORTS : integer := 1;
    constant PARAM_IS_FALSE : integer := 0;
    constant PRESET : integer := 1;
    constant SPARSITY : integer := 1;
    constant TGIGEN_DISPLAY_SYMBOL : integer := 1;
end coreparameters;
