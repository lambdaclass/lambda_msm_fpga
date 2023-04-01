library IEEE;
use IEEE.STD_LOGIC_1164.all;

--* @brief Genera un delay de una muestra
entity delay_1 is
  generic (
    WORD_WIDTH : natural
    );
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    s         : in  std_logic_vector (WORD_WIDTH - 1 downto 0);
    s_delayed : out std_logic_vector (WORD_WIDTH - 1 downto 0)
    );
end entity;

architecture rtl of delay_1 is

  signal s_next : std_logic_vector(WORD_WIDTH - 1 downto 0);
  signal s_reg  : std_logic_vector(WORD_WIDTH - 1 downto 0);

begin

  delay:
  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if rst = '1' then
        s_reg <= (others => '0');
      else
        s_reg <= s_next;
      end if;
    end if;
  end process;

  s_next    <= s;
  s_delayed <= s_reg;
  
end architecture;

