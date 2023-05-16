library IEEE;
library XPM;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.math_real.ALL;

use work.tipos.ALL;
use work.config.ALL;
use work.funciones.ALL;
use xpm.vcomponents.ALL;

entity generic_fifo is
    generic(
        N_vect  : natural := 377;  -- Operands bit size for G_n
        NUMBER_FIFOS : natural := 3
    );
    port(
        clk, rst                : in std_logic;

        debug_counter_rd        : out std_logic_vector(ceil2power(16) - 1 downto 0);
        debug_counter_wr        : out std_logic_vector(ceil2power(16) - 1 downto 0);
        fifo_in                 : in fifo_in_t;
        fifo_out                : out fifo_out_t
    );
end generic_fifo;

architecture Behavioral of generic_fifo is
        type data is array(natural range<>) of std_logic_vector(N_vect - 1 downto 0);

        signal empty_o_tmp : std_logic_vector(NUMBER_FIFOS - 1 downto 0);
        signal full_o_tmp : std_logic_vector(NUMBER_FIFOS - 1 downto 0);
        signal almostempty_o_tmp : std_logic_vector(NUMBER_FIFOS - 1 downto 0);
        signal almostfull_o_tmp : std_logic_vector(NUMBER_FIFOS - 1 downto 0);
        signal wrrst_o_tmp : std_logic_vector(NUMBER_FIFOS - 1 downto 0);

        signal fifo_data_out : data(NUMBER_FIFOS - 1 downto 0);
        signal fifo_data_in : data(NUMBER_FIFOS - 1 downto 0);

begin

        fifo_data_in(0) <= fifo_in.din_x;
        fifo_data_in(1) <= fifo_in.din_y;
        fifo_data_in(2) <= fifo_in.din_z;

        U_COORD_FIFO: for i in 0 to NUMBER_FIFOS - 1 generate
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
                    READ_DATA_WIDTH     => N_vect,  -- DECIMAL
                    READ_MODE           => "std",   -- String
                    SIM_ASSERT_CHK      => 0,       -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                    USE_ADV_FEATURES    => "0707",  -- String
                    WAKEUP_TIME         => 0,       -- DECIMAL
                    WRITE_DATA_WIDTH    => N_vect,  -- DECIMAL
                    WR_DATA_COUNT_WIDTH => 5        -- DECIMAL
                    )
                port map (
                    almost_empty    => open,
                    almost_full     => open,
                    data_valid      => open,
                    dbiterr         => open,
                    dout            => fifo_data_out(i),
                    empty           => empty_o_tmp(i),
                    full            => full_o_tmp(i),
                    overflow        => open,
                    prog_empty      => almostempty_o_tmp(i),
                    prog_full       => almostfull_o_tmp(i),
                    rd_data_count   => debug_counter_rd,
                    rd_rst_busy     => open,
                    sbiterr         => open,
                    underflow       => open,
                    wr_ack          => open,
                    wr_data_count   => debug_counter_wr,
                    wr_rst_busy     => wrrst_o_tmp(i),
                    din             => fifo_data_in(i),
                    injectdbiterr   => '0',
                    injectsbiterr   => '0',
                    rd_en           => fifo_in.re,
                    rst             => rst,
                    sleep           => '0',
                    wr_clk          => clk,
                    wr_en           => fifo_in.we
                );
        end generate;

        fifo_out <= (fifo_data_out(0),fifo_data_out(1),fifo_data_out(2), empty_o_tmp(0), full_o_tmp(0), almostempty_o_tmp(0), almostfull_o_tmp(0), wrrst_o_tmp(0));

end Behavioral;
