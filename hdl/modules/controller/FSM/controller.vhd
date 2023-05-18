library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.funciones.ALL;
use work.config.ALL;
use work.tipos.ALL;

entity controller is
        generic (K : natural := 22;
                 U : natural := 512;
                 N : natural := 512;
                 M : natural := 8;
                 C : natural := 12);
        port ( 
                -----------------------
                -------- INPUT --------
                -----------------------
                clk, rst        : in std_logic;

                start_MSM       : in std_logic;
                data_valid_in   : in std_logic;
                bucket_kstatus  : in bucket_kstatus;

                fifo_bank_kempty: in std_logic_vector(K - 1 downto 0);
                fifo_empty_s    : in std_logic;
                fifo_full_s    : in std_logic;

                -- Todo esto es loop 2

                op_selector_A   : out padd_op_A;
                op_selector_B   : out padd_op_B;

                addr_selector_A : out address_A;
                addr_selector_B : out address_B;

                fifo_bank_we : out std_logic;
                fifo_bank_re : out std_logic;
                fifo_select  : out std_logic;
                
                bucket_status_o : out bucket_status;
                bucket_web_o    : out std_logic;

                counters_addr   : out counters;
                padd_status_out : out padd_status;

                input_next      : out std_logic;
                output_we       : out std_logic
             );
end controller;

architecture Structural of controller is

        signal in_count : count_signals;
        signal counters : counters;
        signal counter_status : counters_status;

        signal bucket_status : bucket_status;
        signal fifo_bank_status : fifo_bank_status;

        signal fifo_empty : std_logic;

        signal bucket_web_tmp : std_logic;

        signal start_L2 : std_logic;
        signal start_L3 : std_logic;
        signal MSM_done : std_logic;

        signal w_next_l1 : std_logic;
        signal w_next_l2 : std_logic;
        signal w_next_l3 : std_logic;

        signal data_A_select_L1 : padd_op_A;
        signal data_B_select_L1 : padd_op_B;
 
        signal data_A_select_L2 : padd_op_A;
        signal data_B_select_L2 : padd_op_B;

        signal loop_selection : std_logic_vector(1 downto 0);

        ----- Dudas ----- (ARREGLAR)
        signal addr_A_select_L1 : address_A := xn;
        signal addr_B_select_L1 : address_B := xn;
        ----- Dudas -----

        signal addr_A_select_L2 : address_A;
        signal addr_B_select_L2 : address_B;

        signal padd_status_l1 : padd_status;
        signal padd_status_l2 : padd_status;

        signal padd_add_counter : std_logic;
begin

        COUNTER_BANK : entity work.counter_bank
                generic map(N => N)
                port map(
                        clk              => clk, 
                        rst              => rst, 

                        padd_output      => data_valid_in,
                        in_count         => in_count,

                        counters_values  => counters,
                        counters_status  => counter_status
                );

        SIGSEL: entity work.signal_selector
                generic map(K => K)
                port map(
                        w_value                 => counters.window,

                        bucket_kstatus          => bucket_kstatus,
                        fifo_bank_kempty        => fifo_bank_kempty,

                        fifo_bank_empty         => fifo_empty,
                        bucket_status           => bucket_status
                );

        ADDITION: entity work.FSM_addition
                generic map(K => K)
                port map(
                        clk => clk,
                        rst => rst,

                        bucket_read => start_MSM,
                        bucket_status => bucket_status,
                        fifo_bank_empty => fifo_empty_s,
                        fifo_bank_full  => fifo_full_s,

                        window_done => counter_status.status_w_done,
                        fifo_done => counter_status.status_fifo_done,
                        input_done => counter_status.status_input_done,
                        padd_done => counter_status.status_padd_done,

                        w_count         => w_next_l1,
                        fifo_next       => in_count.fifo_count,
                        point_next      => in_count.input_count,

                        fifo_we => fifo_bank_we,
                        fifo_re => fifo_bank_re,
                        fifo_select => fifo_select,

                        empty_bit_out   => bucket_status_o.empty_o,
                        busy_bit_out    => bucket_status_o.busy_o,
                        bucket_web      => bucket_web_o,

                        padd_status_out => padd_status_l1,
                        loop2_start => start_L2,

                        data_A_select => data_A_select_L1,
                        data_B_select => data_B_select_L1 
                );

        input_next <= in_count.input_count;

        AGGREGATION: entity work.FSM_aggregator
                port map(
                        clk => clk,
                        rst => rst,

                        aggregation_start       => start_L2,

                        -- Status 
                        window_done            => counter_status.status_w_done,
                        segment_done           => counter_status.status_m_done,
                        elements_done          => counter_status.status_u_done,
                        log_done               => counter_status.status_log_done,

                        padd_done              => counter_status.status_padd_done,

                        addr_A_read_out        => addr_A_select_L2, 
                        addr_B_read_out        => addr_B_select_L2, 

                        data_A_select          => data_A_select_L2, 
                        data_B_select          => data_B_select_L2, 

                        k_next                 => w_next_l2, 
                        u_next                 => in_count.u_count, 
                        m_next                 => in_count.m_count, 
                        log_next               => in_count.log_count, 

                        padd_status_out        => padd_status_l2, 
                        aggregation_done       => start_L3
                );
        
        in_count.padd_count <= padd_status_l1.data_valid or padd_status_l2.data_valid;

        TO_HOST: entity work.FSM_toHost
                port map(
                        clk => clk,
                        rst => rst,
                        dispatch_start => start_L3,
                        window_done => counter_status.status_w_done,

                        k_next => w_next_l3,
                        output_fifo_we => output_we,
                        done => MSM_done 
                );

        CHOOSE_FSM: entity work.FSM_output
                port map(
                        clk => clk,
                        rst => rst,

                        start_loop1 => start_MSM,
                        start_loop2 => start_L2,
                        start_loop3 => start_L3,

                        done => MSM_done,

                        choose_signals => loop_selection
                );

        counters_addr <= counters;

        WINDOW_NEXT_ASSIGNMENT: process(loop_selection, w_next_l1, w_next_l2, w_next_l3, in_count)
        begin
                case loop_selection is
                        when "00" =>   in_count.w_count  <= w_next_l1;
                        when "01" =>   in_count.w_count  <= w_next_l2;
                        when others => in_count.w_count  <= w_next_l3;
                end case;
        end process;

        WRITE_DV_PADD: process(loop_selection, padd_status_l1, padd_status_l2)
        begin
                case loop_selection is
                        when "00" =>   padd_status_out <= padd_status_l1;
                        when others => padd_Status_out <= padd_status_l2;
                end case;
        end process;

        PADD_OPERAND_A : process(loop_selection, data_A_select_L1, data_A_select_L2)
        begin
                case loop_selection is
                        when "00" =>   op_selector_A <= data_A_select_L1;
                        when others => op_selector_A <= data_A_select_L2;
                end case;
        end process;

        PADD_OPERAND_B : process(loop_selection, data_B_select_L1, data_B_select_L2)
        begin
                case loop_selection is
                        when "00" =>   op_selector_B <= data_B_select_L1;
                        when others => op_selector_B <= data_B_select_L2;
                end case;
        end process;

        ADDR_A_SEL : process(loop_selection, addr_A_select_L1, addr_A_select_L2)
        begin
                case loop_selection is
                        when "00" =>   addr_selector_A <= addr_A_select_L1;
                        when others => addr_selector_A <= addr_A_select_L2;
                end case;
        end process;

        ADDR_B_SEL : process(loop_selection, addr_B_select_L1, addr_B_select_L2)
        begin
                case loop_selection is
                        when "00" =>   addr_selector_B <= addr_B_select_L1;
                        when others => addr_selector_B <= addr_B_select_L2;
                end case;
        end process;

        PADD_DV_ADD : process(loop_selection, padd_status_l1, padd_status_l2)
        begin
                case loop_selection is
                        when "00" =>   padd_add_counter <= padd_status_l1.data_valid;
                        when others => padd_add_counter <= padd_status_l2.data_valid;
                end case;
        end process;


end Structural;
