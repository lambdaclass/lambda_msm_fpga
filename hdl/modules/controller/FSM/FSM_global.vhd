library IEEE;
library XPM;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.math_real.ALL;

use work.config.ALL;
use work.funciones.ALL;
use work.tipos.ALL;

use xpm.vcomponents.ALL;

use work.bucket_mem;
use work.point_adder_pip;
use work.fifo_bank;
use work.delay_M;
use work.controller;

entity FSM_global is
    generic(
        N_esc   : natural := N_esc;  -- Operands bit size for x_n
        N_vect  : natural := N_vect;  -- Operands bit size for G_n
        C       : integer := 12;     
        U       : integer := 512;
        M       : integer := 8
    );
    port (
        clk                     : in std_logic;
        rst                     : in std_logic;

        start_MSM               : in std_logic;

        -- Loop 1 input signals
        bucket_empty_bit        : in std_logic;
        bucket_busy_bit         : in std_logic;
        
        fifo_k_empty_bit        : in std_logic;
        fifo_some_full          : in std_logic;
        fifo_all_element        : in std_logic;

            
        -- Loop 2 input signals
        w_count_done		: in std_logic;
        m_count_done		: in std_logic;
        u_count_done		: in std_logic;
        log_count_done		: in std_logic;
        fifo_count_done         : in std_logic;
        in_count_done           : in std_logic;
        
        padd_dv_in		: in std_logic;

        -- Mixed signals
        window_next             : out std_logic;
        padd_status_out         : out std_logic_vector(3 downto 0);

        padd_select_dinA        : out std_logic_vector(1 downto 0);
        padd_select_dinB        : out std_logic_vector(2 downto 0);

        -- Loop 1 output signals
        done                    : out std_logic;
        fifo_we                 : out std_logic; 
        fifo_re                 : out std_logic; 
        fifo_next               : out std_logic; 

        empty_bit_out           : out std_logic; 
        busy_bit_out            : out std_logic; 
        bucket_web              : out std_logic;
        point_next              : out std_logic;

        -- Loop 2 output signals
        u_next             : out std_logic;  
        m_next             : out std_logic;
        log_next           : out std_logic;
        --addr_A_read_out    : out std_logic;
        --addr_B_read_out    : out std_logic;
        --data_A_select      : out std_logic;
        --data_B_select      : out std_logic;
        bucket_address_sel : out std_logic;
        mem_address_sel : out std_logic;
        aux_address_sel : out std_logic;

        -- Loop 3 output signals
        output_fifo_we : out std_logic
                        
    );

end FSM_global;

architecture Structural of FSM_global is

        signal start_loop2 : std_logic;
        signal start_loop3 : std_logic;

        signal k_next_l1   : std_logic;
        signal k_next_l2   : std_logic;
        signal k_next_l3   : std_logic;

        signal padd_status_l1  : std_logic_vector(3 downto 0);
        signal padd_status_l2  : std_logic_vector(3 downto 0);

--        signal address_A_l1 :
--        signal address_A_l2 :
 
        signal data_A_select_L1 : std_logic_vector(1 downto 0); 
        signal data_B_select_L1 : std_logic_vector(2 downto 0); 
 
        signal data_A_select_L2 : std_logic_vector(1 downto 0); 
        signal data_B_select_L2 : std_logic_vector(2 downto 0); 

        signal loop_selection : std_logic_vector(1 downto 0);

        signal done_processing : std_logic;
begin
                
        -- Loop 1

        U_ADDITION : entity work.FSM_addition
                port map(
                        clk                     => clk,
                        rst                     => rst,

                        bucket_read             => start_MSM,

                        bucket_empty_bit        => bucket_empty_bit,
                        bucket_busy_bit         => bucket_busy_bit,
                        
                        fifo_k_empty_bit        => fifo_k_empty_bit,
                        fifo_anyFull_bit        => fifo_some_full,
                        fifo_allWelem_bit       => fifo_all_element,
                        
                        window_done             => w_count_done,
                        fifo_size_done          => fifo_count_done,
                        input_done              => in_count_done,
                        
                        -- output
                        k_next                  => k_next_l1,
                        fifo_we                 => fifo_we,
                        fifo_re                 => fifo_re,
                        fifo_next               => fifo_next,

                        empty_bit_out           => empty_bit_out,
                        busy_bit_out            => busy_bit_out,
                        bucket_web              => bucket_web,
                        
                        padd_status_out         => padd_status_l1,
                        point_next              => point_next,

                        loop2_start             => start_loop2,
                        data_A_select           => data_A_select_L1,
                        data_B_select           => data_B_select_L1
                );
                
        -- Loop 2

        U_AGGREGATOR: entity work.FSM_aggregator
        port map(
                        clk                => clk, 
                        rst                => rst,
                        
                        aggregation_start  => start_loop2,

                        window_done        => w_count_done,
                        segment_done       => m_count_done,
                        elements_done      => u_count_done,
                        log_done           => log_count_done,
                        padd_datavalid     => padd_dv_in,


                        -- output

                        k_next             => k_next_l2,
                        u_next             => u_next,
                        m_next             => m_next,
                        log_next           => log_next,
                        addr_A_read_out    => open,
                        addr_B_read_out    => open,
                        data_A_select      => data_A_select_L2,
                        data_B_select      => data_B_select_L2,
                        padd_status_out    => padd_status_l2,
                        bucket_address_sel => bucket_address_sel,
                        mem_address_sel => mem_address_sel,
                        aux_address_sel => aux_address_sel,
                        aggregation_done => start_loop3
                );

        U_TOHOST: entity work.FSM_toHost
        port map( 
                        clk                    => clk, 
                        rst                    => rst, 
                        dispatch_start         => start_loop3, 
                        window_done            => w_count_done, 

                        k_next                 => k_next_l3, 
                        output_fifo_we         => output_fifo_we, 
                        done                   => done_processing 
        );

        done <= done_processing;

        U_SIGNAL_SELECTOR: entity work.FSM_output
        port map(
                        clk => clk,
                        rst => rst,
                        start_loop1 => start_MSM,
                        start_loop2 => start_loop2,
                        start_loop3 => start_loop3,
                        done => done_processing,

                        choose_signals => loop_selection
                );

        WINDOW_NEXT_ASSIGNMENT: process(loop_selection, k_next_l1, k_next_l2, k_next_l3)
        begin
                case loop_selection is
                        when "00" =>   window_next  <= k_next_l1;
                        when "01" =>   window_next  <= k_next_l2;
                        when others => window_next  <= k_next_l3;
                end case;
        end process;

        WRITE_DV_PADD: process(loop_selection, padd_status_l1, padd_status_l2)
        begin
                case loop_selection is
                        when "00" =>   padd_status_out <= padd_status_l1;
                        when others => padd_Status_out <= padd_status_l2;
                end case;
        end process;

        PADD_OPERAND_A : process(loop_selection)
        begin
                case loop_selection is
                        when "00" =>   padd_select_dinA <= data_A_select_L1;
                        when others => padd_select_dinA <= data_A_select_L2;
                end case;
        end process;

        PADD_OPERAND_B : process(loop_selection)
        begin
                case loop_selection is
                        when "00" =>   padd_select_dinB <= data_B_select_L1;
                        when others => padd_select_dinB <= data_B_select_L2;
                end case;
        end process;


end Structural;
