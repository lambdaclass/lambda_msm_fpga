library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config.all;
use work.funciones.all;

entity mod_mul_comb is
    port (
        a   : in std_logic_vector(N-1 downto 0);
        b   : in std_logic_vector(N-1 downto 0);
        r   : out std_logic_vector(N-1 downto 0) 
    );
end entity;

architecture combinational of mod_mul_comb is

begin
        MOD_MUL: entity work.mod_mul
        generic map(
            PIPELINED => "NO"
            )
        port map (
            clk => '0',
            rst => '0',
            a   => a,
            b   => b,
            r   => r
            );

end architecture;
