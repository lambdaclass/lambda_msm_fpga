library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.funciones.all;

-- Defines N (number of bits) and q prime: 
use work.config.all;
use work.pipeline_cfg.all;

--* @brief Sumador / restador modulo N
--*
--* <var>result = (x + y)</var> mod N if <var>op</var> = 0 <br>
--* <var>result = (x - y)</var> mod N if <var>op</var> = 1
--*
--* Está basado en la descripción hecha en "Some Modular Adders 
--* and Multipliers for FPGAs" de Jean-Luc Beuchat, 2003, IEEE

entity mod_add_pip is
  port(
    clk    : in  std_logic;
    rst    : in  std_logic;
    x      : in  std_logic_vector (N_vect - 1 downto 0);
    y      : in  std_logic_vector (N_vect - 1 downto 0);
    op     : in  std_logic;
    result : out std_logic_vector (N_vect - 1 downto 0)
    );
    constant DELAY : NATURAL := MODADD_DELAY;
end entity;

architecture full_pipelined of mod_add_pip is
  
  signal s0       : std_logic_vector(N_vect downto 0);
  signal s0_carry : std_logic;

  signal s1       : std_logic_vector(N_vect downto 0);
  signal s1_carry : std_logic;

  signal carry : std_logic;
  signal result_next : std_logic_vector (N_vect - 1 downto 0);
  
begin
  
  with op select
    s0 <= std_logic_vector(signed("0" & x) + signed("0" & y)) when '0',
          std_logic_vector(signed("0" & x) - signed("0" & y)) when '1',
          (others => '0')                                     when others;
  
  s0_carry <= s0(N_vect);

  with op select
    s1 <= std_logic_vector(signed(s0) - signed("0" & q )) when '0',
    std_logic_vector(signed(s0) + signed("0" & q))        when '1',
    (others => '0')                                       when others;
  
  s1_carry <= s1(N_vect);

  carry <= (not(op) and s1_carry) or (op and not(s0_carry));

  result_next <= s1(N_vect - 1 downto 0) when carry = '0' 
                                    else s0(N_vect-1 downto 0);
  process(clk)
  begin
    if clk = '1' and clk'event then
        if (rst = '1') then
            result <= (others => '0');
        else    
            result <= result_next;
        end if;
    end if;
  end process;
  
end architecture;
