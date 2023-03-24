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
use work.Controller;

entity msm_architecture is
    generic(
        N_esc   : natural := N_esc;  -- Operands bit size for x_n
        N_vect  : natural := N_vect;  -- Operands bit size for G_n
        C : integer := 12;     
        U : integer := 512;
        M : integer := 8
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        --input: data x_n and G

        x_n : in std_logic_vector(N_esc-1 downto 0);    --scalar input
        G_x : in std_logic_vector(N_vect-1 downto 0);   --input coordinate X
        G_y : in std_logic_vector(N_vect-1 downto 0);   --input coordinate Y
        --output: x,y,x coordinates

        fifo_input_we : in std_logic;

        x   : out std_logic_vector(N_vect-1 downto 0);  --output coordinate X
        y   : out std_logic_vector(N_vect-1 downto 0);  --output coordinate Y
        z   : out std_logic_vector(N_vect-1 downto 0);  --output coordinate z
        data_valid  : out std_logic;     -- data valid
        done  : out std_logic     -- data valid
    );

end msm_architecture;

architecture Structural of msm_architecture is

        type array_xn is array(natural range<>) of std_logic_vector(C-1 downto 0);
        signal array_xn_k : array_xn(K-1 downto 0);

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        -- Constants

        constant DWIDTH_BUCKET  : integer := 72*16;
        constant DWIDTH_FIFO_B  : integer := 3*N_vect + c;
        constant AWIDTH_BUCKET  : integer := N_esc;

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
        signal bucket_busya     : std_logic_vector(K-1 downto 0);
        signal bucket_busyb     : std_logic_vector(K-1 downto 0);
        signal bucket_emptya    : std_logic_vector(K-1 downto 0);
        signal bucket_emptyb    : std_logic_vector(K-1 downto 0);

        signal bucket_state     : std_logic_vector(1 downto 0);
        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        -- Data
        signal pa_op1           : point_t(2 downto 0);
        signal pa_op2           : point_t(2 downto 0);
        signal pa_r             : point_t(2 downto 0);

        signal input_dout       : point_t(2 downto 0);
        signal input_vector     : std_logic_vector(3*N_vect - 1 downto 0);

        signal bucket_dina      : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in A
        signal bucket_dinb      : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in B      
        signal bucket_douta     : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out A
        signal bucket_doutb     : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out B

        signal fifo_bank_din    : std_logic_vector (DWIDTH_FIFO_B-1 downto 0); -- Data in
        signal fifo_bank_dout   : std_logic_vector (DWIDTH_FIFO_B-1 downto 0); -- Data out

        signal fifo_bank_kw     : std_logic_vector(ceil2power(K)-1 downto 0);
        signal fifo_bank_we     : std_logic;
        signal fifo_bank_kr     : std_logic_vector(ceil2power(K)-1 downto 0);
        signal fifo_bank_re     : std_logic;
        signal fifo_bank_empty_o: std_logic_vector(K-1 downto 0);
        signal fifo_bank_full_o : std_logic_vector(K-1 downto 0);


        signal fifo_input_dout      : std_logic_vector(2*N_vect + N_esc - 1 downto 0);
        signal fifo_input_din       : std_logic_vector(2*N_vect + N_esc - 1 downto 0);
        signal fifo_input_empty     : std_logic;
        signal fifo_input_full      : std_logic;
        signal fifo_input_re        : std_logic;
        
        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        -- Memory signals
        signal mem_dina         : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in A
        signal mem_dinb         : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in B      
        signal mem_douta        : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out A
        signal mem_doutb        : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out A
        signal mem_addra        : std_logic_vector (C-1 downto 0); 
        signal mem_addrb        : std_logic_vector (C-1 downto 0); 
        
        signal mem_wea          : std_logic;
        signal mem_web          : std_logic;

        signal G_z              : std_logic_vector(N_vect-1 downto 0) := zeros(N_vect - 1) & to_slv('1');
        signal zero_point       : std_logic_vector(DWIDTH_BUCKET-1 downto 0) := (others => '0');

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        -- Control

        signal window_value     : std_logic_vector(ceil2power(K) - 1 downto 0);
        signal segment_value    : std_logic_vector(ceil2power(M - 1) - 1 downto 0);
        signal element_value    : std_logic_vector(ceil2power(U - 1) - 1 downto 0);

        signal pa_data_in_valid : std_logic;
        signal pa_data_out_valid: std_logic;
        signal pa_controlBits   : std_logic_vector(0 downto 0);

        signal pa_op2_sel       : std_logic_vector(1 downto 0);
        signal pa_op1_sel       : std_logic;

        signal package_signals  : std_logic_vector(ceil2power(K) + C +1 downto 0);
        signal package_signals_o: std_logic_vector(ceil2power(K) + C +1 downto 0);

        signal input_fifo_next  : std_logic;
        signal input_fifo_start : std_logic;

        signal memory_bucket_wr : std_logic_vector(1 downto 0);
        signal bucket_mem_sel   : std_logic;

        signal sel_address_A    : std_logic_vector(1 downto 0);
        signal sel_address_B    : std_logic_vector(2 downto 0);

        signal address_A_out : std_logic_vector(C - 1 downto 0);
        signal address_B_out : std_logic_vector(C - 1 downto 0);
begin

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        -- FIFO de entrada

        fifo_input_din  <= x_n & G_y & G_x;
        input_vector    <= G_z & fifo_input_dout(2*N_vect - 1 downto 0);

        U_INPUT_FIFO: xpm_fifo_sync
        generic map (
            CASCADE_HEIGHT      => 0,       -- DECIMAL
            DOUT_RESET_VALUE    => "0",     -- String
            ECC_MODE            => "no_ecc",-- String
            FIFO_MEMORY_TYPE    => "auto",  -- String
            FIFO_READ_LATENCY   => 1,       -- DECIMAL
            FIFO_WRITE_DEPTH    => 16,      -- DECIMAL
            FULL_RESET_VALUE    => 0,       -- DECIMAL
            PROG_EMPTY_THRESH   => 3,       -- DECIMAL
            PROG_FULL_THRESH    => 10,      -- DECIMAL
            RD_DATA_COUNT_WIDTH => 1,       -- DECIMAL
            READ_DATA_WIDTH     => 2*N_vect + N_esc,  -- DECIMAL
            READ_MODE           => "std",   -- String
            SIM_ASSERT_CHK      => 0,       -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
            USE_ADV_FEATURES    => "0707",  -- String
            WAKEUP_TIME         => 0,       -- DECIMAL
            WRITE_DATA_WIDTH    => 2*N_vect + N_esc,  -- DECIMAL
            WR_DATA_COUNT_WIDTH => 1        -- DECIMAL
            )
        port map (
            almost_empty    => open,
            almost_full     => open,
            data_valid      => open,
            dbiterr         => open,
            dout            => fifo_input_dout,
            empty           => fifo_input_empty,
            full            => fifo_input_full,
            overflow        => open,
            prog_empty      => open,
            prog_full       => open,
            rd_data_count   => open,
            rd_rst_busy     => open,
            sbiterr         => open,
            underflow       => open,
            wr_ack          => open,
            wr_data_count   => open,
            wr_rst_busy     => open,
            din             => fifo_input_din,
            injectdbiterr   => '0',
            injectsbiterr   => '0',
            rd_en           => fifo_input_re,
            rst             => rst,
            sleep           => '0',
            wr_clk          => clk,
            wr_en           => fifo_input_we
        );


        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        
        process(pa_op1_sel, bucket_doutb, mem_douta)
        begin
        case pa_op1_sel is
                when '0'        => pa_op1 <= to_point_t_threeCoords(bucket_doutb);
                when others     => pa_op1 <= to_point_t_threeCoords(mem_douta);
        end case;
        end process;

        process(pa_op2_sel, mem_doutb, input_vector, zero_point, fifo_bank_dout, bucket_doutb)
        begin
                case pa_op2_sel is
                        when "00"       => pa_op2 <= to_point_t_threeCoords(input_vector); 
                        when "01"       => pa_op2 <= to_point_t_threeCoords(mem_doutb);
                        when "10"       => pa_op2 <= to_point_t_threeCoords(fifo_bank_dout); 
                        when others     => pa_op2 <= to_point_t_threeCoords(bucket_doutb);
                end case;
        end process;

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

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        
        process(fifo_bank_re, address_A_out, fifo_bank_dout)
        begin
                case fifo_bank_re is
                        when '0'        => bucket_addrb <= address_A_out;
                        when others     => bucket_addrb <= fifo_bank_dout(fifo_bank_dout'length - 1 downto 3*377);
                end case;
        end process;
        


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
                douta       => bucket_douta,  -- Data Output - Port A
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
                busya_o     => bucket_busya,   -- Busy bit output for addressed K buckets - Port A
                busyb_o     => bucket_busyb,   -- Busy bit output for addressed K buckets - Port B
                emptya_o    => bucket_emptya,  -- Empty bit output for addressed K buckets - Port A
                emptyb_o    => bucket_emptyb   -- Empty bit output for addressed K buckets - Port B
        );                

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------
        
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
                douta   => mem_douta,
                dinb    => mem_dinb,
                addrb   => mem_addrb,
                doutb   => mem_doutb
        );
        
        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

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
                din      => fifo_bank_din,
                dout     => fifo_bank_dout          
        );                                         

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        U_CONTROLLER: entity work.Controller
        generic map(
                K => K,
                U => U,
                M => M,
                SCALAR_SIZE => N_esc,
                C => C,
                FIFO_WRITE_SIZE => 16)
        port map(
                clk             => clk,
                rst             => rst,

                start_MSM       => input_fifo_start,
                busyb_in        => bucket_busyb,
                emptyb_in       => bucket_emptyb,
                empty_fifo_in   => fifo_bank_empty_o,
                full_fifo_in    => fifo_bank_full_o,
                padd_dv_in      => pa_data_out_valid,

                w_value_out     => window_value,
                u_value_out     => element_value,
                m_value_out     => segment_value,

                fifo_re_out     => fifo_bank_re,
                fifo_we_out     => fifo_bank_we,
                
                bucket_web_out  => bucket_web,
                bucket_emptyB   => bucket_state(0),
                bucket_busyB    => bucket_state(1),

                point_sel_out   => open,
                point_next      => input_fifo_next,
                padd_dv_out     => pa_data_in_valid,

                addr_A_out      => sel_address_A,
                addr_B_out      => sel_address_B,

                loop_process    => bucket_mem_sel,
                op_selector_A   => pa_op1_sel,
                op_selector_B   => pa_op2_sel,

                data_valid_out  => data_valid,
                done            => done
        );

        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        U_SCALAR_PROPAGATION: entity work.delay_M
        generic map(
                WORD_WIDTH      => ceil2power(K) + C + 2,
                DELAY           => 55
        )
        port map(
                clk => clk,
                rst => rst,
                s => package_signals,
                s_delayed => package_signals_o
        );

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
                x_n     => fifo_input_dout(fifo_input_dout'length - 1 downto 2*N_vect),
                K       => window_value,
                M       => segment_value,
                U       => element_value,

                select_loop => '1',
                select_addr_A => sel_address_A,
                select_addr_B => sel_address_B,

                address_out_A => address_A_out,
                address_out_B => address_B_out
        ); 
        
        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        process(package_signals_o, pa_data_out_valid, mem_addra, address_A_out)
        begin
                if package_signals_o(package_signals_o'length - 1) = '0' then
                        mem_addra <= address_A_out;
                else
                        mem_addra <= package_signals_o(package_signals_o'length - 3 downto ceil2power(K));
                end if;
        end process;

        mem_addrb <= address_B_out;
        
        -----------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------

        bucket_wea <= memory_bucket_wr(0);
        mem_wea <= memory_bucket_wr(1);

        process(package_signals_o, pa_data_out_valid)
        begin
                if package_signals_o(package_signals_o'length - 1) = '0' then
                        memory_bucket_wr(0) <= package_signals_o(package_signals_o'length - 2);
                        memory_bucket_wr(1) <= '0';
                else
                        memory_bucket_wr(0) <= '0';
                        memory_bucket_wr(1) <= package_signals_o(package_signals_o'length - 2);
                end if;
        end process;

        mem_dina <= (DWIDTH_BUCKET - 1 downto (3*G_x'length) => '0') & (pa_r(2) & pa_r(1) & pa_r(0));

        fifo_bank_din   <= address_A_out & input_vector;

        fifo_bank_kr    <= window_value;
        fifo_bank_kw    <= window_value;

        bucket_addra    <= package_signals_o(package_signals_o'length - 3 downto ceil2power(K));
        bucket_kwa      <= package_signals_o(ceil2power(K) - 1 downto 0);

        package_signals <= bucket_mem_sel & pa_data_in_valid & address_A_out & window_value;

        bucket_kwb      <= window_value;
        bucket_krb      <= window_value;

        bucket_dina      <= (DWIDTH_BUCKET - 1 downto (3*G_x'length) => '0') & (pa_r(2) & pa_r(1) & pa_r(0));
        bucket_dinb      <= bucket_state & (DWIDTH_BUCKET - 3 downto (3*G_x'length) => '0') & input_vector; 

        fifo_input_re   <= input_fifo_next;
        input_fifo_start <= not fifo_input_empty;

        x               <= mem_douta(N_vect - 1 downto 0);
        y               <= mem_douta(2*N_vect - 1 downto N_vect);
        z               <= mem_douta(3*N_vect - 1 downto 2*N_vect);

end Structural;
