library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.math_real.ALL;

use work.config.ALL;
use work.funciones.ALL;
use work.tipos.ALL;

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


        signal input_vector     : std_logic_vector(3*N_vect - 1 downto 0);
        signal G_z              : std_logic_vector(N_vect-1 downto 0) := zeros(N_vect - 1) & to_slv('1');

        constant M_in  : natural := 16384;  --16#40_00_00_00#; -- 2 ** 26
        constant M_out : natural := 22;

        signal all_data_received : std_logic;
        signal all_data_sent     : std_logic;
        signal run_out_counter   : std_logic;
        signal toggle_pulse      : std_logic;

        signal data_count   : std_logic_vector(ceil2power(M_out-1)-1 downto 0);

begin
        input_vector    <= G_z & G_y & G_x;

        U0_IN_DATA_COUNTER: entity work.mod_m_counter_prog
            generic map(
              M => M_in -- Modulo
              )   
            port map(
              clk_i       => clk,
              reset_i     => rst,
              run_i       => fifo_input_we,
              max_count_i => std_logic_vector(to_unsigned(M_in-1, ceil2power(M_in-1))),
              count_o     => open,
              max_o       => all_data_received
              );
        
        U1_TOGGLE_STATE: entity work.ToggleMachine
            port map(
              clk    => clk,
              rst    => rst,
              en     => VCC,
              sin    => toggle_pulse,
              toggle => run_out_counter
              );

        toggle_pulse <= all_data_received or all_data_sent;

        U1_OUT_DATA_COUNTER: entity work.mod_m_counter_prog
            generic map(
              M => M_out -- Modulo
              )   
            port map(
              clk_i       => clk,
              reset_i     => rst,
              run_i       => run_out_counter,
              max_count_i => std_logic_vector(to_unsigned(M_out-1, ceil2power(M_out-1))),
              count_o     => data_count,
              max_o       => all_data_sent
              );

        x   <= G_x(G_x'length-1 downto data_count'length) & data_count;
        y   <= G_y(G_y'length-1 downto data_count'length) & data_count;
        z   <= G_z(G_z'length-1 downto data_count'length) & data_count;

        data_valid <= run_out_counter;
        done <= run_out_counter and all_data_sent;

end Structural;
