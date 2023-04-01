library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.config.ALL;
use work.axi_local_config.ALL;
use work.funciones.ALL;
use work.tipos.ALL;

entity msm_axis_wrapper is
    generic(
        C : integer := 12;     
        U : integer := 512;
        M : integer := 8
    );
    port (
        -- AXI-Stream Slave Inputs
        -- x_n
        s00_axis_tdata   : in  std_logic_vector(N_esc_axi - 1 downto 0);
        s00_axis_tvalid  : in  std_logic;
        s00_axis_tlast   : in  std_logic;

        -- G_x
        s01_axis_tdata   : in  std_logic_vector(N_vect_axi - 1 downto 0);
        s01_axis_tvalid  : in  std_logic;
        s01_axis_tlast   : in  std_logic;

        -- G_y
        s02_axis_tdata   : in  std_logic_vector(N_vect_axi - 1 downto 0);
        s02_axis_tvalid  : in  std_logic;
        s02_axis_tlast   : in  std_logic;

        -- AXI-Stream Master Outputs
        -- R_x
        m00_axis_tdata   : out std_logic_vector(N_vect_axi - 1 downto 0);
        m00_axis_tvalid  : out std_logic;

        -- R_y
        m01_axis_tdata   : out std_logic_vector(N_vect_axi - 1 downto 0);
        m01_axis_tvalid  : out std_logic;

        -- R_z
        m02_axis_tdata   : out std_logic_vector(N_vect_axi - 1 downto 0);
        m02_axis_tvalid  : out std_logic;
        -- System Clock and Reset
        clk              : in  std_logic;
        rst              : in  std_logic
    );
end entity msm_axis_wrapper;

architecture rtl of msm_axis_wrapper is

    
    -- Internal signals
    signal x_n        : std_logic_vector(N_esc - 1 downto 0);
    signal G_x        : std_logic_vector(N_vect - 1 downto 0);
    signal G_y        : std_logic_vector(N_vect - 1 downto 0);
    signal fifo_input_we  : std_logic;
    signal x          : std_logic_vector(N_vect - 1 downto 0);
    signal y          : std_logic_vector(N_vect - 1 downto 0);
    signal z          : std_logic_vector(N_vect - 1 downto 0);
    signal data_valid : std_logic;
    signal done       : std_logic;

begin

    -- Instantiate the original entity
    u_msm_architecture : entity work.msm_architecture
        generic map (
            N_esc => N_esc,
            N_vect => N_vect,
            C => C,
            U => U,
            M => M
        )
        port map (
            clk => clk,
            rst => rst,
            x_n => s00_axis_tdata(N_esc-1 downto 0),
            G_x => s01_axis_tdata(N_vect-1 downto 0),
            G_y => s02_axis_tdata(N_vect-1 downto 0),
            fifo_input_we => s00_axis_tvalid,
            x => m00_axis_tdata(N_vect-1 downto 0),
            y => m01_axis_tdata(N_vect-1 downto 0),
            z => m02_axis_tdata(N_vect-1 downto 0),
            data_valid  => data_valid,
            done  => done
        );

    m00_axis_tvalid <= data_valid;
    m01_axis_tvalid <= data_valid;
    m02_axis_tvalid <= data_valid;

end architecture;