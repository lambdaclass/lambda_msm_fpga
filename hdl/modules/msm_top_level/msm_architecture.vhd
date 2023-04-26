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

entity msm_arch is
    generic(
        N_esc   : natural := N_esc;  -- Operands bit size for x_n
        N_vect  : natural := N_vect;  -- Operands bit size for G_n
        C       : integer := 12;     
        U       : integer := 512;
        M       : integer := 8
    );
    port (
        clk             : in std_logic;
        rst             : in std_logic;

        start_MSM       : in std_logic;
        G_x             : in std_logic_vector(N_vect-1 downto 0);
        G_y             : in std_logic_vector(N_vect-1 downto 0);
        x_n             : in std_logic_vector(N_esc-1 downto 0);  

        out_x           : out std_logic_vector(N_vect-1 downto 0);  --output coordinate X
        out_y           : out std_logic_vector(N_vect-1 downto 0);  --output coordinate Y
        out_z           : out std_logic_vector(N_vect-1 downto 0);  --output coordinate Y

        
        input_flag_empty        : out std_logic; 
        input_flag_full         : out std_logic; 
        input_flag_rst_busy     : out std_logic; 
        input_flag_almost_empty : out std_logic; 

        output_flag_empty        : out std_logic;  -- This is the new "data valid". When an element is on the output fifos, then the result is valid.
        output_flag_full         : out std_logic; 
        output_flag_rst_busy     : out std_logic; 
        output_flag_almost_empty : out std_logic 
    );
end msm_arch;

architecture Behavioral of msm_arch is

        type array_xn is array(natural range<>) of std_logic_vector(C-1 downto 0);
        signal array_xn_k : array_xn(K-1 downto 0);

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        -- Constants

        constant DWIDTH_BUCKET  : integer := 72*16;
        constant DWIDTH_FIFO_B  : integer := 3*N_vect + c;
        constant AWIDTH_BUCKET  : integer := N_esc;
        constant FIFO_WRITE_SIZE : integer := 16;

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
       
        signal bucket_addra     : std_logic_vector (C-1 downto 0); 
        signal bucket_addrb     : std_logic_vector (C-1 downto 0); 
        
        signal bucket_wea       : std_logic;
        signal bucket_web       : std_logic;
        signal bucket_kwa       : std_logic_vector(ceil2power(K)-1 downto 0);
        signal bucket_kra       : std_logic_vector(ceil2power(K)-1 downto 0);
        signal bucket_kwb       : std_logic_vector(ceil2power(K)-1 downto 0);
        signal bucket_krb       : std_logic_vector(ceil2power(K)-1 downto 0);
        signal bucket_kbusy_o   : std_logic_vector(K-1 downto 0);
        signal bucket_kempty_o  : std_logic_vector(K-1 downto 0);

        signal bucket_dina      : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in A
        signal bucket_dinb      : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in B      
        signal bucket_douta     : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out A
        signal bucket_doutb     : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out B
        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        signal pa_op1           : point_t(2 downto 0);
        signal pa_op2           : point_t(2 downto 0);
        signal pa_r             : point_t(2 downto 0);

        signal pa_op1_sel       : std_logic_vector(1 downto 0);
        signal pa_op2_sel       : std_logic_vector(2 downto 0);

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        signal mem_addra        : std_logic_vector (C-1 downto 0); 
        signal mem_addrb        : std_logic_vector (C-1 downto 0);  

        signal mem_wea          : std_logic;
        signal mem_web          : std_logic;

        signal mem_dina         : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in A
        signal mem_dinb         : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in B      
        signal mem_douta        : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out A
        signal mem_doutb        : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out A

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        signal aux_addra        : std_logic_vector (C-1 downto 0); 
        signal aux_addrb        : std_logic_vector (C-1 downto 0);  

        signal aux_wea          : std_logic;
        signal aux_web          : std_logic;

        signal aux_dina         : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in A
        signal aux_dinb         : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in B      
        signal aux_douta        : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out A
        signal aux_doutb        : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out A

        signal aux_sel          : std_logic;
        signal bucket_sel       : std_logic;
        signal mem_sel          : std_logic;
        signal cable_aux        : std_logic_vector(DWIDTH_BUCKET-1 downto 0);

        signal package_signals : std_logic_vector(ceil2power(K) + C + 3 downto 0);
        signal package_signals_o : std_logic_vector(ceil2power(K) + C + 3 downto 0);
        signal write_signals    : std_logic_vector(2 downto 0);

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        signal window_value  : std_logic_vector(ceil2power(K) - 1 downto 0);
        signal segment_value : std_logic_vector(ceil2power(M - 1) - 1 downto 0);
        signal element_value : std_logic_vector(ceil2power(U - 1) - 1 downto 0);
                              
        signal sel_address_A : std_logic_vector(2 downto 0);
        signal sel_address_B : std_logic_vector(2 downto 0);
                              
        signal address_A_out : std_logic_vector(C - 1 downto 0);
        signal address_B_out : std_logic_vector(C - 1 downto 0);

        ----------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------

        signal log_value        : std_logic_vector(ceil2power(ceil2power(U - 1)) - 1 downto 0);
        signal fifo_value       : std_logic_vector(ceil2power(FIFO_WRITE_SIZE) - 1 downto 0);

        signal window_c_in      : std_logic;
        signal segment_c_in     : std_logic;
        signal element_c_in     : std_logic;
        signal log_c_in         : std_logic;
        signal w_count_done     : std_logic;
        signal m_count_done     : std_logic;
        signal u_count_done     : std_logic;
        signal log_count_done   : std_logic;
        signal op_selector_B_L2 : std_logic_vector(1 downto 0);

        signal padd_dv_in        : std_logic;


        signal fifo_c_in        : std_logic;
        signal input_c_in       : std_logic;
        signal padd_c_in        : std_logic;

        signal in_count_done    : std_logic;
        signal padd_count_done  : std_logic;

        signal fifo_count_done  : std_logic;

        signal padd_status      : std_logic_vector(3 downto 0);


        signal ec_point : std_logic_vector(3*N_vect - 1 downto 0); 
        signal scalar   : std_logic_vector(N_esc - 1 downto 0);

        signal fifo_in_write : std_logic;
        signal input_fifo_read : std_logic; 

        signal fifo_out_write : std_logic;
        signal fifo_out_read  : std_logic;

        signal fifo_bank_kw     : std_logic_vector(ceil2power(K)-1 downto 0);
        signal fifo_bank_we     : std_logic;
        signal fifo_bank_kr     : std_logic_vector(ceil2power(K)-1 downto 0);
        signal fifo_bank_re     : std_logic;
        signal fifo_bank_empty_o : std_logic_vector(K - 1 downto 0);
        signal fifo_bank_full_o  : std_logic_vector(K - 1 downto 0);
        
        signal fifo_bank_din    : std_logic_vector (DWIDTH_FIFO_B-1 downto 0); -- Data in
        signal fifo_bank_dout   : std_logic_vector (DWIDTH_FIFO_B-1 downto 0); -- Data out



begin
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

        process(pa_op1_sel, bucket_doutb, mem_doutb, aux_doutb)
        begin
                case pa_op1_sel is
                        when "00" =>    pa_op1 <= to_point_t_threeCoords(bucket_doutb);
                        when "01" =>    pa_op1 <= to_point_t_threeCoords(mem_doutb);
                        when others =>  pa_op1 <= to_point_t_threeCoords(aux_doutb);
                end case;
        end process;

        process(pa_op2_sel, bucket_doutb, mem_doutb, aux_doutb)
        begin
                case pa_op2_sel is
                        when "000" =>    pa_op2 <= to_point_t_threeCoords(bucket_doutb);
                        when "001" =>    pa_op2 <= to_point_t_threeCoords(fifo_bank_dout); -- Deberia agarrar solamente los bits menos significativos.
                        when "010" =>    pa_op2 <= to_point_t_threeCoords(mem_doutb);
                        when "011" =>    pa_op2 <= to_point_t_threeCoords(aux_doutb);
                        when others =>   pa_op2 <= to_point_t_threeCoords(ec_point);
                end case;
        end process;

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        -- Bucket memory
        
        U_BUCKET_MEM: entity work.bucket_mem
        generic map(
                K           => integer(ceil(real(N_esc)/real(C))),   -- 29 Frames  
                DWIDTH      => DWIDTH_BUCKET,  -- 72*16N -- Data Width
                AWIDTH      => C             -- 12 Address Width
        )
        port map(
                clk         => clk,         -- Clock
                rst         => rst,         -- Reset
                -- Port A
                wea         => bucket_wea,    -- Write Enable - Port A
                dina        => bucket_dina,   -- Data Input - Port A
                addra       => bucket_addra,  -- Address Input - Port A
                douta       => open,  -- Data Output - Port A
                kwa         => bucket_kwa,    -- K select for write - Port A
                kra         => bucket_kra,    -- K select for read - Port A
                -- Port B
                web         => bucket_web,    -- Write Enable - Port B
                dinb        => bucket_dinb,   -- Data Input - Port B
                addrb       => bucket_addrb,  -- Address Input - Port B
                doutb       => bucket_doutb,  -- Data Output - Port B
                kwb         => bucket_kwb,    -- K select for write - Port B
                krb         => bucket_krb,    -- K select for read - Port A
                -- Flags
                busya_o     => open,   -- Busy bit output for addressed K buckets - Port A
                busyb_o     => bucket_kbusy_o,   -- Busy bit output for addressed K buckets - Port B
                emptya_o    => open,  -- Empty bit output for addressed K buckets - Port A
                emptyb_o    => bucket_kempty_o-- Empty bit output for addressed K buckets - Port B
        );                

        U_SEGMENT_MEMORY: entity work.uram_dp_wf
        generic map(
                AWIDTH  => integer(ceil(real(N_esc))/real(K)),
                DWIDTH  => DWIDTH_BUCKET
                   )
        port map(
                clk     => clk,
                wea     => mem_wea,
                web     => mem_web,
                mem_ena => '1',
                mem_enb => '1',
                dina    => mem_dina,
                addra   => mem_addra,
                douta   => open,
                dinb    => mem_dinb,
                addrb   => mem_addrb,
                doutb   => mem_doutb
        );

        U_AUX_MEMORY: entity work.uram_dp_wf
        generic map(
                AWIDTH  => integer(ceil(real(N_esc))/real(K)),
                DWIDTH  => DWIDTH_BUCKET
                   )
        port map(
                clk     => clk,
                wea     => aux_wea,
                web     => aux_web,
                mem_ena => '1',
                mem_enb => '1',
                dina    => aux_dina,
                addra   => aux_addra,
                douta   => open,
                dinb    => aux_dinb,
                addrb   => aux_addrb,
                doutb   => aux_doutb
        );

        -- Seniales pensadas desde la perspectiva del loop 2
        aux_dina        <= (DWIDTH_BUCKET - 1 downto 3*N_vect => '0') & pa_r(2) & pa_r(1) & pa_r(0);
        bucket_dina     <= (DWIDTH_BUCKET - 1 downto 3*N_vect => '0') & pa_r(2) & pa_r(1) & pa_r(0);
        mem_dina        <= (DWIDTH_BUCKET - 1 downto 3*N_vect => '0') & pa_r(2) & pa_r(1) & pa_r(0);

        mem_web         <= '0';
        bucket_krb      <= window_value;
        bucket_kwb      <= window_value;
        bucket_kra      <= window_value;
        bucket_kra      <= window_value;
        bucket_web      <= '0';

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        -- control, address, window_K (El address para las memorias lineales debe tener la posicion de cada segmento, independientemente del K)
        -- Los 3 bits declarados en WORD_WIDTH sirven como lineas de write_enable para cada una de las memorias.

        U_SCALAR_PROPAGATION: entity work.delay_M
        generic map(
                WORD_WIDTH      => ceil2power(K) + C + 3 + 1,
                DELAY           => 55 + 1
        )
        port map(
                clk => clk,
                rst => rst,

                s => package_signals,
                s_delayed => package_signals_o
        );

        mem_addra       <= package_signals_o(C - 1 downto 0);
        aux_addra       <= package_signals_o(C - 1 downto 0);
        bucket_addra    <= package_signals_o(C - 1 downto 0);

        -- Seleccion de address para cada uno (Desde el loop 2)

        process(aux_sel, address_A_out, address_B_out)
        begin
                case aux_sel is
                        when '1' =>     aux_addrb <= address_A_out;
                        when others =>  aux_addrb <= address_B_out;
                end case;
        end process;

        process(bucket_sel, address_A_out, address_B_out)
        begin
                case bucket_sel is
                        when '1' =>     bucket_addrb <= address_A_out;
                        when others =>  bucket_addrb <= address_B_out;
                end case;
        end process;

        process(mem_sel, address_A_out, address_B_out)
        begin
                case mem_sel is
                        when '1' =>     mem_addrb <= address_A_out;
                        when others =>  mem_addrb <= address_B_out;
                end case;
        end process;
        
        bucket_kwa      <= package_signals_o(16 downto 12);
        
        package_signals <= padd_status & window_value & address_A_out;

        bucket_wea      <=  package_signals_o(ceil2power(K) + C + 3) and package_signals_o(ceil2power(K) + C + 2);
        mem_wea         <=  package_signals_o(ceil2power(K) + C + 3) and package_signals_o(ceil2power(K) + C + 1);
        aux_wea         <=  package_signals_o(ceil2power(K) + C + 3) and package_signals_o(ceil2power(K) + C);

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        U_ADDRESS_SEL: entity work.addr_selection
        generic map(
                N_esc => N_esc,
                K_sel => K,
                U_sel => U,
                M_sel => M,
                C => C)
        port map (
                x_n     => scalar,
                fifo_xn => (others => '0'),
                K       => window_value,
                M       => segment_value,
                U       => element_value,

                select_addr_A => sel_address_A,
                select_addr_B => sel_address_B,

                address_out_A => address_A_out,
                address_out_B => address_B_out
        ); 

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        U_COUNTER_BANK : entity work.counter_bank
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

        -- Loop 2 FSM

        U_AGGREGATOR: entity work.FSM_aggregator
        port map(
                        clk                => clk, 
                        rst                => rst,
                        
                        aggregation_start  => start_MSM,

                        window_done        => w_count_done,
                        segment_done       => m_count_done,
                        elements_done      => u_count_done,
                        log_done           => log_count_done,
                        padd_datavalid     => package_signals_o(ceil2power(K) + C + 3),

                        k_next             => window_c_in,
                        u_next             => element_c_in,
                        m_next             => segment_c_in,
                        log_next           => log_c_in,

                        addr_A_read_out    => sel_address_A,
                        addr_B_read_out    => sel_address_B,

                        padd_status_out    => padd_status,

                        data_A_select      => pa_op1_sel,
                        data_B_select      => pa_op2_sel,

                        bucket_address_sel => bucket_sel,
                        mem_address_sel    => mem_sel,
                        aux_address_sel    => aux_Sel
                );

        U_INPUT: entity work.input_fifo
            port map(
                        clk               => clk,
                        rst               => rst, 
                        input_we          => fifo_in_write, 
                        input_re          => input_fifo_read, 
        
                        x_n               => x_n, 
                        x_coord           => G_x, 
                        y_coord           => G_y, 
        
                        ec_point          => ec_point, 
                        scalar            => scalar, 
        
                        flag_empty        => input_flag_empty, 
                        flag_full         => input_flag_full, 
                        flag_rst_busy     => input_flag_rst_busy, 
                        flag_almost_empty => input_flag_almost_empty
            );

        U_OUTPUT: entity work.output_fifo
        port map(
                        clk               => clk,
                        rst               => rst, 
                        input_we          => fifo_out_write, 
                        input_re          => fifo_out_read, 

                        x_coord          => mem_doutb(376 downto 0), 
                        y_coord          => mem_doutb(753 downto 377), 
                        z_coord          => mem_doutb(1130 downto 754), 

                        out_x_coord       => out_x,
                        out_y_coord      => out_y,
                        out_z_coord        => out_z,

                        flag_empty        => output_flag_empty,
                        flag_full         => output_flag_full,        
                        flag_rst_busy     => output_flag_rst_busy,      
                        flag_almost_empty => output_flag_almost_empty
                );

        -- Deberia agregar cierto delay por la lectura de las fifos.
        U_FIFO_BANK: entity work.fifo_bank
        port map(
                clk    => clk,
                rst    => rst,
                
                -- Control signals
                kw       => fifo_bank_kw,
                we       => fifo_bank_we,
                kr       => fifo_bank_kr,
                re       => fifo_bank_re,
                empty_o  => fifo_bank_empty_o,
                full_o   => fifo_bank_full_o,
        
                 -- Data signals
                din      => address_A_out & ec_point,
                dout     => fifo_bank_dout          
        );                                         


        U_SIGNAL_SELECTOR: entity work.signal_selector
        generic map(
                        K => K
                   )
        port map(
                w_value => window_value,

                bucket_kempty => bucket_kempty_o,
                bucket_kbusy => bucket_kbusy_o,
                fifo_kfull => fifo_bank_full_o,
                fifo_kempty=> fifo_bank_empty_o,

                bucket_empty_b   => open,
                bucket_busy_b    => open,
                fifo_anyFull     => open,
                fifo_allWithElem => open,
                fifo_k_empty     => open
                );


--        U_FSM: entity work.FSM_global
--        port map(
--                clk                    => clk, 
--                rst                    => rst, 
--
--                start_MSM              => start_MSM, -- Esta senial deberia ser de la FIFO_intput_empty 
--
--                -- Loop 1 input signals=> ,
--                bucket_empty_bit       => , 
--                bucket_busy_bit        => , 
--                
--                fifo_k_empty_bit       => , 
--                fifo_some_full         => , 
--                fifo_all_element       => , 
--
--                    
--                -- Loop 2 input signals=> ,
--                w_count_done		 => , 
--                m_count_done		 => , 
--                u_count_done		 => , 
--                log_count_done         => , 
--                fifo_count_done        => , 
--                in_count_done          => , 
--                
--                padd_dv_in		  
--
--                -- Mixed signals
--                window_next             : out std_logic;
--                padd_status_out         : out std_logic_vector(3 downto 0);
--
--                padd_select_dinA        : out std_logic_vector(1 downto 0);
--                padd_select_dinB        : out std_logic_vector(2 downto 0);
--
--                -- Loop 1 output signals
--                done                    : out std_logic;
--                fifo_we                 : out std_logic; 
--                fifo_re                 : out std_logic; 
--                fifo_next               : out std_logic; 
--
--                empty_bit_out           : out std_logic; 
--                busy_bit_out            : out std_logic; 
--                bucket_web              : out std_logic;
--                point_next              : out std_logic;
--
--                -- Loop 2 output signals
--                u_next             : out std_logic;  
--                m_next             : out std_logic;
--                log_next           : out std_logic;
--                --addr_A_read_out    : out std_logic;
--                --addr_B_read_out    : out std_logic;
--                --data_A_select      : out std_logic;
--                --data_B_select      : out std_logic;
--                bucket_address_sel : out std_logic;
--                mem_address_sel : out std_logic;
--                aux_address_sel : out std_logic;
--
--                -- Loop 3 output signals
--                output_fifo_we : out std_logic
--    );



end Behavioral;
