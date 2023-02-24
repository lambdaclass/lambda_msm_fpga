library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- NOTA: Esta FSM solamente puede manejar el caso en el que todas las fifos tienen un solo 
--       elemento. La logica para vaciar una fifo completa todavia no esta resuelta.

entity FSM_L1_FIFOs is
        generic(
                       K : natural := 5;
                       FIFO_WRITE_DEPTH : natural := 16
               );
        port(
                -------------------
                -- INPUT SIGNALS --
                -------------------
                clk, rst        : in std_logic;
                counter_done    : in std_logic;

                -- Outputs from FIFO BANK
                fifos_empty     : in std_logic_vector(K - 1 downto 0);

                --------------------
                -- OUTPUT SIGNALS --
                --------------------
                fs_read_en      : out std_logic_vector(K - 1 downto 0);
                fs_state        : out std_logic
            );
end FSM_L1_FIFOs;

architecture Structural of FSM_L1_FIFOs is
        type loop_state is (s0_idle, s3_flushOnce);
        signal state_reg, state_next : loop_state;

        signal someoneFull : std_logic;
        signal allWithElement : std_logic;
begin

        allWithElement <= and (not fifos_empty);

        process(clk, rst, counter_done)
        begin
                if (clk'event and clk = '1' and counter_done = '1') then
                        fs_state <= allWithElement;
                else
                        fs_state <= fs_state;
                end if;
        end process;

        process(clk, rst)
        begin
                if (rst = '1') then
                        state_reg <= s0_idle;
                elsif (clk'event and clk='1') then
                        state_reg <= state_next;
                end if;
        end process;

        process(state_reg, allWithElement)
        begin
                state_next <= state_reg;

                case state_reg is
                        when s0_idle =>
                                state_next <= s3_flushOnce when allWithElement= '1' else
                                              s0_idle;
                        when s3_flushOnce =>
                                state_next <= s0_idle;
                end case;
        end process;

        process(state_reg)
        begin
                fs_read_en <= (others => '0');

                case state_reg is
                        when s0_idle =>
                        when s3_flushOnce =>
                                fs_read_en <= (others => '1');

                end case;
        end process;

end Structural;
