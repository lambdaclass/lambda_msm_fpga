library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config.all;
use work.pipeline_cfg.all;
use work.funciones.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity mod_mul_pip is
    port (
        clk : in std_logic;
        rst : in std_logic;
        a   : in std_logic_vector(N_vect-1 downto 0);
        b   : in std_logic_vector(N_vect-1 downto 0);
        r   : out std_logic_vector(N_vect-1 downto 0) 
    );
    constant DELAY : NATURAL := MODMUL_DELAY;
end entity;

architecture full_pipelined of mod_mul_pip is

begin
        MOD_MUL: entity work.mod_mul
        generic map(
            PIPELINED => "YES"
            )
        port map (
            clk => clk,
            rst => rst,
            a   => a,
            b   => b,
            r   => r
            );

end architecture;
