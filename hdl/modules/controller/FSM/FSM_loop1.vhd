----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2023 03:07:54 PM
-- Design Name: 
-- Module Name: FSM_loop1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_loop1 is
        generic(N : natural := 5);
        port(
                -- Fundamental signals 
                clk, rst   : in std_logic;

                -- Start signal
                start      : in std_logic;

                -- Buckets - Empty and busy bits
                empty_bin  : in std_logic_vector(N - 1 downto 0);
                busy_bin   : in std_logic_vector(N - 1 downto 0);

                -- 5-Counter
                counter    : in std_logic_vector(1 downto 0);

                -- FIFO outputs
                fifo_sig   : out std_logic_vector(N - 1 downto 0);
                
                -- Bubble output
                bubble_sig : out std_logic;

                -- Memory outputs 
                w_read     : out std_logic_vector(N - 1 downto 0);
                w_write    : out std_logic_vector(N - 1 downto 0);
                w_out      : out std_logic_vector(N - 1 downto 0) 

            );
end FSM_loop1;

architecture Structural of FSM_loop1 is
        type loop1_state is (idle, state1, state2, state3);
        signal state_reg, state_next : loop1_state;
begin
        
        -- Parte del circuito que me define el cambio de estado. Ahora lo que necesito es la logica que me va a definir como transiciono
        -- de un estado a otro.

        process(clk, rst)
        begin 
                if (rst = '1') then
                        state_reg <= idle;
                elsif (clk'event and clk='1') then
                        state_reg <= state_next;
                end if;
        end process;

        -- Una vez definida esta logica de transicion, tengo el registro que me guarda en que estado estoy. Ahora necesito saber cual es el output
        -- de mi maquina. 

        process(state_reg, counter, start)
        begin
                state_next <= state_reg;

                case state_reg is
                        when idle =>
                                state_next <= state1 when start = '1' else
                                              idle;
                        when state1 => 
                                state_next <= state2;
                        when state2 => 
                                 -- Por ahora lo hardcodee para ver si inferia un latch... Y lo hace
                                  state_next <= state3 when counter = "00" else
                                                state1 when counter = "01" else
                                                state1 when counter = "10" else
                                                state_next; 
                        when state3 =>
                                state_next <= idle;
                end case;
        end process;

        -- En base a lo que tenemos, mi opinion es que deberiamos hacer una Mealy machine porque para transicionar al proceso de las FIFOs necesito depender de mi input, pero por ahora puedo definir todo en base a maquinas de Moore.

        process(state_reg, counter, empty_bin, busy_bin)
        begin
                bubble_sig <= '0';
                fifo_sig <= (others => '0'); 

                w_read <= (others => '0'); 
                w_write <= (others => '0'); 
                w_out  <= (others => '0'); 

                case state_reg is
                        when idle =>
                                bubble_sig <= '1';
                        when state1 =>
                                w_read <= (others => '1');
                        when state2 =>
                                
                                if busy_bin(to_integer(unsigned(counter))) = '1' then
                                        fifo_sig <= (others => '0');
                                        fifo_sig(to_integer(unsigned(counter))) <= '1';

                                        bubble_sig <= '1';

                                elsif empty_bin(to_integer(unsigned(counter))) = '1' then
                                        w_write <= (others => '0');
                                        w_write(to_integer(unsigned(counter))) <= '1';

                                else
                                        w_out <= (others => '0');
                                        w_out(to_integer(unsigned(counter))) <= '1';

                                end if;

                      when state3 =>
                                w_read <= "00001";
                                w_out  <= "11110";
                end case;
        end process;
        
end Structural;
