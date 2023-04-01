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
                K               : in std_logic_vector(ceil2power(K_sel) - 1 downto 0);
                U               : in std_logic_vector(ceil2power(U_sel - 1) - 1 downto 0);
                M               : in std_logic_vector(ceil2power(M_sel - 1) - 1 downto 0);

                select_loop     : in std_logic;
                select_addr_A   : in std_logic_vector(1 downto 0);
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
        signal intermediate_L2  : std_logic_vector(C - 1 downto 0);

        signal s_k              : std_logic_vector(C - 1 downto 0);
        signal s_km             : std_logic_vector(C - 1 downto 0);
        signal s_km_b           : std_logic_vector(C - 1 downto 0);

        signal g_k              : std_logic_vector(C - 1 downto 0);
        signal g_km             : std_logic_vector(C - 1 downto 0);

        signal bl               : std_logic_vector(C - 1 downto 0);
begin

        x_n_ext(x_n'length - 1 downto 0) <= x_n;
    -- Scalar to FIFO bank    
    -- Connect scalar to MUX for scalar reduced  
    U0_CONNECTIONS: for i in 0 to K_sel-1 generate
    begin
         array_xn_k(i)<=x_n_ext((i+1)*C-1 downto C*i);
    end generate;

        g_k         <= std_logic_vector(to_unsigned(0, C) + unsigned(K));
        s_k         <= std_logic_vector(to_unsigned(22, C) + unsigned(K));
        g_km        <= std_logic_vector(to_unsigned(44, C) + to_unsigned(K_sel, ceil2power(K_sel))*unsigned(M) + unsigned(M));
        s_km        <= std_logic_vector(to_unsigned(198, C) + to_unsigned(K_sel, ceil2power(K_sel))*unsigned(M) + unsigned(M));
        s_km_b      <= std_logic_vector(to_unsigned(198, C) + to_unsigned(K_sel, ceil2power(K_sel))*(unsigned(M) + 1) + (unsigned(M) + 1)); -- Duditas

        bl <= M & U;
-------------------------
        process(select_addr_B, bl, s_km_b, s_k, g_km, s_km)
        begin
                case select_addr_B is
                        when "000"  => address_out_B <= bl;
                        when "001"  => address_out_B <= s_k;
                        when "010"  => address_out_B <= s_km;
                        when "011"  => address_out_B <= s_km_b;
                        when others => address_out_B <= g_km;
                end case;
        end process;

        -- Para el loop 1, vas a entrar con el x_n red y con la direccion calculada.


        process(select_loop, array_xn_k, K, intermediate_L2)
        begin
                case select_loop is
                        when '0'    => address_out_A <= array_xn_k(to_integer(unsigned(K))); 
                        when others => address_out_A <= intermediate_L2; 
                end case;
        end process;

        process(select_addr_A, g_k, s_k, g_km, s_km)
        begin
                case select_addr_A is
                        when "00"   => intermediate_L2 <= g_k;
                        when "01"   => intermediate_L2 <= g_km;
                        when "10"   => intermediate_L2 <= s_k;
                        when others => intermediate_L2 <= s_km;
                end case;
        end process;

end Structural;
