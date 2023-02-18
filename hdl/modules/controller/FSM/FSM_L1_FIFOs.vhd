library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_L1_FIFOs is
        generic(K : natural := 5);
        port(
                -------------------
                -- INPUT SIGNALS --
                -------------------
                clk, rst        : in std_logic;
                flush_sig       : in std_logic;

                --------------------
                -- OUTPUT SIGNALS --
                --------------------
                fs_read_en      : out std_logic_vector(K - 1 downto 0)
            );
end FSM_L1_FIFOs;

architecture Structural of FSM_L1_FIFOs is
        type loop_state is (s0_idle, s3_flush);
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

        process(state_reg, flush_sig)
        begin
                state_next <= state_reg;

                case state_reg is
                        when s0_idle =>
                                state_next <= s3_flush when flush_sig = '1' else
                                              s0_idle;
                        when s3_flush =>
                                state_next <= s0_idle;
                end case;
        end process;

        process(state_reg)
        begin
                fs_read_en <= (others => '0');

                case state_reg is
                        when s0_idle =>
                        when s3_flush =>
                                fs_read_en <= (others => '1');
                end case;
        end process;
        

end Structural;
