library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


use work.config.all;
use work.funciones.all;
use work.tipos.all;

use work.bucket_mem;
use work.point_adder_pip;
use work.fifo_bank;

entity arq_msm is
    generic(
        N_esc   : natural := N_esc;  -- Operands bit size for x_n
        N_vect  : natural := N_vect;  -- Operands bit size for G_n
        C : integer := 9      
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        --input: data x_n and G
        x_n : in std_logic_vector(N_esc-1 downto 0);    --scalar input
        G_x : in std_logic_vector(N_vect-1 downto 0);   --input coordinate X
        G_y : in std_logic_vector(N_vect-1 downto 0);   --input coordinate Y
        --output: x,y,x coordinates
        x   : out std_logic_vector(N_vect-1 downto 0);  --output coordinate X
        y   : out std_logic_vector(N_vect-1 downto 0);  --output coordinate Y
        z   : out std_logic_vector(N_vect-1 downto 0);  --output coordinate z
        dv  : out std_logic     -- data valid
    );
end entity;


architecture structural of arq_msm is

       --------------
       --Control bus 
       --------------    
       
       ----------------
       -- Bucket mem --
       ----------------   
       
        constant K_window_bucket : integer := 3; 
          
        signal bucket_clck  : std_logic; --clk 
        signal bucket_rst   : std_logic; --rst
        signal bucket_wea   : std_logic; --write enable A     
        signal bucket_web   : std_logic; --write enable B
        signal bucket_kwa   : std_logic_vector(ceil2power(K_window_bucket)-1 downto 0); --enable buffer A for write
        signal bucket_kra   : std_logic_vector(ceil2power(K_window_bucket)-1 downto 0); --enable buffer A for read
        signal bucket_kwb   : std_logic_vector(ceil2power(K_window_bucket)-1 downto 0); --enable buffer B for write
        signal bucket_krb   : std_logic_vector(ceil2power(K_window_bucket)-1 downto 0); --enable buffer B for read
        signal bucket_busya : std_logic_vector(K-1 downto 0);   -- Busy bit output for addressed K buckets - Port A
        signal bucket_busyb : std_logic_vector(K-1 downto 0);   -- Busy bit output for addressed K buckets - Port B
        signal bucket_emptya: std_logic_vector(K-1 downto 0);   -- Empty bit output for addressed K buckets - Port A
        signal bucket_emptyb: std_logic_vector(K-1 downto 0);   -- Empty bit output for addressed K buckets - Port B

                                  
        -- Point adder        
        signal pa_clk : std_logic; -- Point adder clock
        signal pa_rst : std_logic; -- Point adder reset
        signal pa_data_in_valid: std_logic; --Point adder data in valid
        signal pa_data_out_valid: std_logic; --Point adder data out valid
        
        -- FSM
        constant NWIDTH : natural := 5; --Width buckets
        
        -- INPUTS signals
        signal fsm_clk       : std_logic; -- FSM clock
        signal fsm_rst       : std_logic; -- FSM reset
        signal fsm_start     : std_logic; -- FSM start
        signal fsm_end_input : std_logic; -- FSM Finished processing all the points
        
        -- Buckets - Empty and busy bits
        signal fsm_empty_bin  : std_logic_vector(NWIDTH - 1 downto 0);
        signal fsm_busy_bin   : std_logic_vector(NWIDTH - 1 downto 0);
        
         -- 5-Counter
        signal fsm_counter    : std_logic_vector(NWIDTH - 1 downto 0);
        
        -- PADD finish signal 
        signal fsm_padd_finish : std_logic;
        
        -- FIFO inputs 
        signal fsm_fifo_full       : std_logic;
        signal fsm_all_fifos_empty : std_logic;
        
        -- OUTPUTS signal
        
        -- Signals for enables
        signal fsm_scalar_enable_in  : std_logic;
        signal fsm_point_enable_in   : std_logic;
        
         -- Scalar and window output.
         signal fsm_scalar_out : std_logic_vector (NWIDTH - 1 downto 0);
         signal fsm_counter_out :std_logic;
         
         -- FIFO outputs
         signal fsm_fifo_read   : std_logic_vector(NWIDTH - 1 downto 0);
         signal fsm_fifo_write  : std_logic_vector(NWIDTH - 1 downto 0);
        
        -- Bubble output
         signal fsm_bubble_sig : std_logic;

        -- Extra bits for memory
        signal fsm_busy_bit  : std_logic;
        signal fsm_empty_bit : std_logic;
        
        -- Memory outputs  
        signal fsm_mem_enable   : std_logic_vector(NWIDTH - 1 downto 0);
        signal fsm_mem_read     : std_logic_vector(NWIDTH - 1 downto 0);
        signal fsm_mem_write    : std_logic_vector(NWIDTH - 1 downto 0);
        signal fsm_mem_out      : std_logic_vector(NWIDTH - 1 downto 0);

       -- Loop 1 end signal
       signal fsm_finish_out : std_logic;    
       
       
       --FIIFO_Bank
       constant K : integer := integer(ceil(real(N_esc)/real(C))); 
       
       signal fifo_bank_clk     : std_logic; --clk
       signal fifo_bank_rst      : std_logic; --reset
       signal fifo_bank_kw       : std_logic_vector(ceil2power(K)-1 downto 0); --buffer write enable
       signal fifo_bank_we       : std_logic; --write enable
       signal fifo_bank_kr       : std_logic_vector(ceil2power(K)-1 downto 0); --buffer read enable 
       signal fifo_bank_re       : std_logic; --read enable
       signal fifo_bank_empty_o  : std_logic_vector(K-1 downto 0); --empty signal
       signal fifo_bank_full_o   : std_logic_vector(K-1 downto 0); --full signal
        
             
        -----------
        --Data bus
        -----------
        constant  DWIDTH_BUCKET : integer := 72*16;  --Address
        
        signal pa_op1 : point_t(2 downto 0);
        signal pa_op2 : point_t(2 downto 0);
        signal pa_r   : point_t(2 downto 0);
       
        signal bucket_dina : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in A
        signal bucket_dinb : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data in B      
        signal bucket_douta : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out A
        signal bucket_doutb : std_logic_vector (DWIDTH_BUCKET-1 downto 0); -- Data out B
        
        -- Point adder 
        -- P1
        signal pa_x1 : std_logic_vector (N_vect-1 downto 0); -- Point adder X1
        signal pa_y1 : std_logic_vector (N_vect-1 downto 0); -- Point adder Y1
        signal pa_z1 : std_logic_vector (N_vect-1 downto 0); -- Point adder Z1
        
        -- P2 
        signal pa_x2 : std_logic_vector (N_vect-1 downto 0); -- Point adder X2
        signal pa_y2 : std_logic_vector (N_vect-1 downto 0); -- Point adder Y2
        signal pa_z2 : std_logic_vector (N_vect-1 downto 0); -- Point adder Z2
        
        -- R
        signal pa_xr : std_logic_vector (N_vect-1 downto 0); -- Point adder Xr
        signal pa_yr : std_logic_vector (N_vect-1 downto 0); -- Point adder Yr
        signal pa_zr : std_logic_vector (N_vect-1 downto 0); -- Point adder Zr
        
        
        --FIIFO_Bank
        constant DWIDTH_FIFO_B : integer := 3*N_vect + c;
        
        signal fifo_bank_din   : std_logic_vector (DWIDTH_FIFO_B-1 downto 0); -- Data in
        signal fifo_bank_dout  : std_logic_vector (DWIDTH_FIFO_B-1 downto 0); -- Data out
        
       
        --------------
        --Address bus
        --------------
        
        -- Bucket_mem
        constant  AWIDTH_BUCKET : integer := N_esc;  --Address
       
        signal bucket_addra : std_logic_vector (AWIDTH_BUCKET-1 downto 0); -- Address A
        signal bucket_addrb : std_logic_vector (AWIDTH_BUCKET-1 downto 0); -- Address B
        
        -- URAM
        constant  AWIDTH_URAM : integer := 12;  --Address
        
        signal uram_addra : std_logic_vector (AWIDTH_URAM-1 downto 0); -- Address A
        signal uram_addrb : std_logic_vector (AWIDTH_URAM-1 downto 0); -- Address B
        
        signal zero_point : std_logic_vector(DWIDTH_BUCKET-1 downto 0) := (others => '0');

begin

    pa_op2 <= to_point_t(bucket_douta) when fsm_bubble_sig='1' else
              to_point_t(zero_point);
    
    -- PA to Bucket_mem        
    bucket_dina <= (DWIDTH_BUCKET-1 downto (3*pa_r(0)'length) => '0') & (pa_r(0) & pa_r(1) & pa_r(2));
    
    
    
    U_POINT_ADDER: entity point_adder_pip
        port map(
            clk     => clk,
            rst     => rst,
    
            data_in_valid   => pa_data_in_valid,
            data_out_valid  => pa_data_out_valid,
            -- P1
            x1  => pa_op1(0),
            y1  => pa_op1(1),
            z1  => pa_op1(2),
            -- P2 
            x2  => pa_op2(0),
            y2  => pa_op2(1),
            z2  => pa_op2(2),
            -- R
            xr  => pa_r(0),
            yr  => pa_r(1),
            zr  => pa_r(2)
        );                                         

    U_BUCKET_MEM: entity work.bucket_mem
    generic map(
        K      => integer(ceil(real(N_esc)/real(C))),   -- 29 Frames  
        DWIDTH => 72 * 16,  -- 72*16N -- Data Width
        AWIDTH => N_esc     -- 253 Address Width
      )
    port map(
        clk   => clk,         -- Clock
        rst   => rst,         -- Reset
        -- Port A
        wea   => bucket_wea,    -- Write Enable - Port A
        dina  => bucket_dina,   -- Data Input - Port A
        addra => bucket_addra,  -- Address Input - Port A
        douta => bucket_douta,  -- Data Output - Port A
        kwa   => bucket_kwa,    -- K select for write - Port A
        kra   => bucket_kra,    -- K select for read - Port A
        -- Port B
        web   => bucket_web,    -- Write Enable - Port B
        dinb  => bucket_dinb,   -- Data Input - Port B
        addrb => bucket_addrb,  -- Address Input - Port B
        doutb => bucket_doutb,  -- Data Output - Port B
        kwb   => bucket_kwb,    -- K select for write - Port B
        krb   => bucket_krb,    -- K select for read - Port A
        -- Flags
        busya_o  => bucket_busya,   -- Busy bit output for addressed K buckets - Port A
        busyb_o  => bucket_busyb,   -- Busy bit output for addressed K buckets - Port B
        emptya_o => bucket_emptya,  -- Empty bit output for addressed K buckets - Port A
        emptyb_o => bucket_emptyb   -- Empty bit output for addressed K buckets - Port B
    );                
 
  U_FIFO_BANK: entity fifo_bank
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

                                                                     
end architecture;
