library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity busIn_tb is
end busIn_tb;

architecture tb of busIn_tb is

        constant CLK_PERIOD : time := 2ns;
        constant K : natural := 5;

        signal clk : std_logic;
        signal rst : std_logic;

        signal start_A, start_B : std_logic;
        signal scalar_out : std_logic;
        signal mem_enable : std_logic_vector(K - 1 downto 0);
        signal new_processing: std_logic;
begin

        UUT : entity work.FSM_L1_busIn
                port map(
                        clk => clk,
                        rst => rst,

                        start_A => start_A,
                        start_B => start_B,

                        scalar_out => scalar_out,
                        mem_enable_in => mem_enable,
                        new_processing => new_processing
                );

        CLK_PROCESS: process
        begin
                clk <= '1';
                wait for CLK_PERIOD/2;
                clk <= '0';
                wait for CLK_PERIOD/2;
        end process;

        IN_PROCESS : process
        begin
                rst <= '0';
                start_A <= '0';
                start_B <= '0';

                wait for CLK_PERIOD;

                start_A <= '1';
                start_B <= '0';

                wait for CLK_PERIOD;

                start_A <= '0';
                start_B <= '1';

                wait for CLK_PERIOD;

                start_A <= '1';
                start_B <= '1';

                wait for CLK_PERIOD;
        end process;


end tb;
