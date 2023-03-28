-- kara_mul.vhd
-- VHDL 2008 file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config.all;
use work.funciones.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity kara_mul_pip is
    port (
        clk : in std_logic;
        rst : in std_logic;
        x   : in std_logic_vector(N_vect-1 downto 0);
        y   : in std_logic_vector(N_vect-1 downto 0);
        z   : out std_logic_vector(2*N_vect - 1 downto 0) 
    );
end entity;

architecture full_pipelined of kara_mul_pip is

begin
        KARA_MUL: entity work.kara_mul(full_pipelined)
        generic map(
            N => 377,
            K => get_partition(377),
            D => 5,
            L => 1 
            )
        port map (
            clk => clk,
            rst => rst,
            x   => x,
            y   => y,
            z   => z
            );

end architecture;
