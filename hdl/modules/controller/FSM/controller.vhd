library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.funciones.ALL;
use work.tipos.ALL;
use work.config.ALL;

entity controller is
        generic (K : natural := 22;
                 U : natural := 512;
                 M : natural := 8;
                 SCALAR_SIZE : natural := 253;
                 C : natural := 12;
                 FIFO_WRITE_SIZE : natural := 16);
        port ( 
                -----------------------
                -------- INPUT --------
                -----------------------
                clk, rst        : in std_logic;

                start_MSM       : in std_logic;

                -- State values
                busyb_in        : in std_logic_vector(K - 1 downto 0);
                emptyb_in       : in std_logic_vector(K - 1 downto 0);
                empty_fifo_in   : in std_logic_vector(K - 1 downto 0);
                full_fifo_in    : in std_logic_vector(K - 1 downto 0);
                
                padd_dv_in      : in std_logic;
                ------------------------
                -------- OUTPUT --------
                ------------------------

                -- Todo esto es loop 1
                w_value_out     : out std_logic_vector(ceil2power(K) - 1 downto 0);
                m_value_out     : out std_logic_vector(ceil2power(M - 1) - 1 downto 0);
                u_value_out     : out std_logic_vector(ceil2power(U - 1) - 1 downto 0);

                fifo_re_out     : out std_logic;
                fifo_we_out     : out std_logic;

                bucket_web_out  : out std_logic;
                bucket_emptyB   : out std_logic;
                bucket_busyB    : out std_logic;

                point_next      : out std_logic;
                padd_status     : out std_logic_vector(3 downto 0);


                -- Todo esto es loop 2

                loop_process    : out std_logic; 
                op_selector_A   : out std_logic_vector(1 downto 0);
                op_selector_B   : out std_logic_vector(1 downto 0);

                addr_A_out      : out std_logic_vector(1 downto 0);
                addr_B_out      : out std_logic_vector(2 downto 0);

                -- Todo esto es loop 3
                done            : out std_logic;
                data_valid_out  : out std_logic
             );
end controller;

architecture Structural of controller is

        -- Todas estas seniales son de contadores

        signal window_value     : std_logic_vector(ceil2power(K) - 1 downto 0);
        signal segment_value    : std_logic_vector(ceil2power(M - 1) - 1 downto 0);
        signal element_value    : std_logic_vector(ceil2power(U - 1) - 1 downto 0);
        signal log_value        : std_logic_vector(ceil2power(ceil2power(U - 1)) - 1 downto 0);
        signal fifo_value       : std_logic_vector(ceil2power(FIFO_WRITE_SIZE) - 1 downto 0);

        signal window_c_in      : std_logic;
        signal segment_c_in     : std_logic;
        signal element_c_in     : std_logic;
        signal log_c_in         : std_logic;
        signal fifo_c_in        : std_logic;
        signal input_c_in       : std_logic;
        signal padd_c_in        : std_logic;

        signal w_count_done     : std_logic;
        signal m_count_done     : std_logic;
        signal u_count_done     : std_logic;
        signal fifo_count_done  : std_logic;
        signal log_count_done   : std_logic;
        signal in_count_done    : std_logic;
        signal padd_count_done  : std_logic;

        -- Estas son del selector de seniales
        signal bucket_empty_sig : std_logic;
        signal bucket_busy_sig  : std_logic;
        signal fifo_some_full   : std_logic;
        signal fifo_all_element : std_logic;
        signal fifo_k_empty_sig : std_logic;


        -- Estas son del dispatch
        signal fifo_write_en    : std_logic;
        signal fifo_read_en     : std_logic;

        signal bucket_write_en  : std_logic;

        signal dispatch_done    : std_logic;

        signal busyb_out        : std_logic;
        signal emptyb_out       : std_logic;
        signal padd_endprocess  : std_logic;

        signal point_next_in    : std_logic;
        signal points_in        : std_logic;
        signal points_selection : std_logic;
        signal points_processed : std_logic;
        signal o_points_in      : std_logic;


        signal point_adder_status_L1 : std_logic_vector(3 downto 0);
        signal point_adder_status_L2 : std_logic_vector(3 downto 0);

        signal op_selector_A_L1 : std_logic_vector(1 downto 0);
        signal op_selector_A_L2 : std_logic_vector(1 downto 0);

        signal op_selector_B_L1 : std_logic_vector(1 downto 0);
        signal op_selector_B_L2 : std_logic_vector(1 downto 0);

begin

        COUNTER_BANK : entity work.counter_bank
                port map(
                        clk              => clk, 
                        rst              => rst, 

                        count_enable     => start_MSM,

                        in_w_count       => window_c_in, 
                        in_m_count       => segment_c_in, 
                        in_u_count       => element_c_in, 
                        in_log_count     => log_c_in, 
                        in_fifo_count    => fifo_c_in, 
                        in_padd          => padd_dv_in, 
        

                        w_counter_out    => window_value, 
                        m_counter_out    => segment_value, 
                        u_counter_out    => element_value, 
                        log_counter_out  => log_value, 
                        fifo_counter_out => fifo_value, 
                        
                        w_count_done     => w_count_done, 
                        m_count_done     => m_count_done, 
                        u_count_done     => u_count_done, 
                        log_count_done   => log_count_done, 
                        fifo_count_done  => fifo_count_done, 
                        padd_count_done  => padd_count_done, 
                        input_count_done => in_count_done
                );

        SIGSEL: entity work.signal_selector
                generic map(K => K)
                port map(
                        w_value                 => window_value,

                        bucket_kempty           => emptyb_in,
                        bucket_kbusy            => busyb_in,
                        fifo_kfull              => full_fifo_in,
                        fifo_kempty             => empty_fifo_in,

                        bucket_empty_b          => bucket_empty_sig,
                        bucket_busy_b           => bucket_busy_sig,
                        fifo_anyFull            => fifo_some_full,
                        fifo_allWithElem        => fifo_all_element,
                        fifo_k_empty            => fifo_k_empty_sig
                );
                
  --      ADDITION : entity work.FSM_addition
  --              port map(
  --                      clk                     => clk,
  --                      rst                     => rst,

  --                      bucket_read             => start_MSM,
  --                      bucket_empty_bit        => bucket_empty_sig,
  --                      bucket_busy_bit         => bucket_busy_sig,
  --                      
  --                      fifo_k_empty_bit        => fifo_k_empty_sig,
  --                      fifo_anyFull_bit        => fifo_some_full,
  --                      fifo_allWelem_bit       => fifo_all_element,
  --                      
  --                      window_done             => w_count_done,
  --                      fifo_size_done          => fifo_count_done,
  --                      input_done              => in_count_done,
  --                      
  --                      -- output
  --                      fifo_we                 => fifo_we_out,
  --                      fifo_re                 => fifo_re_out,
  --                      fifo_next               => fifo_c_in,

  --                      empty_bit_out           => bucket_emptyB,
  --                      busy_bit_out            => bucket_busyB,
  --                      bucket_web              => bucket_web_out,
  --                      
  --                      padd_datavalid          => padd_dv_out,
  --                      point_next              => point_next,

  --                      loop_done               => dispatch_done,
  --                      op_selector_B           => op_selector_B_L1
  --              );


        AGGREGATOR : entity work.FSM_aggregator
                port map ( 
                        clk                => clk, 
                        rst                => rst,
                        
                        aggregation_start  => dispatch_done,

                        window_done        => w_count_done,
                        segment_done       => m_count_done,
                        elements_done      => u_count_done,
                        log_done           => log_count_done,
                        padd_datavalid     => padd_dv_in,

                        addr_A_read_out    => addr_A_out,
                        addr_B_read_out    => addr_B_out,

                        k_next             => window_c_in,
                        u_next             => element_c_in,
                        m_next             => segment_c_in,
                        log_next           => log_c_in,

                        padd_status_out    => point_adder_status_L2,
                        data_A_select      => op_selector_A_L2,
                        data_B_select      => op_selector_B_L2

        );

        loop_process    <= dispatch_done;
        op_selector_A   <= op_selector_A_L1 when dispatch_done = '0' else
                           op_selector_A_L2;

        op_selector_B   <= op_selector_B_L1 when dispatch_done = '0' else 
                           op_selector_B_L2 ;
                

        process(padd_status, dispatch_done)
        begin
                padd_status <= point_adder_status_L2 when dispatch_done = '1' else
                               point_adder_status_L1;
        end process;

        w_value_out <= window_value;
        m_value_out <= segment_value;
        u_value_out <= element_value;

        data_valid_out <= '0';
        done <= '0';

end Structural;
