library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.funciones.ALL;
use work.tipos.ALL;

entity addr_selection is
        generic (N_esc : natural := 253;
                 K_sel : natural := 22;
                 U_sel : natural := 512;
                 M_sel : natural := 8;
                 C     : natural := 12);
        port ( 
                x_n             : in std_logic_vector(N_esc - 1 downto 0);
                fifo_xn         : in std_logic_vector(C - 1 downto 0);

                counters        : in counters;

                select_addr_A   : in address_A;
                select_addr_B   : in address_B;
                
                address_out_A   : out std_logic_vector(C - 1 downto 0);
                address_out_B   : out std_logic_vector(C - 1 downto 0)
             );
end addr_selection;

architecture Structural of addr_selection is
        -- MUX for split scalar
        type array_xn is array(natural range<>) of std_logic_vector(C-1 downto 0);
        signal array_xn_k       : array_xn(K_sel -1 downto 0);

        signal x_n_ext          : std_logic_vector(K_sel*C - 1 downto 0) := zeros(K_sel*C);
        signal intermediate_L1  : std_logic_vector(C - 1 downto 0);
        signal intermediate_L2  : std_logic_vector(C - 1 downto 0);

        signal addr_s_k              : std_logic_vector(C - 1 downto 0);
        signal addr_s_km             : std_logic_vector(C - 1 downto 0);
        signal addr_s_km_b           : std_logic_vector(C - 1 downto 0);

        signal addr_g_k              : std_logic_vector(C - 1 downto 0) := zeros(C);
        signal addr_g_km             : std_logic_vector(C - 1 downto 0);

        signal bl               : std_logic_vector(C - 1 downto 0);
        signal top_bl           : std_logic_vector(C - 1 downto 0) := (others => '1');
        signal top_m            : unsigned(ceil2power(M_sel - 1) - 1 downto 0) := (others => '1');
        signal top_u            : unsigned(ceil2power(U_sel - 1) - 1 downto 0) := (others => '1');
begin

        x_n_ext(x_n'length - 1 downto 0) <= x_n;

        U0_CONNECTIONS: for i in 0 to K_sel-1 generate
        begin
             array_xn_k(i)<=x_n_ext((i+1)*C-1 downto C*i);
        end generate;

        addr_s_k         <= std_logic_vector(to_unsigned(176, C) + unsigned(counters.segment));
        addr_g_km        <= std_logic_vector(to_unsigned(176, C) + to_unsigned(K_sel, ceil2power(K_sel))*unsigned(counters.segment) + unsigned(counters.window));

        addr_s_km        <= std_logic_vector(to_unsigned(0, C) + to_unsigned(K_sel, ceil2power(K_sel))*unsigned(counters.segment) + unsigned(counters.window));
        addr_s_km_b      <= std_logic_vector(to_unsigned(0, C) + to_unsigned(K_sel, ceil2power(K_sel))*(unsigned(counters.segment) + 1) + (unsigned(counters.segment) + 1)); 


        process(bl, counters.segment, counters.element, top_m, top_u)
        begin
                bl <= std_logic_vector(top_m - unsigned(counters.segment)) & std_logic_vector(unsigned(top_u) - unsigned(counters.element));
        end process;

        process(select_addr_B, bl, addr_s_km_b, addr_s_k, addr_g_km, addr_s_km, array_xn_k)
        begin
                case select_addr_B is
                        when xn         => address_out_B <= array_xn_k(to_integer(unsigned(counters.window)));
                        when bucket     => address_out_B <= bl;   
                        when s_k        => address_out_B <= addr_s_k;  
                        when s_km       => address_out_B <= addr_s_km; 
                        when s_km_b     => address_out_B <= addr_s_km_b;
                        when others     => address_out_B <= addr_g_km;
                end case;
        end process;

        -- Para el loop 1, vas a entrar con el x_n red y con la direccion calculada.


        process(select_addr_A, addr_g_k, addr_s_k, addr_g_km, addr_s_km, counters.window, array_xn_k, fifo_xn)
        begin
                case select_addr_A is
                        when xn         => address_out_A <= array_xn_k(to_integer(unsigned(counters.window)));
                        when fifo       => address_out_A <= fifo_xn;
                        when g_k        => address_out_A <= addr_g_k;
                        when g_km       => address_out_A <= addr_g_km;
                        when s_k        => address_out_A <= addr_s_k;
                        when others     => address_out_A <= addr_s_km;
                end case;
        end process;

end Structural;
