--
-- Synopsys
-- Vhdl wrapper for top level design, written on Sun Apr 12 01:13:48 2026
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wrapper_for_neoTRNG is
   port (
      clk_i : in std_ulogic;
      rstn_i : in std_ulogic;
      enable_i : in std_ulogic;
      valid_o : out std_ulogic;
      data_o : out std_ulogic_vector(7 downto 0)
   );
end wrapper_for_neoTRNG;

architecture neotrng_rtl of wrapper_for_neoTRNG is

component neoTRNG
 port (
   clk_i : in std_logic;
   rstn_i : in std_logic;
   enable_i : in std_logic;
   valid_o : out std_logic;
   data_o : out std_logic_vector (7 downto 0)
 );
end component;

signal tmp_clk_i : std_logic;
signal tmp_rstn_i : std_logic;
signal tmp_enable_i : std_logic;
signal tmp_valid_o : std_logic;
signal tmp_data_o : std_logic_vector (7 downto 0);

begin

tmp_clk_i <= std_logic(clk_i);

tmp_rstn_i <= std_logic(rstn_i);

tmp_enable_i <= std_logic(enable_i);

valid_o <= std_ulogic(tmp_valid_o);

data_o <= to_stdulogicvector(tmp_data_o);



u1:   neoTRNG port map (
		clk_i => tmp_clk_i,
		rstn_i => tmp_rstn_i,
		enable_i => tmp_enable_i,
		valid_o => tmp_valid_o,
		data_o => tmp_data_o
       );
end neotrng_rtl;
