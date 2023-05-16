library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;

entity msm_tb is 
end msm_tb;

architecture tb of msm_tb is

        constant N_vect : natural := 377;
        constant N_esc  : natural := 253;
        constant CLK_PERIOD : time := 10 ns;

        file scalars : text open read_mode is "./dummy_scalars";
        signal clk_i : std_logic;
        signal rst_i : std_logic;

        signal in_write_in : std_logic;
        signal G_x_in : std_logic_vector(N_vect - 1 downto 0);
        signal G_y_in : std_logic_vector(N_vect - 1 downto 0);
        signal x_n_in : std_logic_vector(N_esc - 1 downto 0);

        signal out_x_out : std_logic_vector(N_vect - 1 downto 0);
        signal out_y_out : std_logic_vector(N_vect - 1 downto 0);
        signal out_z_out : std_logic_vector(N_vect - 1 downto 0);

        signal out_read_out : std_logic;

        signal output_flag_empty_out : std_logic;
        signal output_flag_full_out : std_logic;
        signal output_flag_rst_busy_out : std_logic;
        signal output_flag_almost_empty_out : std_logic;

        signal input_flag_empty_out  : std_logic;
        signal input_flag_full_out : std_logic;
        signal input_flag_rst_busy_out : std_logic;
        signal input_flag_almost_empty_out : std_logic;

begin
        
        DUT : entity work.msm
                generic map(
                    N_esc   => N_esc,
                    N_vect  => N_vect,
                    C       => 12,
                    U       => 512,
                    N       => 100,
                    M       => 8
                )
                port map(
                    clk          => clk_i,
                    rst          => rst_i,

                    in_write     => in_write_in,             
                    G_x          => G_x_in,
                    G_y          => G_y_in,
                    x_n          => x_n_in,

                    out_x        => out_x_out,
                    out_y        => out_y_out,
                    out_z        => out_z_out,
                                               
                    out_read     => out_read_out, 
                    
                    output_flag_empty         =>  output_flag_empty_out,
                    output_flag_full          =>  output_flag_full_out,
                    output_flag_rst_busy      =>  output_flag_rst_busy_out,
                    output_flag_almost_empty  =>  output_flag_almost_empty_out,
                                                                              
                    input_flag_empty          =>  input_flag_empty_out,
                    input_flag_full           =>  input_flag_full_out,
                    input_flag_rst_busy       =>  input_flag_rst_busy_out,
                    input_flag_almost_empty   =>  input_flag_almost_empty_out 
                );

        CLK : process
        begin
                clk_i <= '0';
                wait for CLK_PERIOD/2;
                clk_i <= '1';
                wait for CLK_PERIOD/2;
        end process;

--        READ_IO : process
--
--        variable linea : line;
--        variable xn_t : std_logic_vector(N_esc - 1 downto 0);
--
--        begin
--                in_write_in <= '0';
--                rst_i <= '1';
--                wait for 2*CLK_PERIOD;
--                rst_i <= '0';
--                wait for 2*CLK_PERIOD;
--                for i in 0 to 10 loop 
--                        if input_flag_full_out = '1' then
--                                in_write_in <= '0';
--                                wait until input_flag_almost_empty_out = '1';
--                        end if;
--
--                        readline(scalars, linea);
--                        read(linea, xn_t);
--
--                        G_x_in <= std_logic_vector(to_unsigned(2*i, N_vect));
--                        G_y_in <= std_logic_vector(to_unsigned(2*i, N_vect));
--                        x_n_in <= std_logic_vector(xn_t);
--
--                        in_write_in <= '1';
--                        wait for CLK_PERIOD;
--                end loop;
--
--                in_write_in <= '0';
--
--                wait for 2 ms;
--        end process;

        COLLISIONS: process
        begin
                in_write_in <= '0';
                rst_i <= '1';
                wait for 2*CLK_PERIOD;
                rst_i <= '0';
                wait for 2*CLK_PERIOD;

                for i in 0 to 10 loop 
                        G_x_in <= std_logic_vector(to_unsigned(2*i, N_vect));
                        G_y_in <= std_logic_vector(to_unsigned(2*i, N_vect));
                        for r in 0 to 10 loop 
                                if input_flag_full_out = '1' then
                                        in_write_in <= '0';
                                        wait until input_flag_almost_empty_out = '1';
                                end if;

                                if input_flag_rst_busy_out = '1' then
                                        wait until input_flag_rst_busy_out = '0';
                                end if;
                                --readline(scalars, linea);
                                --read(linea, xn_t);

                                x_n_in <= std_logic_vector(to_unsigned(r, N_esc));
                                --x_n_in <= std_logic_vector(xn_t);

                                in_write_in <= '1';
                                wait for CLK_PERIOD;
                        end loop;
                end loop;

                in_write_in <= '0';

                wait for 2 ms;

        end process;
end architecture;
