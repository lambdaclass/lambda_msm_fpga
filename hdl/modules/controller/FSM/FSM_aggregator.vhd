library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_aggregator is
        port ( 
                clk, rst                : in std_logic;

                aggregation_start       : in std_logic;

                window_done             : in std_logic;
                segment_done            : in std_logic;
                elements_done           : in std_logic;
                log_done                : in std_logic;
                padd_datavalid          : in std_logic;

                addr_A_read_out         : out std_logic_vector(1 downto 0);
                addr_B_read_out         : out std_logic_vector(2 downto 0);

                data_A_select           : out std_logic_vector(1 downto 0);
                data_B_select           : out std_logic_vector(1 downto 0);

                k_next                  : out std_logic;
                u_next                  : out std_logic;
                m_next                  : out std_logic;
                log_next                : out std_logic;

                -- Tiene los 4 bits de control. Los 3 menos signif corresponden a las escrituras en cada componente de memoria. 
                -- El mas significativo es un data valid.
                padd_status_out         : out std_logic_vector(3 downto 0)
);
end FSM_aggregator;

architecture Structural of FSM_aggregator is

        type pa_op1_input is (G_K, G_KM, S_K, S_KM);
        type pa_op2_input is (BUCKET, S_K, S_KM, S_KM_MINUS, G_KM);

        type states_loop is (idle, read_gs_km, read_seg_bucket, change_segment, change_element, change_to_acc, read_skskm, read_gkgkm, change_segment_b, read_skmb, read_sklog, read_wait, read_gs, wait_for_padd, endState);
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
        
        process(state_reg, window_done, segment_done, elements_done, aggregation_start, log_done, padd_datavalid)
        begin
                state_next <= state_reg;

                case state_reg is
                        when idle =>
                                state_next <= read_gs_km when aggregation_start = '1' else
                                              idle;
                        when read_gs_km =>
                                state_next <= read_seg_bucket when window_done = '1' else
                                              read_gs_km;
                        when read_seg_bucket =>
                                state_next <= change_segment when window_done = '1' else
                                              read_seg_bucket;
                        when change_segment =>
                                state_next <= change_element when segment_done = '1' else
                                              read_gs_km;
                        when change_element =>
                                state_next <= change_to_acc when elements_done = '1' else
                                              read_gs_km;
                        when change_to_acc =>
                                state_next <= read_skskm;
                        when read_skskm => 
                                state_next <= read_gkgkm when window_done = '1' else
                                              -- Me falta un OR en esta parte
                                              read_skskm;
                        when read_gkgkm =>
                                state_next <= change_segment_b when window_done = '1' else
                                              read_gkgkm;
                        when change_segment_b =>
                                state_next <= read_sklog when segment_done = '1' else
                                              read_skmb;
                        when read_skmb =>
                                state_next <= read_skskm when window_done = '1' else
                                              read_skmb;
                        when read_sklog =>
                                state_next <= read_wait when window_done = '1' else
                                              read_gs when log_done = '1' else
                                              read_sklog;
                        when read_wait =>
                                state_next <= read_sklog when padd_datavalid = '0' else
                                              read_wait;
                        when read_gs    => 
                                state_next <= wait_for_padd when window_done = '1' else
                                              read_gs;
                        when wait_for_padd =>
                                state_next <= endState when padd_datavalid = '0' else
                                              wait_for_padd;
                        when endState   =>
                                state_next <= state_reg;

                end case;
        end process;


        process(state_reg, window_done)
        begin

                m_next          <= '0';
                u_next          <= '0';
                k_next          <= '0';
                log_next        <= '0';

                addr_A_read_out <= (others => '0');
                addr_B_read_out <= (others => '0');

                padd_status_out <= (others => '0');

                case state_reg is
                        when idle =>
                        when read_gs_km =>
                                addr_A_read_out <= std_logic_vector(to_unsigned(pa_op1_input'POS(G_K), addr_A_read_out'length));
                                addr_B_read_out <= std_logic_vector(to_unsigned(pa_op2_input'POS(S_KM), addr_B_read_out'length));

                                data_A_select <= "10";
                                data_B_select <= "01";

                                k_next <= '1';
                                -- Escribo en aux
                                padd_status_out <= "1001";
                        when read_seg_bucket =>
                                addr_A_read_out <= std_logic_vector(to_unsigned(pa_op1_input'POS(S_KM), addr_A_read_out'length));
                                addr_B_read_out <= std_logic_vector(to_unsigned(pa_op2_input'POS(BUCKET), addr_B_read_out'length));

                                data_A_select <= "01";
                                data_B_select <= "00";

                                k_next <= '1';
                                -- Escribo en aux y segmento
                                padd_status_out <= "1011";
                        when change_segment =>
                                m_next <= '1';
                        when change_element =>
                                u_next <= '1';
                        when change_to_acc =>
                        when read_skskm =>
                                addr_A_read_out <= std_logic_vector(to_unsigned(pa_op1_input'POS(S_K), addr_A_read_out'length));
                                addr_B_read_out <= std_logic_vector(to_unsigned(pa_op2_input'POS(S_KM), addr_B_read_out'length));

                                data_A_select <= "01";
                                data_B_select <= "10";

                                k_next <= '1';
                                -- Escribo en bucket y segmento
                                padd_status_out <= "1110";
                        when read_gkgkm => 
                                addr_A_read_out <= std_logic_vector(to_unsigned(pa_op1_input'POS(G_K), addr_A_read_out'length));
                                addr_B_read_out <= std_logic_vector(to_unsigned(pa_op2_input'POS(G_KM), addr_B_read_out'length));

                                data_A_select <= "00";
                                data_B_select <= "10";

                                k_next <= '1';
                                -- Escribo en bucket 
                                padd_status_out <= "1101";
                        when change_segment_b =>
                                m_next <= '1';
                        when read_skmb =>
                                addr_A_read_out <= std_logic_vector(to_unsigned(pa_op1_input'POS(S_KM), addr_A_read_out'length));
                                addr_B_read_out <= std_logic_vector(to_unsigned(pa_op2_input'POS(S_KM_MINUS), addr_B_read_out'length));

                                data_A_select <= "01";
                                data_B_select <= "10";

                                k_next <= '1';
                                -- Escribo en aux y segmento
                                padd_status_out <= "1011";
                        when read_sklog =>
                                addr_A_read_out <= std_logic_vector(to_unsigned(pa_op1_input'POS(S_K), addr_A_read_out'length));
                                addr_B_read_out <= std_logic_vector(to_unsigned(pa_op2_input'POS(S_K), addr_B_read_out'length));

                                data_A_select <= "01";
                                data_B_select <= "00";

                                k_next <= '1';
                                -- Escribo en bucket y segmento
                                padd_status_out <= "1110";
                                if window_done = '1' then
                                        log_next <=  '1';
                                else
                                        log_next <=  '0';
                                end if;
                        when read_wait =>
                        when read_gs =>
                                addr_A_read_out <= std_logic_vector(to_unsigned(pa_op1_input'POS(G_K), addr_A_read_out'length));
                                addr_B_read_out <= std_logic_vector(to_unsigned(pa_op2_input'POS(S_K), addr_B_read_out'length));

                                data_A_select <= "00";
                                data_B_select <= "01";

                                k_next <= '1';
                                -- Escribo en bucket
                                padd_status_out <= "1100";
                        when wait_for_padd =>
                        when endState =>
                end case;
        end process;

end Structural;
