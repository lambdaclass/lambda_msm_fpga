-- kara_mul.vhd
-- VHDL 2008 file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config.all;
use work.funciones.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity kara_mul_comb is
    port (
        x   : in std_logic_vector(N-1 downto 0);
        y   : in std_logic_vector(N-1 downto 0);
        z   : out std_logic_vector(2*N - 1 downto 0) 
    );
end entity;

architecture combinational of kara_mul_comb is

begin
        KARA_MUL: entity work.kara_mul(combinational)
        generic map(
            N => 377,
            K => get_partition(377),
            D => 5,
            L => 1 
            )
        port map (
            clk => '0',
            rst => '0',
            x   => x,
            y   => y,
            z   => z
            );

end architecture;
