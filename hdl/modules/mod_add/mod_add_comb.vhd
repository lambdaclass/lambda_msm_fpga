library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.funciones.all;

-- Defines N (number of bits) and q prime: 
use work.config.all;

--* @brief Sumador / restador modulo N
--*
--* <var>result = (x + y)</var> mod N if <var>op</var> = 0 <br>
--* <var>result = (x - y)</var> mod N if <var>op</var> = 1
--*
--* Está basado en la descripción hecha en "Some Modular Adders 
--* and Multipliers for FPGAs" de Jean-Luc Beuchat, 2003, IEEE

entity mod_add_comb is
  port(
    x      : in  std_logic_vector (N - 1 downto 0);
    y      : in  std_logic_vector (N - 1 downto 0);
    op     : in  std_logic;
    result : out std_logic_vector (N - 1 downto 0)
    );
end entity;

architecture combinational of mod_add_comb is
  
  signal s0       : std_logic_vector(N downto 0);
  signal s0_carry : std_logic;

  signal s1       : std_logic_vector(N downto 0);
  signal s1_carry : std_logic;

  signal carry : std_logic;
  
begin
  
  with op select
    s0 <= std_logic_vector(signed("0" & x) + signed("0" & y)) when '0',
          std_logic_vector(signed("0" & x) - signed("0" & y)) when '1',
          (others => '0')                                     when others;
  
  s0_carry <= s0(N);

  with op select
    s1 <= std_logic_vector(signed(s0) - signed("0" & q )) when '0',
    std_logic_vector(signed(s0) + signed("0" & q))        when '1',
    (others => '0')                                       when others;
  
  s1_carry <= s1(N);

  carry <= (not(op) and s1_carry) or (op and not(s0_carry));

  process(s0, s1, carry)
  begin
    if(carry = '0') then
      result <= s1(N - 1 downto 0);
    else
      result <= s0(N - 1 downto 0);
    end if;
  end process;
  
end architecture;