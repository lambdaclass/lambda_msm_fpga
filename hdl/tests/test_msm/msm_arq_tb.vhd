library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use ieee.numeric_std.all;
use ieee.math_real.all;
use work.msm_architecture;
use work.funciones.all;
use work.config.all;
use work.tipos.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity msm_arq_tb is
end msm_arq_tb;

architecture tb of msm_arq_tb is

        constant CLK_PERIOD : time := 5 ns;
        constant RST_PERIOD : time := CLK_PERIOD * 5 + 1 ps;

        file file_SCALARS : text;

        signal gx_input_signal  : std_logic_vector(N_vect - 1 downto 0);
        signal gy_input_signal  : std_logic_vector(N_vect - 1 downto 0);
        signal xn_input_signal  : std_logic_vector(N_esc - 1 downto 0);

        signal clk_in_signal    : std_logic;
        signal rst_in_signal    : std_logic;
        signal fifo_in_signal   : std_logic;

        signal fifo_in_full     : std_logic;

        signal x_output_signal  : std_logic_vector(N_vect - 1 downto 0);
        signal y_output_signal  : std_logic_vector(N_vect - 1 downto 0);
        signal z_output_signal  : std_logic_vector(N_vect - 1 downto 0);
        
        signal dv_output_signal : std_logic;
        signal done_out_signal  : std_logic;

begin

        DUT : entity work.msm_architecture
                port map(
                        clk => clk_in_signal,
                        rst => rst_in_signal,

                        x_n => xn_input_signal,
                        G_x => gx_input_signal,
                        G_y => gy_input_signal,

                        fifo_input_we => fifo_in_signal,
                        fifo_input_full => fifo_in_full,

                        x => x_output_signal,
                        y => y_output_signal,
                        z => z_output_signal,

                        data_valid => dv_output_signal,
                        done    => done_out_signal
                );

        READ_IO : process

                variable v_ILINE : line;
                variable xn      : std_logic_vector(N_esc - 1 downto 0);

        begin

                file_open(file_SCALARS, "./scalars", read_mode);
                while not endfile(file_SCALARS) loop
                        readline(file_SCALARS, v_ILINE);
                        read(v_ILINE, xn);

                        xn_input_signal <= xn;
                        wait for CLK_PERIOD;

                end loop;

                file_close(file_SCALARS);
        end process;

        CLK_PROC : process
        begin
                clk_in_signal <= '1';
                wait for CLK_PERIOD/2;
                clk_in_signal <= '0';
                wait for CLK_PERIOD/2;
        end process;


        stimulus : process
        begin
                rst_in_signal <= '1';
                wait for 2*RST_PERIOD;
                rst_in_signal <= '0';
                for i in 0 to 10 loop
                        for j in 0 to K - 1 loop
                                if fifo_in_full = '1' then 
                                        wait until fifo_in_full = '0';

                                        gx_input_signal <= std_logic_vector(to_unsigned(2*K*i + 1, N_vect));
                                        gy_input_signal <= std_logic_vector(to_unsigned(2*K*j + 1, N_vect));

                                        fifo_in_signal <= '1';
                                        wait for CLK_PERIOD;

                                else
                                        gx_input_signal <= std_logic_vector(to_unsigned(2*K*i + 1, N_vect));
                                        gy_input_signal <= std_logic_vector(to_unsigned(2*K*j + 1, N_vect));

                                        fifo_in_signal <= '1';
                                        wait for CLK_PERIOD;
                                end if;
                        end loop;
                end loop;
        end process;



end tb;
