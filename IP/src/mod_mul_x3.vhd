library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Defines N (number of bits) and q prime: 
use work.config.all;

entity mod_mul_x3 is
    port (
        clk : in std_logic;
        rst : in std_logic;
        
        x : in std_logic_vector (N_vect-1 downto 0);
        r : out std_logic_vector(N_vect-1 downto 0)
    );
end entity;

architecture modadders of mod_mul_x3 is

    signal x2: std_logic_vector(N_vect-1 downto 0);
    signal x_d: std_logic_vector(N_vect-1 downto 0);


begin
    
    U1_modadd: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => x,
        y => x,
        op => '0',
        result => x2
    );

    UDX: entity work.delay_1
    generic map(
        WORD_WIDTH => N_vect
    )
    port map(
        clk       => clk,
        rst       => rst,
        s         => x,
        s_delayed => x_d
    );

    U2_modadd: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => x_d,
        y => x2,
        op => '0',
        result => r
    );    


end architecture;
