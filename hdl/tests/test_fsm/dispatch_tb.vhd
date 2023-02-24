library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dispatch_tb is
end dispatch_tb;

architecture tb of dispatch_tb is

        constant CLK_PERIOD : time := 2ns;
        constant K : natural := 5;

        signal clk : std_logic;
        signal rst : std_logic;

        signal mem_dataReady : std_logic;
        signal fifo_flush_signal : std_logic;

        signal counter_value : std_logic_vector(4 downto 0);
        signal empty_bits : std_logic_vector(K - 1 downto 0);
        signal busy_bits : std_logic_vector(K - 1 downto 0);

        -- Output 

        signal to_busIn : std_logic;
        signal to_fifoIn : std_logic;

        signal point_to_padd : std_logic;

        signal send_window_scalar : std_logic;
        signal send_counter_out : std_logic;

        signal fifo_write_signal : std_logic;

        signal bubble_signal : std_logic;

        signal busy_bit_signal : std_logic;
        signal empty_bit_signal : std_logic;

        signal mem_enable_sig : std_logic_vector(K - 1 downto 0);
        signal mem_write_sig : std_logic_vector(K - 1 downto 0);
        signal mem_output_sig : std_logic_vector(K - 1 downto 0);
        
begin

        UUT : entity work.FSM_L1_dispatch
                generic map(K => K)
                port map(
                        clk => clk,
                        rst => rst,

                        data_ready => mem_dataReady,
                        fifo_flush => fifo_flush_signal,
                        counter => counter_value,

                        empty_bin => empty_bits,
                        busy_bin => busy_bits,

                        start_busIn => to_busIn,
                        start_fifoIn => to_fifoIn,

                        point_enable_in => point_to_padd,

                        -- Outputs 
                        scalar_window_out => send_window_scalar,
                        counter_window_out => send_counter_out,

                        fifo_write => fifo_write_signal,
                        bubble_sig => bubble_signal,

                        busy_bit => busy_bit_signal,
                        empty_bit => empty_bit_signal,

                        mem_enable              => mem_enable_sig,
                        mem_write               => mem_write_sig,
                        mem_output_enput_en     => mem_output_sig  
                );

        CLK_PROCESS: process
        begin
                clk <= '1';
                wait for CLK_PERIOD/2;
                clk <= '0';
                wait for CLK_PERIOD/2;
        end process;

        IN_PROCESS : process
        begin

                rst <= '1';

                busy_bit_signal <= '0';
                empty_bit_signal <= '0';

                counter_value <= (others => '0');
                busy_bits <= (others => '0');
                empty_bits <= (others => '0');

                mem_dataReady <= '0';
                fifo_flush_signal <= '0';
                wait for 2*CLK_PERIOD;

                rst <= '0';
                -- First test: Everything in 0 at the beginning
                wait for 2*CLK_PERIOD;

        -- Second test: Not starting but sending values at the beginning

                fifo_flush_signal <= '1';
                counter_value <= "00010";
                
                empty_bits <= "11011";
                busy_bits <= "00101";

                wait for 2*CLK_PERIOD;

                mem_dataReady <= '1';

                wait for 20*CLK_PERIOD;
        end process;



end tb;
