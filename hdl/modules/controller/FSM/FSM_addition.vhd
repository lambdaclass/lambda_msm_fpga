
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_addition is
        generic(K : natural := 5;
                FIFO_WRITE_SIZE : natural := 16);
        port( 
                -----------------------
                -------- INPUT --------
                -----------------------
                clk, rst                : in std_logic;

                bucket_read             : in std_logic;
                bucket_empty_bit        : in std_logic;
                bucket_busy_bit         : in std_logic;
                
                fifo_k_empty_bit        : in std_logic;
                fifo_anyFull_bit        : in std_logic;
                fifo_allWelem_bit       : in std_logic;
                
                window_done             : in std_logic;
                fifo_size_done          : in std_logic;
                input_done              : in std_logic;
                
                ------------------------
                -------- OUTPUT --------
                ------------------------
                k_next                  : out std_logic;
                fifo_we                 : out std_logic;
                fifo_re                 : out std_logic;
                fifo_next               : out std_logic;

                empty_bit_out           : out std_logic;
                busy_bit_out            : out std_logic;
                bucket_web              : out std_logic;
                
                padd_status_out         : out std_logic_vector(3 downto 0);
                point_select            : out std_logic;
                point_next              : out std_logic;
                loop2_start             : out std_logic;

                data_A_select           : out std_logic_vector(1 downto 0);
                data_B_select           : out std_logic_vector(2 downto 0)
            );
end FSM_addition;

architecture Structural of FSM_addition is
        
        type states_loop is (s0_idle, s0a_read_input, s1_dispatch, s1_dispatch_next, s2_full_flush, s2_delay, s2_one_flush, s3_done);
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

        process(state_reg, bucket_read, window_done, input_done, fifo_anyFull_bit, fifo_allWelem_bit, fifo_size_done)
        begin
                state_next <= state_reg;

                case state_reg is
                        when s0_idle =>
                                state_next <= s0a_read_input when bucket_read = '1' else
                                              s0_idle;
                        when s0a_read_input=>
                                state_next <= s1_dispatch;
                        when s1_dispatch =>
                                state_next <= s1_dispatch_next when window_done = '1' else
                                              s1_dispatch;

                        when s1_dispatch_next => 
                                state_next <= s2_full_flush when fifo_anyFull_bit = '1' else
                                              s2_one_flush when fifo_allWelem_bit = '1' else
                                              s2_delay when input_done = '1' else
                                              s1_dispatch;

                        when s2_full_flush => -- (Revisar este estado)
                                state_next <= s0_idle when fifo_size_done = '1' or (not fifo_allWelem_bit) = '1' else
                                              s2_full_flush;
                        when s2_delay =>
                                state_next <= s2_one_flush;
                        when s2_one_flush =>
                                state_next <= s0_idle when window_done = '1' else
                                              s2_one_flush;
                        when s3_done =>
                                state_next <= s0_idle;
                end case;
        end process;

        process(state_reg, bucket_empty_bit, bucket_busy_bit, fifo_k_empty_bit, fifo_anyFull_bit, fifo_allWelem_bit, window_done)
        begin
                fifo_we         <= '0';
                fifo_re         <= '0';
                fifo_next       <= '0';

                empty_bit_out   <= '0';
                busy_bit_out    <= '0';
                bucket_web      <= '0';

                padd_status_out  <= "0000";
                point_next      <= '0';
                point_select    <= '0';
                loop2_start     <= '0';

                data_A_select   <= "00";   -- By default it chooses the input point.
                data_B_select   <= "000";  -- By default it chooses the input point.

                k_next          <= '0';

                case state_reg is 
                        when s0_idle            => 
                        when s0a_read_input     => 
                                point_next <= '1';
                                k_next          <= '1';
                        when s1_dispatch        =>
                                if bucket_busy_bit = '1' then
                                        fifo_we         <= '1';

                                elsif bucket_empty_bit = '0' then
                                        empty_bit_out   <= '1';
                                        bucket_web      <= '1';

                                else
                                        data_A_select <= "00";
                                        data_B_select <= "100";

                                        busy_bit_out    <= '1';
                                        bucket_web      <= '1'; 
                                        padd_status_out  <= "1100";
                                end if;
                                k_next          <= '1';
                        when s1_dispatch_next   =>
                                if fifo_anyFull_bit = '1' then
                                        fifo_re <= '1';
                                elsif fifo_allWelem_bit = '1' then
                                        fifo_re <= '1';
                                else
                                        point_next <= '1';
                                end if;
                                k_next          <= '1';

                        when s2_full_flush      =>
                                if fifo_k_empty_bit = '0' then
                                        if bucket_busy_bit = '1' then
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
                                k_next          <= '1';
                        when s2_delay           =>
                        when s2_one_flush       =>
                                if fifo_k_empty_bit = '0' then
                                        if bucket_busy_bit = '1' then
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
                                k_next          <= '1';
                        when s3_done    =>
                                loop2_start <= '1';
                end case;
        end process;

end Structural;
