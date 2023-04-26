library IEEE;
library XPM;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.math_real.ALL;

use xpm.vcomponents.ALL;

entity output_fifo is
    generic(
        N_esc   : natural := 253;  -- Operands bit size for x_n
        N_vect  : natural := 377;  -- Operands bit size for G_n
        C       : integer := 12;     
        U       : integer := 512;
        M       : integer := 8
    );
    port(
        clk, rst                : in std_logic;
        input_we                : in std_logic;
        input_re                : in std_logic;

        x_coord                 : in std_logic_vector(N_vect-1 downto 0);   --input coordinate X
        y_coord                 : in std_logic_vector(N_vect-1 downto 0);   --input coordinate Y
        z_coord                 : in std_logic_vector(N_vect-1 downto 0);   --input coordinate Y

        out_x_coord             : out std_logic_vector(N_vect-1 downto 0);   --output coordinate X
        out_y_coord             : out std_logic_vector(N_vect-1 downto 0);   --output coordinate Y
        out_z_coord             : out std_logic_vector(N_vect-1 downto 0);   --output coordinate Y

        flag_empty              : out std_logic;
        flag_full               : out std_logic;
        flag_rst_busy           : out std_logic;
        flag_almost_empty       : out std_logic
    );
end output_fifo;

architecture Behavioral of output_fifo is
            signal fifo_output_x_empty          : std_logic;
            signal fifo_output_x_full           : std_logic;
            signal fifo_output_x_almost_empty   : std_logic;
            signal fifo_output_x_wrst_busy      : std_logic;

            -- Las dejo definidas por las dudas. Mientras, uso solamente las seniales de la fifo de X
            signal fifo_output_y_empty          : std_logic;
            signal fifo_output_y_full           : std_logic;
            signal fifo_output_y_almost_empty   : std_logic;
            signal fifo_output_y_wrst_busy      : std_logic;

            signal fifo_output_z_empty          : std_logic;
            signal fifo_output_z_full           : std_logic;
            signal fifo_output_z_almost_empty   : std_logic;
            signal fifo_output_z_wrst_busy      : std_logic;
begin

        U_OUTPUT_FIFO_X: xpm_fifo_sync
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
            almost_empty    => fifo_output_x_almost_empty,
            almost_full     => open,
            data_valid      => open,
            dbiterr         => open,
            dout            => out_x_coord,
            empty           => fifo_output_x_empty,
            full            => fifo_output_x_full,
            overflow        => open,
            prog_empty      => open,
            prog_full       => open,
            rd_data_count   => open,
            rd_rst_busy     => open,
            sbiterr         => open,
            underflow       => open,
            wr_ack          => open,
            wr_data_count   => open,
            wr_rst_busy     => fifo_output_x_wrst_busy,
            din             => x_coord,
            injectdbiterr   => '0',
            injectsbiterr   => '0',
            rd_en           => input_re,
            rst             => rst,
            sleep           => '0',
            wr_clk          => clk,
            wr_en           => input_we 
        );

        U_OUTPUT_FIFO_Y: xpm_fifo_sync
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
            almost_empty    => fifo_output_y_almost_empty,
            almost_full     => open,
            data_valid      => open,
            dbiterr         => open,
            dout            => out_y_coord,
            empty           => fifo_output_y_empty,
            full            => fifo_output_y_full,
            overflow        => open,
            prog_empty      => open,
            prog_full       => open,
            rd_data_count   => open,
            rd_rst_busy     => open,
            sbiterr         => open,
            underflow       => open,
            wr_ack          => open,
            wr_data_count   => open,
            wr_rst_busy     => fifo_output_y_wrst_busy,
            din             => y_coord,
            injectdbiterr   => '0',
            injectsbiterr   => '0',
            rd_en           => input_re,
            rst             => rst,
            sleep           => '0',
            wr_clk          => clk,
            wr_en           => input_we 
        );

        U_OUTPUT_FIFO_Z: xpm_fifo_sync
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
            almost_empty    => fifo_output_z_almost_empty,
            almost_full     => open,
            data_valid      => open,
            dbiterr         => open,
            dout            => out_z_coord,
            empty           => fifo_output_z_empty,
            full            => fifo_output_z_full,
            overflow        => open,
            prog_empty      => open,
            prog_full       => open,
            rd_data_count   => open,
            rd_rst_busy     => open,
            sbiterr         => open,
            underflow       => open,
            wr_ack          => open,
            wr_data_count   => open,
            wr_rst_busy     => fifo_output_z_wrst_busy,
            din             => z_coord,
            injectdbiterr   => '0',
            injectsbiterr   => '0',
            rd_en           => input_re,
            rst             => rst,
            sleep           => '0',
            wr_clk          => clk,
            wr_en           => input_we 
        );

        flag_empty             <= fifo_output_x_empty; 
        flag_full              <= fifo_output_x_full; 
        flag_rst_busy          <= fifo_output_x_wrst_busy; 
        flag_almost_empty      <= fifo_output_x_almost_empty; 

end Behavioral;
