library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity waitState_tb is
end waitState_tb;

architecture tb of waitState_tb is
        constant CLK_PERIOD : time := 2ns;

        signal clk : std_logic;
        signal rst : std_logic;

        signal start_wait_signal : std_logic;
        signal padd_signal       : std_logic;
        signal done_signal       : std_logic;
        
begin

        UUT : entity work.FSM_L1_waitState
                port map(
                        clk => clk,
                        rst => rst,

                        start_wait => start_wait_signal,
                        padd_empty => padd_signal,

                        done_process => done_signal
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

                start_wait_signal <= '0';
                padd_signal       <= '0';

                wait for CLK_PERIOD;

                start_wait_signal <= '0';
                padd_signal       <= '1';

                wait for CLK_PERIOD;

                start_wait_signal <= '1';
                padd_signal       <= '0';

                wait for CLK_PERIOD;

                start_wait_signal <= '1';
                padd_signal       <= '1';

                wait for CLK_PERIOD;
        end process;



end tb;
