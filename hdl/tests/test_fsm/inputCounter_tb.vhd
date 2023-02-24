library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inputCounter_tb is
end inputCounter_tb;

architecture tb of inputCounter_tb is
        constant CLK_PERIOD : time := 2ns;
        constant K : natural := 5;
        constant number_points : natural := 50000;

        signal clk : std_logic;
        signal rst : std_logic;

        signal count_signal : std_logic;
        signal processing_done_signal : std_logic;

begin

        UUT : entity work.FSM_L1_inputCounter
                generic map(N => 100)
                port map(
                        clk => clk,
                        rst => rst,

                        count => count_signal,
                        processing_done => processing_done_signal
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
                count_signal <= '0';
                
                wait for CLK_PERIOD;

                rst <= '0';
                count_signal <= '0';
                for i in 1 to number_points loop
                        count_signal <= '1';
                        wait for CLK_PERIOD;
                        count_signal <= '0';
                        wait for CLK_PERIOD;
                end loop;


        end process;


end tb;
