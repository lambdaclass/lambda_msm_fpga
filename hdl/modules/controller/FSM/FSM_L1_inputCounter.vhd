library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_L1_inputCounter is
        generic(N : natural := 12345);
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
        signal counter : unsigned(99 downto 0);
begin

        process(clk, rst, count)
        begin
                if rst = '1' then
                        counter <= (others => '0');
                elsif (clk'event and clk = '1' and count = '1') then
                        counter <= counter + 1;
                end if;

        end process;

        process(counter)
        begin
                if unsigned(counter) = N then
                        processing_done <= '1';
                else
                        processing_done <= '0';
                end if;
        end process;

end Structural;
