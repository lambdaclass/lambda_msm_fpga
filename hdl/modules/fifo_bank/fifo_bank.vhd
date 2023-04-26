library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library xpm;
use xpm.vcomponents.all;

-- Defines N (number of bits) and q prime: 
use work.config.all;
use work.funciones.all;

entity fifo_bank is
    generic(
        K       : integer := integer(ceil(real(N_esc)/real(c)));
        DWIDTH  : integer := 3*N_vect + c 
    );
    port(
        clk     : in std_logic;
        rst     : in std_logic;
        din     : in std_logic_vector(DWIDTH-1 downto 0);
        kw      : in std_logic_vector(ceil2power(K)-1 downto 0);
        we      : in std_logic;
        kr      : in std_logic_vector(ceil2power(K)-1 downto 0);
        re      : in std_logic;

        dout    : out std_logic_vector(DWIDTH-1 downto 0);
        empty_o : out std_logic_vector(K-1 downto 0);
        full_o  : out std_logic_vector(K-1 downto 0)
    );
end entity;

architecture rtl of fifo_bank is

    type out_bus is array(natural range<>) of std_logic_vector(DWIDTH-1 downto 0);
    signal dout_k   : out_bus(K-1 downto 0);
    signal we_k     : std_logic_vector(K-1 downto 0);

    signal empty_o_tmp          : std_logic_vector(K-1 downto 0);
    signal empty_delay_flag     : std_logic;
begin

    U1A_WEA_DECODER: process(kw, we)
    begin
        we_k <= (others => '0');   -- default
        we_k(to_integer(unsigned(kw))) <= we;
    end process;

    U_FIFO_BANK: for i in 0 to K-1 generate

        -- xpm_fifo_sync: Synchronous FIFO
        -- Xilinx Parameterized Macro, version 2022.2

        xpm_fifo_sync_inst : xpm_fifo_sync
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
            RD_DATA_COUNT_WIDTH => 5,       -- DECIMAL
            READ_DATA_WIDTH     => DWIDTH,  -- DECIMAL
            READ_MODE           => "std",   -- String
            SIM_ASSERT_CHK      => 0,       -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
            USE_ADV_FEATURES    => "0707",  -- String
            WAKEUP_TIME         => 0,       -- DECIMAL
            WRITE_DATA_WIDTH    => DWIDTH,  -- DECIMAL
            WR_DATA_COUNT_WIDTH => 5        -- DECIMAL
            )
        port map (
            almost_empty    => open,
            almost_full     => open,
            data_valid      => open,
            dbiterr         => open,
            dout            => dout_k(i),
            empty           => empty_o_tmp(i),
            full            => full_o(i),
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
            din             => din,
            injectdbiterr   => '0',
            injectsbiterr   => '0',
            rd_en           => re,
            rst             => rst,
            sleep           => '0',
            wr_clk          => clk,
            wr_en           => we_k(i)
        );
    end generate;

    empty_delay_flag <= clk and re;

    EMPTY_FLAGS_DELAY: entity work.delay_1
    generic map(
    WORD_WIDTH => K
               )
    port map(
        clk => empty_delay_flag,
        rst => rst, 

        s => empty_o_tmp,
        s_delayed => empty_o
                );


    U2A_DOUT_MUX: process(kr, dout_k)
    begin
        dout <= dout_k(to_integer(unsigned(kr)));
    end process;

end architecture;
