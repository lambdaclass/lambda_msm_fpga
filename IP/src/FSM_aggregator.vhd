library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_aggregator is
        port ( 
                clk, rst                : in std_logic;

                aggregation_start       : in std_logic;

                window_done             : in std_logic;
                segment_done            : in std_logic;
                elements_done           : in std_logic;
                log_done                : in std_logic;
                padd_datavalid          : in std_logic;
                m_zero                  : in std_logic;
                m_twoBefore             : in std_logic;

                addr_A_read_out         : out std_logic_vector(1 downto 0);
                addr_B_read_out         : out std_logic_vector(2 downto 0);

                codification_padd       : out std_logic_vector(1 downto 0);
                k_next                  : out std_logic;
                u_next                  : out std_logic;
                m_next                  : out std_logic;
                log_next                : out std_logic;

                op_selector_B           : out std_logic_vector(1 downto 0)
);
end FSM_aggregator;

architecture Structural of FSM_aggregator is
        
        type padd_input is (BI, BM, BF, MM);
        type states_loop is (idle, readMM, readMB, change_segment, change_element, newLoop, read_skmsk, read_gkmgk, sum_M, read_skmb, read_sklog, read_wait, read_gs, endState);
        signal state_next, state_reg : states_loop;
        signal padd_access : padd_input;

begin

        process(clk, rst)
        begin
                if (rst = '1') then
                        state_reg <= readMM;
                elsif (clk'event and clk='1') then
                        state_reg <= state_next;
                end if;
        end process;
        
        process(state_reg, window_done, segment_done, elements_done, aggregation_start, m_zero, m_twoBefore, log_done, padd_datavalid)
        begin
                state_next <= state_reg;

                case state_reg is
                        when idle =>
                                state_next <= readMM when aggregation_start = '1' else
                                              idle;
                        when readMM =>
                                state_next <= readMB when window_done = '1' else
                                              readMM;
                        when readMB =>
                                state_next <= change_segment when window_done = '1' else
                                              readMB;
                        when change_segment =>
                                state_next <= readMM when segment_done = '1' else
                                              change_element;
                        when change_element =>
                                state_next <= newLoop when elements_done = '1' else
                                              readMM;
                        when newLoop =>
                                state_next <= read_skmsk;
                        when read_skmsk => 
                                state_next <= read_gkmgk when m_zero = '1' else
                                              sum_M;
                        when read_gkmgk =>
                                state_next <= read_sklog when segment_done = '1' else
                                              sum_M when m_zero = '1' else
                                              read_skmsk;
                        when sum_M      =>
                                state_next <= read_gkmgk when m_twoBefore = '1' else
                                              read_skmb when m_zero = '1' else
                                              read_skmsk;
                        when read_skmb =>
                                state_next <= read_gkmgk when window_done = '1' else
                                              read_skmb;
                        when read_sklog =>
                                state_next <= read_wait when window_done = '1' else
                                              read_gs when log_done = '1' else
                                              read_sklog;
                        when read_wait =>
                                state_next <= read_sklog when padd_datavalid = '0' else
                                              read_wait;
                        when read_gs    => 
                                state_next <= endState when window_done = '1' else
                                              read_gs;
                        when endState   =>
                                state_next <= state_reg;

                end case;
        end process;


        process(state_reg)
        begin
                codification_padd <= "00";

                m_next          <= '0';
                u_next          <= '0';
                k_next          <= '0';
                log_next        <= '0';

                addr_A_read_out <= "00";
                addr_B_read_out <= "000";

                op_selector_B   <= "00";

                case state_reg is
                        when idle =>
                        when readMM =>
                                addr_A_read_out <= "01";
                                addr_B_read_out <= "010";

                                op_selector_B <= "01";
                                codification_padd <= "10";
                                k_next <= '1';
                        when readMB =>
                                addr_A_read_out <= "11";
                                addr_B_read_out <= "000";

                                op_selector_B <= "11";
                                codification_padd <= "01";
                                k_next <= '1';
                        when change_segment =>
                                m_next <= '1';
                        when change_element =>
                                u_next <= '1';
                        when newLoop =>
                        when read_skmsk =>
                                addr_A_read_out <= "10";
                                addr_B_read_out <= "010";

                                op_selector_B <= "01";
                                codification_padd <= "10";
                                k_next <= '1';
                        when read_gkmgk => 
                                addr_A_read_out <= "00";
                                addr_B_read_out <= "100";

                                op_selector_B <= "01";
                                codification_padd <= "10";
                                k_next <= '1';
                        when sum_M =>
                                m_next <= '1';
                        when read_skmb =>
                                addr_A_read_out <= "11";
                                addr_B_read_out <= "011";

                                op_selector_B <= "01";
                        when read_sklog =>
                                addr_A_read_out <= "10";
                                addr_B_read_out <= "001";

                                op_selector_B <= "01";
                                codification_padd <= "10";
                                k_next <= '1';
                        when read_wait =>
                                log_next <= '1';
                        when read_gs =>
                                addr_A_read_out <= "00";
                                addr_B_read_out <= "001";

                                op_selector_B <= "01";
                                codification_padd <= "10";
                                k_next <= '1';
                        when endState =>
                end case;
        end process;

end Structural;
