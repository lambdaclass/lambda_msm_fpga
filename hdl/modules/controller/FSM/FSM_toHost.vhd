library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_toHost is
        port ( 
                clk, rst                : in std_logic;
                dispatch_start          : in std_logic;
                window_done             : in std_logic;

                k_next                  : out std_logic;
                output_fifo_we          : out std_logic;
                done                    : out std_logic
);
end FSM_toHost;

architecture Structural of FSM_toHost is

        type states_loop is (idle, dispatch, done_dispatch);
        signal state_next, state_reg : states_loop;

begin

        process(clk, rst)
        begin
                if (rst = '1') then
                        state_reg <= idle;
                elsif (clk'event and clk='1') then
                        state_reg <= state_next;
                end if;
        end process;
        
        process(state_reg, dispatch_start,  window_done)
        begin
                state_next <= state_reg;

                case state_reg is
                        when idle =>
                                state_next <= dispatch when dispatch_start = '1' else
                                              idle;
                        when dispatch =>
                                state_next <= done_dispatch when window_done = '1' else
                                              dispatch;
                        when done_dispatch =>
                                state_next <= state_reg;
                end case;
        end process;


        process(state_reg)
        begin

                k_next          <= '0';
                output_fifo_we  <= '0';
                done            <= '0';

                case state_reg is
                        when idle =>
                        when dispatch =>
                                k_next <= '1';
                                output_fifo_we <= '1';
                        when done_dispatch =>
                                done <= '1';
                end case;
        end process;

end Structural;
