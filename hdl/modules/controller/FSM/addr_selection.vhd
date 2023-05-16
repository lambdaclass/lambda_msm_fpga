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

                select_addr_A   : in std_logic_vector(2 downto 0);
                select_addr_B   : in std_logic_vector(2 downto 0);
                
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

        signal s_k              : std_logic_vector(C - 1 downto 0);
        signal s_km             : std_logic_vector(C - 1 downto 0);
        signal s_km_b           : std_logic_vector(C - 1 downto 0);

        signal g_k              : std_logic_vector(C - 1 downto 0) := zeros(C);
        signal g_km             : std_logic_vector(C - 1 downto 0);

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

        s_k         <= std_logic_vector(to_unsigned(176, C) + unsigned(counters.segment));
        g_km        <= std_logic_vector(to_unsigned(176, C) + to_unsigned(K_sel, ceil2power(K_sel))*unsigned(counters.segment) + unsigned(counters.window));

        s_km        <= std_logic_vector(to_unsigned(0, C) + to_unsigned(K_sel, ceil2power(K_sel))*unsigned(counters.segment) + unsigned(counters.window));
        s_km_b      <= std_logic_vector(to_unsigned(0, C) + to_unsigned(K_sel, ceil2power(K_sel))*(unsigned(counters.segment) + 1) + (unsigned(counters.segment) + 1)); 


        process(bl, counters.segment, counters.element, top_m, top_u)
        begin
                bl <= std_logic_vector(top_m - unsigned(counters.segment)) & std_logic_vector(unsigned(top_u) - unsigned(counters.element));
        end process;

        process(select_addr_B, bl, s_km_b, s_k, g_km, s_km, array_xn_k)
        begin
                case select_addr_B is
                        when "000"  => address_out_B <= array_xn_k(to_integer(unsigned(counters.window)));
                        when "001"  => address_out_B <= bl;   
                        when "010"  => address_out_B <= s_k;  
                        when "011"  => address_out_B <= s_km; 
                        when "100"  => address_out_B <= s_km_b;
                        when others => address_out_B <= g_km;
                end case;
        end process;

        -- Para el loop 1, vas a entrar con el x_n red y con la direccion calculada.


        process(select_addr_A, g_k, s_k, g_km, s_km, counters.window, array_xn_k, fifo_xn)
        begin
                case select_addr_A is
                        when "000"   => address_out_A <= array_xn_k(to_integer(unsigned(counters.window)));
                        when "001"   => address_out_A <= fifo_xn;
                        when "010"   => address_out_A <= g_k;
                        when "011"   => address_out_A <= g_km;
                        when "100"   => address_out_A <= s_k;
                        when others  => address_out_A <= s_km;
                end case;
        end process;

end Structural;
