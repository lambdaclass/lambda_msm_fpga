library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_w_counter is
        generic(K : natural := 5);
        port(
        clk, rst : in std_logic;
        in_count : in std_logic; -- Dejo la senial prendida hasta que termine

        out_count : out std_logic_vector(K - 1 downto 0)
        );
end FSM_w_counter;

architecture Structural of FSM_w_counter is
        signal counter : unsigned(K - 1 downto 0);
        

begin
        process(clk, rst, counter)
        begin
                if(rst = '1') then
                        counter <= (others => '0');
                elsif(clk'event and clk = '1' ) then 

                        if (in_count = '1') then
                                if (counter = K) then
                                        counter <= (others => '0');
                                else
                                        counter <= counter + 1;
                                end if;
                        else
                                counter <= counter;
                        end if;

                end if;
        end process;

        out_count <= std_logic_vector(counter);

end Structural;
