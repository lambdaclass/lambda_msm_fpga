library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.tipos.ALL;
use work.funciones.ALL;
use work.config.ALL;

entity FSM_addition is
        generic (K : natural := 5);
        port ( 
                -----------------------
                -------- INPUT --------
                -----------------------
                clk, rst                : in std_logic;

                bucket_read             : in std_logic;
                bucket_status           : in bucket_status;
                fifo_bank_status        : in fifo_bank_status;
                
                -- Separo desde el FSM top module.
                -- L1_counter_status
                window_done             : in std_logic;
                fifo_done               : in std_logic;
                input_done              : in std_logic;
                padd_done               : in std_logic;
                -- Me falta un counter mas
                
                ------------------------
                -------- OUTPUT --------
                ------------------------

                -- Seniales para contar. Las junto fuera del FSM top module
                w_count                 : out std_logic;
                fifo_next               : out std_logic;
                point_next              : out std_logic;
                point_select            : out std_logic;

                -- A priori serian un fifo_bank_in. Pero tengo el drama del data_in.
                fifo_we                 : out std_logic;
                fifo_re                 : out std_logic;

                -- Tengo que conectarlos al din de memory_in_t 
                empty_bit_out           : out std_logic;
                busy_bit_out            : out std_logic;

                -- Tengo que conectarlo al we de memory_in_t (Aunque tengo el mux de afuera... No?)
                bucket_web              : out std_logic;
                
                padd_status_out         : out padd_status;
                loop2_start             : out std_logic;

                data_A_select           : out std_logic_vector(1 downto 0);
                data_B_select           : out std_logic_vector(2 downto 0)
            );
end FSM_addition;

architecture Structural of FSM_addition is
        
        type states_loop is (s0_idle, s0a_read_input, s1_dispatch, s1_dispatch_next, s2_window, s2_full_flush, s2_delay, s2_one_flush, s3_done);
        signal state_next, state_reg : states_loop;

begin

        process(clk, rst)
        begin
                if (rst = '1') then
                        state_reg <= s0_idle;
                elsif (clk'event and clk='1') then
                        state_reg <= state_next;
                end if;
        end process;

        process(state_reg, bucket_read, window_done, input_done, fifo_bank_status, fifo_done)
        begin
                state_next <= state_reg;

                case state_reg is
                        when s0_idle =>
                                state_next <= s0a_read_input when bucket_read = '1' else
                                              s0_idle;
                        when s0a_read_input=>
                                state_next <= s1_dispatch;
                        when s1_dispatch =>
                                state_next <= s2_window;
                        when s2_window => 
                                state_next <= s1_dispatch_next when window_done = '1' else
                                                s1_dispatch;
                        when s1_dispatch_next => 
                                state_next <= s2_full_flush when fifo_bank_status.fb_anyFull = '1' else
                                              s2_one_flush  when fifo_bank_status.fb_allWithElem   = '1' else
                                              s2_delay when input_done = '1' else
                                              s1_dispatch;

                        when s2_full_flush => -- (Revisar este estado)
                                state_next <= s0_idle when fifo_done = '1' or (not fifo_bank_status.fb_allWithElem) = '1' else
                                              s2_full_flush;
                        when s2_delay =>
                                state_next <= s3_done when padd_done = '1' else
                                              s2_delay;
                        when s2_one_flush =>
                                state_next <= s0_idle when window_done = '1' else
                                              s2_one_flush;
                        when s3_done =>
                                state_next <= s0_idle;
                end case;
        end process;

        process(state_reg, bucket_status, fifo_bank_status, window_done)
        begin
                fifo_we         <= '0';
                fifo_re         <= '0';
                fifo_next       <= '0';

                empty_bit_out   <= '0';
                busy_bit_out    <= '0';
                bucket_web      <= '0';

                padd_status_out  <= ('0', '0', '0', '0');
                point_next      <= '0';
                point_select    <= '0';
                loop2_start     <= '0';

                data_A_select   <= "00";   -- By default it chooses the input point.
                data_B_select   <= "000";  -- By default it chooses the input point.

                w_count          <= '0';

                case state_reg is 
                        when s0_idle            => 
                        when s0a_read_input     => 
                                point_next <= '1';
                                point_select <= '1';
                        when s1_dispatch        =>
                                if bucket_status.busy_o = '1' then
                                        fifo_we         <= '1';
                                elsif bucket_status.empty_o = '0' then
                                        empty_bit_out   <= '1';
                                        bucket_web      <= '1';

                                else
                                        data_A_select <= "00";
                                        data_B_select <= "100";

                                        busy_bit_out    <= '1';
                                        bucket_web      <= '1'; 
                                        padd_status_out  <= ('1', '1', '0', '0');
                                end if;
                        when s2_window =>
                                if window_done = '1' then 
                                        w_count <= '0';
                                else 
                                        w_count <= '1';
                                end if;
                        when s1_dispatch_next   =>
                                if fifo_bank_status.fb_anyFull = '1' then
                                        fifo_re <= '1';
                                elsif fifo_bank_status.fb_allWithElem = '1' then
                                        fifo_re <= '1';
                                else
                                        point_next <= '1';
                                        point_select <= '1';
                                end if;
                                w_count          <= '1';

                        when s2_full_flush      =>
                                w_count          <= '1';
                                if fifo_bank_status.fb_empty = '0' then
                                        if bucket_status.busy_o = '1' then
                                                point_select    <= '1';
                                                fifo_we         <= '1';
                                                fifo_re         <= '1';
                                        else
                                                data_A_select   <= "00";
                                                data_B_select   <= "001";
                                                bucket_web      <= '1';
                                                busy_bit_out    <= '1';
                                                fifo_re         <= '1';
                                        end if;
                                else 
                                end if;
                        when s2_delay           =>
                        when s2_one_flush       =>
                                w_count          <= '1';
                                if fifo_bank_status.fb_empty = '0' then
                                        if bucket_status.busy_o = '1' then
                                                point_select    <= '1';
                                                fifo_we         <= '1';
                                        else
                                                data_A_select   <= "00";
                                                data_B_select   <= "001";
                                                bucket_web      <= '1';
                                                busy_bit_out    <= '1';
                                        end if;
                                else 
                                end if;
                        when s3_done    =>
                                loop2_start <= '1';
                end case;
        end process;

d Structural;
