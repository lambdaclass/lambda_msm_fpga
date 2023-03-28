library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--* @brief Global configuration parameters

package config is
  
       constant  N_vect : natural := 377;  -- Operands bit size for G_n
       constant  N_esc : natural := 253;  -- Operands bit size for x_n
       constant  c : natural := 12;
       constant  K : natural := 22;  --K windows     
       constant  DSP_SIZE : natural := 18;
       constant  q: unsigned(N_vect-1 downto 0) := '1' & x"ae3a4617c510eac63b05c06ca1493b1a22d9f300f5138f1ef3622fba094800170b5d44300000008508c00000000001";
       constant  GND : std_logic :=0;
end package;

package pipeline_cfg is
    constant KARAMUL_DELAY_PER_LEVEL : NATURAL := 5;
    constant KARAMUL_TREE_DEPTH      : NATURAL := 5;
    
    constant MODADD_DELAY : NATURAL := 1;
    constant MODMUL_DELAY : NATURAL := KARAMUL_DELAY_PER_LEVEL * KARAMUL_TREE_DEPTH;

    constant POINT_ADDER_DELAY : NATURAL := (MODMUL_DELAY + 2*MODADD_DELAY) + (MODMUL_DELAY + 3*MODADD_DELAY);
end package;
