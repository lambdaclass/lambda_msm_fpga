library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_tb is
end counter_tb;

architecture tb of counter_tb is

        constant CLK_PERIOD : time := 2ns;
        constant K : natural := 10;

        signal clk : std_logic;
        signal rst : std_logic;

        signal start_count : std_logic;

        signal outValue : std_logic_vector(K - 1 downto 0) := (others => '0');

begin


        UUT : entity work.FSM_w_counter
                generic map(K => K)
                port map(
                        clk => clk,
                        rst => rst,

                        in_count => start_count,

                        out_count => outvalue
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
                rst <= '1';
                start_count<= '0';
                wait for CLK_PERIOD;

                rst <= '0';

                wait for 5*CLK_PERIOD;

                start_count <= '1';

                wait for 15*CLK_PERIOD;

                start_count <= '0';

                wait for 5*CLK_PERIOD;
        end process;



end tb;
