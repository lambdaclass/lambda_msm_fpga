library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.funciones.ALL;
use work.config.ALL;
use work.tipos.ALL;

entity FSM_padd_counter is
        generic(K : natural := 5);
        port(
        clk, rst        : in std_logic;

        add_count       : in std_logic; -- Dejo la senial prendida hasta que termine
        sub_count       : in std_logic;

        out_count       : out std_logic_vector(ceil2power(55) - 1 downto 0);
        out_top_v       : out std_logic
        );
end FSM_padd_counter;

architecture Structural of FSM_padd_counter is
        signal counter : unsigned(ceil2power(55) - 1 downto 0);
        signal top_v   : std_logic;

begin

        process(clk, rst, counter)
        begin
                if(rst = '1') then
                        counter <= (others => '0');
                        top_v <= '0';
                elsif(clk'event and clk = '1' ) then 

                        if (add_count = '1') then
                                if (sub_count = '1') then
                                        counter <= counter;
                                        top_v <= top_v;
                                elsif (counter = K - 1) then
                                        counter <= counter + 1;
                                        top_v <= '1';
                                elsif (counter = K) then
                                        counter <= (others => '0');
                                        top_v <= '0';
                                else
                                        counter <= counter + 1;
                                        top_v <= '0';
                                end if;
                        else
                                if (sub_count = '1') then
                                        counter <= to_unsigned(0, ceil2power(55)) when counter /= to_unsigned(0, ceil2power(55)) else
                                                   counter - 1;
                                        top_v <= '0';
                                else
                                        counter <= counter;
                                        top_v <= top_v;
                                end if;
                        end if;

                end if;
        end process;

        out_count <= std_logic_vector(counter);
        out_top_v <= top_v;

end Structural;
