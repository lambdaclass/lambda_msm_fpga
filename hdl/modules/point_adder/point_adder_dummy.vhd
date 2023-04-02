library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config.all;
use work.pipeline_cfg.all;
use work.funciones.all;

--library UNISIM;
--use UNISIM.VComponents.all;

entity point_adder_pip is
    port (
        clk             : in std_logic;
        rst             : in std_logic;

        -- P1
        x1              : in std_logic_vector (N_vect-1 downto 0);
        y1              : in std_logic_vector (N_vect-1 downto 0);
        z1              : in std_logic_vector (N_vect-1 downto 0); 
        -- P2 
        x2              : in std_logic_vector (N_vect-1 downto 0);
        y2              : in std_logic_vector (N_vect-1 downto 0);
        z2              : in std_logic_vector (N_vect-1 downto 0);
        -- R
        xr              : out std_logic_vector (N_vect-1 downto 0);
        yr              : out std_logic_vector (N_vect-1 downto 0);
        zr              : out std_logic_vector (N_vect-1 downto 0)
    );
    constant DELAY : NATURAL := POINT_ADDER_DELAY;
end entity;

architecture dummy of point_adder_pip is

    signal xr_int, yr_int, zr_int: std_logic_vector(N_vect-1 downto 0);


begin
    
    -- dummy ops
    xr_int <= std_logic_vector(unsigned(x1) + unsigned(x2));
    yr_int <= std_logic_vector(unsigned(y1) + unsigned(y2));
    zr_int <= std_logic_vector(unsigned(z1) + unsigned(z2));


    xr_delay: entity work.delay_M
        generic map(
            WORD_WIDTH => N_vect,
            DELAY      => DELAY
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => xr_int,
            s_delayed => xr
        );

    yr_delay: entity work.delay_M
        generic map(
            WORD_WIDTH => N_vect,
            DELAY      => DELAY
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => yr_int,
            s_delayed => yr
        );

    zr_delay: entity work.delay_M
        generic map(
            WORD_WIDTH => N_vect,
            DELAY      => DELAY
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => zr_int,
            s_delayed => zr
        );

end architecture;
