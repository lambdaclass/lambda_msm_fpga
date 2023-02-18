library ieee;
use ieee.std_logic_1164.all;

--* @brief Tipos de datos auxiliares de uso general

package tipos is
  
  type std_logic_2d is
    array (natural range <>, natural range <>) of std_logic;
  
  type std_logic_vector_a2 is
    array (natural range <>) of std_logic_vector(1 downto 0);

  type std_logic_vector_a8 is
    array (natural range <>) of std_logic_vector(7 downto 0);
  
  type natural_vector is array(natural range <>) of natural;
  
end package;
