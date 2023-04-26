library ieee;
use ieee.std_logic_1164.all;

--* @brief delay de DELAY muestras
--*
--* Es parametrizable el ancho de palabra WORD_WIDTH
entity delay_M is
  generic (
    WORD_WIDTH : natural := 15;
    DELAY      : natural := 5
    );
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    s         : in  std_logic_vector (WORD_WIDTH - 1 downto 0);
    s_delayed : out std_logic_vector (WORD_WIDTH - 1 downto 0));
end entity;

architecture rtl of delay_M is

  type array_of_stdlv is
    array (DELAY downto 0) of std_logic_vector(WORD_WIDTH-1 downto 0);

  signal tmp : array_of_stdlv;

  component delay_1 is
    generic (
      WORD_WIDTH : natural
      );
    port (
      clk       : in  std_logic;
      rst       : in  std_logic;
      s         : in  std_logic_vector (WORD_WIDTH - 1 downto 0);
      s_delayed : out std_logic_vector (WORD_WIDTH - 1 downto 0)
      );
  end component;

begin
  
  tmp(0) <= s;

  delay_gen:
  for i in 1 to DELAY generate
    
    dly_gen : delay_1
      generic map(WORD_WIDTH => WORD_WIDTH)
      port map(
        clk       => clk,
        rst       => rst,
        s         => tmp(i-1),
        s_delayed => tmp(i)
        );
  end generate;

  s_delayed <= tmp(DELAY);

end architecture;

