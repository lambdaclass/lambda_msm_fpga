library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_L1_busIn is
        generic(K : natural := 5);
        port(
                -------------------
                -- INPUT SIGNALS --
                -------------------
                clk, rst        : in std_logic;
                start           : in std_logic;

                --------------------
                -- OUTPUT SIGNALS --
                --------------------
                scalar_out      : out std_logic;  -- For the FSM-dispatch
                new_processing  : out std_logic;  -- For the counter
                mem_enable_in   : out std_logic_vector(K - 1 downto 0)
            );
end FSM_L1_busIn;

architecture Structural of FSM_L1_busIn is
        type loop_state is (s0_idle, s1_busIn);
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

        process(state_reg, start)
        begin
                state_next <= state_reg;

                case state_reg is
                        when s0_idle =>
                                state_next <= s1_busIn when start = '1' else
                                              s0_idle;
                        when s1_busIn =>
                                state_next <= s0_idle;
                end case;
        end process;

        process(state_reg)
        begin
                new_processing <= '0';
                scalar_out <= '0';
                mem_enable_in <= (others => '0');

                case state_reg is
                        when s0_idle =>
                        when s1_busIn =>
                                scalar_out <= '1';
                                mem_enable_in <= (others => '1');
                                new_processing <= '1';
                end case;
        end process;

end Structural;
