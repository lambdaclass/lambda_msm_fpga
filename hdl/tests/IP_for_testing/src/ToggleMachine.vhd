-------------------------------------------------------------------------------
-- ToggleMachine
-- 
-- Descripcion:
-- Esta maquina cambia de estado la salida al producirse una transicion
-- positiva en la entrada
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ToggleMachine is
  port(
    clk    : in  std_logic;
    rst    : in  std_logic;
    en     : in  std_logic;
    sin    : in  std_logic;
    toggle : out std_logic
    );
end entity;

architecture beh of togglemachine is

  type estado is (s00, s11, s01, s10);
  signal estado_reg, estado_next : estado;
  
begin

  process(clk, rst)
  begin
    
    if (clk'event and clk = '1') then
      if (rst = '1') then
        estado_reg <= s00;
      elsif (en = '1')then
        estado_reg <= estado_next;
      end if;
    end if;
  end process;

  process(sin, estado_reg)
  begin
    case estado_reg is
      
      when s00 =>
        if sin = '1' then
          estado_next <= s11;
        else
          estado_next <= s00;
        end if;
        
      when s11 =>
        if sin = '0' then
          estado_next <= s01;
        else
          estado_next <= s11;
        end if;
        
      when s01 =>
        if sin = '1' then
          estado_next <= s10;
        else
          estado_next <= s01;
        end if;
        
      when s10 =>
        if sin = '0' then
          estado_next <= s00;
        else
          estado_next <= s10;
        end if;
        
    end case;
  end process;

  process(estado_reg)
  begin

    case estado_reg is
      when s00 =>
        toggle <= '0';
      when s11 =>
        toggle <= '1';
      when s01 =>
        toggle <= '1';
      when s10 =>
        toggle <= '0';
    end case;
  end process;


end beh;

