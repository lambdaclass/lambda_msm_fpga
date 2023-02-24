library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_L1_waitState is
        port(
                -------------------
                -- INPUT SIGNALS --
                -------------------
                clk, rst        : in std_logic;
                start_wait      : in std_logic;
                empty_padd      : in std_logic;

                --------------------
                -- OUTPUT SIGNALS --
                --------------------
                done_L1      : out std_logic
            );
end FSM_L1_waitState;

architecture Structural of FSM_L1_waitState is
        type loop_state is (s0_idle, s4_waitState);
        signal state_reg, state_next : loop_state;
begin

        process(clk, rst)
        begin
                if (rst = '1') then
                        state_reg <= s0_idle;
                elsif (clk'event and clk='1') then
                        state_reg <= state_next;
                end if;
        end process;

        process(state_reg, start_wait, empty_padd)
        begin
                state_next <= state_reg;

                case state_reg is
                        when s0_idle =>
                                state_next <= s4_waitState when start_wait = '1' else
                                              s0_idle;
                        when s4_waitState =>
                                state_next <= s0_idle when empty_padd = '1' else
                                              s4_waitState;
                end case;
        end process;

        process(state_reg, empty_padd)
        begin
                done_L1 <= '0';

                case state_reg is
                        when s0_idle =>
                        when s4_waitState =>
                                if empty_padd = '1' then
                                        done_L1 <= '1';
                                else
                                        done_L1 <= '0';
                                end if;
                end case;
        end process;

end Structural;
