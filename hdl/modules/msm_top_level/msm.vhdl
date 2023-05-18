library IEEE;
library XPM;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.math_real.ALL;

use work.config.ALL;
use work.funciones.ALL;
use work.tipos.ALL;

use xpm.vcomponents.ALL;

use work.controller;
use work.bucket_mem;
use work.point_adder_pip;
use work.fifo_bank;
use work.delay_M;

entity msm is
    generic(
        N_esc   : natural := N_esc;  
        N_vect  : natural := N_vect; 
        C       : integer := 12;     
        U       : integer := 512;
        N       : integer := 512;
        M       : integer := 8
    );
    port (
        clk             : in std_logic;
        rst             : in std_logic;

        in_write        : in std_logic;
        G_x             : in std_logic_vector(N_vect-1 downto 0);
        G_y             : in std_logic_vector(N_vect-1 downto 0);
        x_n             : in std_logic_vector(N_esc-1 downto 0);  

        out_x           : out std_logic_vector(N_vect-1 downto 0); 
        out_y           : out std_logic_vector(N_vect-1 downto 0); 
        out_z           : out std_logic_vector(N_vect-1 downto 0); 

        out_read        : in std_logic;
        
        output_flag_empty        : out std_logic;  
        output_flag_full         : out std_logic; 
        output_flag_rst_busy     : out std_logic; 
        output_flag_almost_empty : out std_logic;

        input_flag_empty         : out std_logic;  
        input_flag_full          : out std_logic; 
        input_flag_rst_busy      : out std_logic; 
        input_flag_almost_empty  : out std_logic 
    );
end msm;

architecture Behavioral of msm is

        signal array_xn_k : array_xn(K-1 downto 0);

        signal bucket_port_a            : memory_in_t;
        signal bucket_port_b            : memory_in_t;
        signal bucket_port_out          : dp_memory_out_t;

        signal bucket_ka               : std_logic_vector(ceil2power(K)-1 downto 0);
        signal bucket_kb               : std_logic_vector(ceil2power(K)-1 downto 0);

        signal bucket_kbusy_o           : std_logic_vector(K-1 downto 0);
        signal bucket_kempty_o          : std_logic_vector(K-1 downto 0);
        signal bucket_kstatus_t         : bucket_kstatus;
        signal bucket_status_port_b     : bucket_status;
        signal bucket_web_port_b        : std_logic;

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        signal memory_port_a            : memory_in_t;
        signal memory_port_b            : memory_in_t;
        signal memory_port_out          : dp_memory_out_t;

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        signal aux_port_a               : memory_in_t;
        signal aux_port_b               : memory_in_t;
        signal aux_port_out             : dp_memory_out_t;

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        signal pa_op1                   : point_t(2 downto 0);
        signal pa_op2                   : point_t(2 downto 0);
        signal pa_r                     : point_t(2 downto 0);

        signal pa_op1_sel               : padd_op_A;
        signal pa_op2_sel               : padd_op_B;

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
                              
        signal sel_address_A            : address_A;
        signal sel_address_B            : address_B;
                                         
        signal address_A_out            : std_logic_vector(C - 1 downto 0);
        signal address_B_out            : std_logic_vector(C - 1 downto 0);

        ----------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------

        signal counter_signals          : count_signals;
        signal counter_values           : counters;
        signal counter_status           : counters_status;

        signal padd_dv_in               : std_logic;

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        signal temp_input               : std_logic_vector(3*N_vect - 1 downto 0);

        signal fifo_bank_din            : std_logic_vector(DWIDTH_FIFO_B-1 downto 0);
        signal fifo_bank_dout           : std_logic_vector(DWIDTH_FIFO_B-1 downto 0);
        signal fifo_bank_k              : std_logic_vector(ceil2power(K)-1 downto 0);
        signal fifo_bank_we             : std_logic;
        signal fifo_bank_re             : std_logic;
        signal fifo_select              : std_logic;

        signal fifo_bank_empty : std_logic;
        signal fifo_bank_full  : std_logic;
        signal fifo_bank_kempty_s : std_logic_vector(K - 1 downto 0);

        signal padd_delay_in            : padd_delay;
        signal padd_delay_out           : padd_delay;
        signal propagation_out          : std_logic_vector(ceil2power(K) + C + 3 downto 0);

        signal fifo_input_in            : fifo_in_t;
        signal fifo_input_out           : fifo_out_t;

        signal fifo_out_in              : fifo_in_t;
        signal fifo_out_out             : fifo_out_t;

        signal padd_status_o            : padd_status;

begin

        -- Input
        fifo_input_in.din_x  <= G_x;
        fifo_input_in.din_y  <= G_y;
        fifo_input_in.din_z  <= zeros(N_vect - N_esc) & x_n;
        fifo_input_in.we     <= in_write;

        temp_input <= (std_logic_vector(to_unsigned(1, N_vect)) & fifo_input_out.dout_y & fifo_input_out.dout_x);

        U_POINT_ADDER: entity point_adder_pip
        port map(
                clk             => clk,
                rst             => rst,
        
                -- P1
                x1              => pa_op1(0),
                y1              => pa_op1(1),
                z1              => pa_op1(2),
                -- P2 
                x2              => pa_op2(0),
                y2              => pa_op2(1),
                z2              => pa_op2(2),
                -- R
                xr              => pa_r(0),
                yr              => pa_r(1),
                zr              => pa_r(2)
        );                                         

        process(pa_op1_sel, bucket_port_out, memory_port_out, aux_port_out)
        begin
                case pa_op1_sel is
                        when bucket_op          =>  pa_op1 <= to_point_t_threeCoords(bucket_port_out.doutb);
                        when segment_op         =>  pa_op1 <= to_point_t_threeCoords(memory_port_out.doutb);
                        when others             =>  pa_op1 <= to_point_t_threeCoords(aux_port_out.doutb);
                end case;
        end process;

        process(pa_op2_sel, bucket_port_out, memory_port_out, aux_port_out, fifo_bank_dout, temp_input)
        begin
                case pa_op2_sel is
                        when bucket_op          =>  pa_op2 <= to_point_t_threeCoords(bucket_port_out.doutb);
                        when fifo_op            =>  pa_op2 <= to_point_t_threeCoords(fifo_bank_dout(3*N_vect - 1 downto 0));
                        when segment_op         =>  pa_op2 <= to_point_t_threeCoords(memory_port_out.doutb);
                        when aux_op             =>  pa_op2 <= to_point_t_threeCoords(aux_port_out.doutb);
                        when others             =>  pa_op2 <= to_point_t_threeCoords(temp_input);
                end case;
        end process;

        bucket_port_a  <= (padd_delay_out.data_valid and padd_delay_out.bucket_we , padd_delay_out.address, (zeros(DWIDTH_BUCKET - 3*N_vect) & pa_r(2) & pa_r(1) & pa_r(0)));
        memory_port_a  <= (padd_delay_out.data_valid and padd_delay_out.mem_we    , padd_delay_out.address, (zeros(DWIDTH_BUCKET - 3*N_vect) & pa_r(2) & pa_r(1) & pa_r(0)));
        aux_port_a     <= (padd_delay_out.data_valid and padd_delay_out.aux_we    , padd_delay_out.address, (zeros(DWIDTH_BUCKET - 3*N_vect) & pa_r(2) & pa_r(1) & pa_r(0)));

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        
        U_BUCKET_MEM: entity work.bucket_mem
        generic map(
                K           => integer(ceil(real(N_esc)/real(C))),
                DWIDTH      => DWIDTH_BUCKET,
                AWIDTH      => C
        )
        port map(
                clk         => clk,
                -- rst         => rst,
                -- Port A
                port_a      => bucket_port_a,

                -- Port B
                port_b      => bucket_port_b,

                -- Window selection
                ka          => bucket_ka,
                kb          => bucket_kb,

                -- Flags
                busya_o     => open,   
                busyb_o     => bucket_kstatus_t.busy_o,   
                emptya_o    => open,  
                emptyb_o    => bucket_kstatus_t.empty_o, 

                -- Output
                mem_out => bucket_port_out
        );                

        bucket_kb <= counter_values.window;
        bucket_ka <= padd_delay_out.window;

        U_SEGMENT_MEMORY: entity work.uram_dp_wf
        generic map(
                AWIDTH  => integer(ceil(real(N_esc))/real(K)),
                DWIDTH  => DWIDTH_BUCKET
                   )
        port map(
                clk     => clk,
                mem_ena => '1',
                mem_enb => '1',
                wea     => memory_port_a.we,
                addra   => memory_port_a.addr,
                dina    => memory_port_a.din,
                web     => memory_port_b.we,
                addrb   => memory_port_b.addr,
                dinb    => memory_port_b.din,

                douta   => memory_port_out.douta,
                doutb   => memory_port_out.doutb
        );

        U_AUX_MEMORY: entity work.uram_dp_wf
        generic map(
                AWIDTH  => integer(ceil(real(N_esc))/real(K)),
                DWIDTH  => DWIDTH_BUCKET
                   )
        port map(
                clk     => clk,
                mem_ena => '1',
                mem_enb => '1',

                wea     => aux_port_a.we,
                addra   => aux_port_a.addr,
                dina    => aux_port_a.din,
                web     => aux_port_b.we,
                addrb   => aux_port_b.addr,
                dinb    => aux_port_b.din,

                douta   => aux_port_out.douta,
                doutb   => aux_port_out.doutb
        );

        U_FIFO_BANK: entity work.fifo_bank
        port map(
                clk    => clk,
                rst    => rst,
                
                -- Control signals
                kv       => fifo_bank_k,
                we       => fifo_bank_we,
                re       => fifo_bank_re,

                empty_dispatch_o => fifo_bank_kempty_s, 
                bank_empty       => fifo_bank_empty,
                bank_full        => fifo_bank_full,
        
                 -- Data signals
                din      => fifo_bank_din,
                dout     => fifo_bank_dout

        );                                         

        process(fifo_select, address_A_out, temp_input, fifo_bank_dout)
        begin
                case fifo_select is
                        when '0'        => fifo_bank_din <= address_A_out & temp_input;
                        when others     => fifo_bank_din <= fifo_bank_dout;
                end case;
        end process;

        fifo_bank_k     <= counter_values.window;

        U_INPUT: entity work.generic_fifo
        generic map(NUMBER_FIFOS => 3)
        port map(
                    clk               => clk,
                    rst               => rst, 

                    debug_counter_wr  => open,
                    debug_counter_rd  => open,
                    fifo_in           => fifo_input_in,
                    fifo_out          => fifo_input_out 
        );

        input_flag_full <= fifo_input_out.full_o;
        input_flag_empty <= fifo_input_out.empty_o;
        input_flag_almost_empty <= fifo_input_out.almost_empty_o;
        input_flag_rst_busy <= fifo_input_out.rst_busy_o;

        U_OUTPUT: entity work.generic_fifo
        generic map(NUMBER_FIFOS => 3)
        port map(
                    clk               => clk,
                    rst               => rst, 

                    debug_counter_wr  => open,
                    debug_counter_rd  => open,
                    fifo_in           => fifo_out_in,
                    fifo_out          => fifo_out_out
        );

        fifo_out_in.din_x <= memory_port_out.doutb(376 downto 0);
        fifo_out_in.din_y <= memory_port_out.doutb(753 downto 377);
        fifo_out_in.din_z <= memory_port_out.doutb(1130 downto 754);

        fifo_out_in.re <= out_read;

        out_x <= fifo_out_out.dout_x;
        out_y <= fifo_out_out.dout_y;
        out_z <= fifo_out_out.dout_z;
        output_flag_full        <= fifo_out_out.full_o;
        output_flag_almost_empty<= fifo_out_out.almost_empty_o;
        output_flag_empty       <= fifo_out_out.empty_o;
        output_flag_rst_busy    <= fifo_out_out.rst_busy_o;

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        U_PROPAGATION: entity work.delay_M
        generic map(
                WORD_WIDTH      => ceil2power(K) + C + 3 + 1,
                DELAY           => 55 + 1
        )
        port map(
                clk => clk,
                rst => rst,

                s => to_vector_padd_d(padd_delay_in),
                s_delayed => propagation_out
        );

        padd_delay_in <= (padd_status_o.data_valid, padd_status_o.bucket_we, padd_status_o.mem_we, padd_status_o.aux_we, counter_values.window, address_A_out);
        padd_delay_out <= to_padd_d(propagation_out);

        U_ADDRESS_SEL: entity work.addr_selection
        generic map(
                N_esc => N_esc,
                K_sel => K,
                U_sel => U,
                M_sel => M,
                C => C)
        port map (
                x_n     => fifo_input_out.dout_z(252 downto 0),
                fifo_xn => fifo_bank_dout(fifo_bank_dout'length - 1 downto fifo_bank_dout'length - 12),

                counters => counter_values,

                select_addr_A => sel_address_A,
                select_addr_B => sel_address_B,

                address_out_A => address_A_out,
                address_out_B => address_B_out
        ); 

        aux_port_b.we   <= '0';
        aux_port_b.din  <= (others => '0');

        bucket_port_b.we        <= bucket_web_port_b; 
        bucket_port_b.din       <= bucket_status_port_b.busy_o & bucket_status_port_b.empty_o & zeros(DWIDTH_BUCKET - 2 - 3*N_vect) & temp_input;

        memory_port_b.we        <= '0';
        memory_port_b.din       <= (others => '0');

        CONTROLLER_MGMT : entity work.controller
        generic map (K => K,
                      C => C,
                      M => M,
                      N => N,
                      U => U)
        port map( 
                clk                     => clk,
                rst                     => rst, 

                start_MSM               => not fifo_input_out.empty_o,
                data_valid_in           => padd_delay_out.data_valid,
                bucket_kstatus          => bucket_kstatus_t, 

                fifo_bank_kempty        => fifo_bank_kempty_s, 
                fifo_empty_s            => fifo_bank_empty,
                fifo_full_s             => fifo_bank_full,

                op_selector_A           => pa_op1_sel, 
                op_selector_B           => pa_op2_sel, 

                addr_selector_A         => sel_address_A, 
                addr_selector_B         => sel_address_B, 

                fifo_bank_we            => fifo_bank_we,
                fifo_bank_re            => fifo_bank_re,
                fifo_select             => fifo_select,

                bucket_status_o         => bucket_status_port_b,
                bucket_web_o            => bucket_web_port_b,

                counters_addr           => counter_values, 
                padd_status_out         => padd_status_o,

                input_next              => fifo_input_in.re, 
                output_we               => fifo_out_in.we
             );

end Behavioral;
