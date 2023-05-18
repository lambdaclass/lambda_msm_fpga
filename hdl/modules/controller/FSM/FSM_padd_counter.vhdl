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

        add_count       : in std_logic;
        sub_count       : in std_logic;

        out_count       : out std_logic_vector(ceil2power(55) - 1 downto 0);
        out_top_v       : out std_logic
        );
end FSM_padd_counter;

architecture Structural of FSM_padd_counter is
        signal counter : unsigned(ceil2power(55) - 1 downto 0);
        signal top_v   : std_logic;

begin

        process(clk, rst, counter, top_v)
        begin
                if(rst = '1') then
                        counter <= (others => '0');
                        top_v <= '1';
                elsif(clk'event and clk = '1' ) then 

                        if (add_count = '1') then
                                if (sub_count = '1') then
                                        counter <= counter;
                                else
                                        counter <= counter + 1 when counter < to_unsigned(55, ceil2power(55)) else
                                                   counter;
                                end if;
                        else
                                if (sub_count = '1') then
                                        counter <= counter - 1 when counter > to_unsigned(0, ceil2power(55)) else
                                                   counter;
                                else
                                        counter <= counter;
                                end if;
                        end if;
                end if;

                top_v <= '1' when (counter = to_unsigned(0, ceil2power(55))) else 
                         '0';
        end process;

        out_count <= std_logic_vector(counter);
        out_top_v <= top_v;

end Structural;
