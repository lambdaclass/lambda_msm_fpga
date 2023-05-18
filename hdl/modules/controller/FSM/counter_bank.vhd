library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use work.funciones.ALL;
use work.tipos.ALL;
use work.config.ALL;

entity counter_bank is
        generic(K : natural := 22;
                U : natural := 512;
                N : natural := 512;
                FIFO_SIZE : natural := 16;
                M : natural := 8);
        port ( 
                clk, rst         : in std_logic;
                
                padd_output      : in std_logic;
                in_count         : in count_signals;

                counters_values : out counters;
                counters_status     : out counters_status
             );
end counter_bank;

architecture Structural of counter_bank is
        signal log_count_enable         : std_logic;
        signal m_count_enable           : std_logic;
        signal u_count_enable           : std_logic;
        signal w_count_enable           : std_logic;
        signal fifo_count_enable        : std_logic;
        signal input_count_enable       : std_logic;
begin

        log_count_enable   <= in_count.log_count;
        m_count_enable     <= in_count.m_count;
        u_count_enable     <= in_count.u_count;
        w_count_enable     <= in_count.w_count;
        fifo_count_enable  <= in_count.fifo_count;
        input_count_enable <= in_count.input_count;

        W_COUNTER : entity work.FSM_w_counter
                generic map(K => K - 1)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => w_count_enable,

                        out_count => counters_values.window, 
                        out_top_v => counters_status.status_w_done
                        );

        M_COUNTER : entity work.FSM_w_counter
                generic map(K => M - 1)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => m_count_enable,

                        out_count => counters_values.segment, 
                        out_top_v => counters_status.status_m_done
                        );

        U_COUNTER : entity work.FSM_w_counter
                generic map(K => U - 1)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => u_count_enable,

                        out_count => counters_values.element, 
                        out_top_v => counters_status.status_u_done
                        );
                
        FIFO_COUNTER : entity work.FSM_w_counter
                generic map(K => FIFO_SIZE)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => fifo_count_enable,

                        out_count => open, 
                        out_top_v => counters_status.status_fifo_done
                        );

        PADD_COUNTER: entity work.FSM_padd_counter
                generic map(K => 10)
                port map(
                        clk => clk,
                        rst => rst,
                        add_count => in_count.padd_count,
                        sub_count => padd_output,

                        out_count => open,
                        out_top_v => counters_status.status_padd_done
                );

        LOG_COUNTER : entity work.FSM_w_counter
                generic map(K => ceil2power(U - 1))
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => log_count_enable,

                        out_count => open, 
                        out_top_v => counters_status.status_log_done
                        );

        INPUT_COUNTER : entity work.FSM_w_counter
                generic map(K => N)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => input_count_enable,

                        out_count => open, 
                        out_top_v => counters_status.status_input_done
                        );
end Structural;
