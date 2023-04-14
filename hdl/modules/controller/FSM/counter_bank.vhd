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
                
                count_enable     : in std_logic;
                
                in_w_count       : in std_logic; 
                in_m_count       : in std_logic; 
                in_u_count       : in std_logic; 
                in_log_count     : in std_logic; 
                in_fifo_count    : in std_logic; 
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
        signal log_count_enable         : std_logic;
        signal m_count_enable           : std_logic;
        signal u_count_enable           : std_logic;
        signal w_count_enable           : std_logic;
        signal fifo_count_enable        : std_logic;
        signal input_count_enable       : std_logic;

        signal start_delay_enable       : std_logic_vector(0 downto 0);

begin


        log_count_enable   <= start_delay_enable(0) and in_log_count;
        m_count_enable     <= start_delay_enable(0) and in_m_count;
        u_count_enable     <= start_delay_enable(0) and in_u_count;
        w_count_enable     <= start_delay_enable(0) and in_w_count;
        fifo_count_enable  <= start_delay_enable(0) and in_fifo_count;

        DELAY_START : entity work.delay_1
                generic map(WORD_WIDTH => 1)
                port map(
                        clk => clk,
                        rst => rst,

                        s => to_slv(count_enable),
                        s_delayed => start_delay_enable
                );

        LOG_COUNTER : entity work.FSM_w_counter
                generic map(K => ceil2power(U - 1))
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => log_count_enable,

                        out_count => log_counter_out, 
                        out_top_v => log_count_done 
                        );

        M_COUNTER : entity work.FSM_w_counter
                generic map(K => M - 1)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => m_count_enable,

                        out_count => m_counter_out, 
                        out_top_v => m_count_done 
                        );

        W_COUNTER : entity work.FSM_w_counter
                generic map(K => K - 1)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => w_count_enable,

                        out_count => w_counter_out, 
                        out_top_v => w_count_done 
                        );

        U_COUNTER : entity work.FSM_w_counter
                generic map(K => U - 1)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => u_count_enable,

                        out_count => u_counter_out, 
                        out_top_v => u_count_done 
                        );
                
        FIFO_COUNTER : entity work.FSM_w_counter
                generic map(K => FIFO_SIZE)
                port map(
                        clk => clk,
                        rst => rst,
                        in_count => fifo_count_enable,

                        out_count => fifo_counter_out, 
                        out_top_v => fifo_count_done 
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
