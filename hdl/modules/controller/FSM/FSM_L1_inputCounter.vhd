library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_L1_inputCounter is
        -- N = 2**26
        generic(N : natural := 67108864);
        port(
                -------------------
                -- INPUT SIGNALS --
                -------------------
                clk, rst        : in std_logic;
                count           : in std_logic;

                --------------------
                -- OUTPUT SIGNALS --
                --------------------
                processing_done : out std_logic
            );
end FSM_L1_inputCounter;

architecture Structural of FSM_L1_inputCounter is
        signal counter : unsigned(25 downto 0);
begin

        process(clk, rst, count)
        begin
                if rst = '1' then
                        counter <= (others => '0');
                elsif (clk'event and clk = '1' and count = '1') then

                        if (count = '1') then
                                if (counter = N) then
                                        counter <= (others => '0');
                                else
                                        counter <= counter + 1;
                                end if;
                        else
                                counter <= counter;
                        end if;

                end if;

        end process;

        process(counter)
        begin
                if counter = N then
                        processing_done <= '1';
                else
                        processing_done <= '0';
                end if;
        end process;

end Structural;
