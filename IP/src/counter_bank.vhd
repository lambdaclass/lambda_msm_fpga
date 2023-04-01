library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.funciones.ALL;

entity counter_bank is
        generic(K : natural := 22;
                U : natural := 512;
                N : natural := 512;
                FIFO_SIZE : natural := 16;
                M : natural := 8);
        port ( 
                clk, rst         : in std_logic;
                in_w_count       : in std_logic; 
                in_m_count       : in std_logic; 
                in_u_count       : in std_logic; 
                in_log_count     : in std_logic; 
                in_fifo_count    : in std_logic; 
                in_input         : in std_logic;
                in_padd          : in std_logic;
        

                w_counter_out    : out std_logic_vector(ceil2power(K) - 1 downto 0);
                m_counter_out    : out std_logic_vector(ceil2power(M - 1) - 1 downto 0);
                u_counter_out    : out std_logic_vector(ceil2power(U - 1) - 1 downto 0);
                log_counter_out  : out std_logic_vector(ceil2power(ceil2power(U - 1))- 1 downto 0);
                fifo_counter_out : out std_logic_vector(ceil2power(FIFO_SIZE)- 1 downto 0);
                
                w_count_done     : out std_logic;
                m_count_done     : out std_logic;
                u_count_done     : out std_logic;
                log_count_done   : out std_logic;
                fifo_count_done  : out std_logic;
                padd_count_done  : out std_logic;
                input_count_done : out std_logic

             );
end counter_bank;

architecture Structural of counter_bank is
begin
        LOG_COUNTER : entity work.FSM_w_counter
                generic map(K => ceil2power(U - 1))
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => in_log_count,

                        out_count => log_counter_out, 
                        out_top_v => log_count_done 
                        );

        M_COUNTER : entity work.FSM_w_counter
                generic map(K => M - 1)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => in_m_count,

                        out_count => m_counter_out, 
                        out_top_v => m_count_done 
                        );

        W_COUNTER : entity work.FSM_w_counter
                generic map(K => K)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => in_w_count,

                        out_count => w_counter_out, 
                        out_top_v => w_count_done 
                        );

        -- Nota: El valor de u_count no puede ser 0.
        U_COUNTER : entity work.FSM_w_counter
                generic map(K => U - 1)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => in_u_count,

                        out_count => u_counter_out, 
                        out_top_v => u_count_done 
                        );
                
        FIFO_COUNTER : entity work.FSM_w_counter
                generic map(K => FIFO_SIZE)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => in_fifo_count,

                        out_count => fifo_counter_out, 
                        out_top_v => fifo_count_done 
                        );

        INPUT_COUNTER : entity work.FSM_w_counter
                generic map(K => N)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => in_input,

                        out_count => open,
                        out_top_v => input_count_done
                );

        PADD_COUNTER: entity work.FSM_w_counter
                generic map(K => N)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => in_padd,

                        out_count => open,
                        out_top_v => padd_count_done
                );
end Structural;
