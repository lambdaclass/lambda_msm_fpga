library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Nota: Estoy asumiendo que hay dos buses diferentes de datos... 
-- NOTA IMPORTANTE: Las URAM traen en cada puerto de salida un bit de RDACCESS que avisa cuando un dato ya esta disponible en la salida. Eso
--                  puede servir para avisar a una FSM que puede arrancar con otra ejecucion... Por ahora pienso que es la entrada data_ready

entity FSM_L1_dispatch is
        generic(K : natural := 5);
        port(
                -------------------
                -- INPUT SIGNALS --
                -------------------
                -- Generic.
                clk, rst                : in std_logic;

                -- FSM start signal.
                data_ready              : in std_logic;

                -- All fifos with an element. (Corresponds to a not empty from all the fifos)
                fifo_flush              : in std_logic;

                -- Counter value.
                counter                 : in std_logic_vector(4 downto 0);

                -- Buckets info - Empty and busy bits.
                empty_buckets               : in std_logic_vector(K - 1 downto 0);
                busy_buckets                : in std_logic_vector(K - 1 downto 0);

                -- Fifo info
                empty_fifos             : in std_logic_vector(K - 1 downto 0);
                full_fifos              : in std_logic_vector(K - 1 downto 0);
                --------------------
                -- OUTPUT SIGNALS --
                --------------------

                -- Communications between machines.
                start_busIn             : out std_logic;
                start_flushOne          : out std_logic;
                start_flushall          : out std_logic;

                -- Input to bus signal. (Note : It's also used as the signal of the PADD counter)
                point_enable_in         : out std_logic;

                -- Scalar and window output for PADD.
                scalar_window_out       : out std_logic;
                counter_window_out      : out std_logic;

                -- FIFO control signals.
                fifo_write              : out std_logic;
                
                -- Bubble output.
                bubble_sig              : out std_logic;

                -- Extra bits for memory buckets. (Doesn't look elegant)
                busy_bit                : out std_logic;
                empty_bit               : out std_logic;

                -- Memory signals.
                mem_enable              : out std_logic_vector(K - 1 downto 0);
                mem_write               : out std_logic_vector(K - 1 downto 0);
                mem_output_en     : out std_logic_vector(K - 1 downto 0)
            );
end FSM_L1_dispatch;

architecture Structural of FSM_L1_dispatch is
        type loop_state is (s0_idle, s2_dispatch, s3_flushOne, s3_flushAll);
        signal state_reg, state_next : loop_state;

        signal someoneOnEach    : std_logic;
        signal oneFull          : std_logic;
begin

        process(clk, rst)
        begin
                if (rst = '1') then
                        state_reg <= s0_idle;
                elsif (clk'event and clk='1') then
                        state_reg <= state_next;
                end if;
        end process;

        someoneOnEach <= and (not empty_fifos);
        oneFull <= or full_fifos;

        process(state_reg, data_ready, counter)
        begin
                state_next <= state_reg;

                case state_reg is
                        when s0_idle =>
                                state_next <= s2_dispatch when data_ready = '1' else
                                              s0_idle;
                        when s2_dispatch =>
                                if unsigned(counter) = K - 1 then -- Counter is going to reset itself at the K iteration.
                                        if (oneFull = '1') then
                                                state_next <= s3_flushAll;
                                        elsif (someoneOnEach = '1') then
                                                state_next <= s3_flushOne;
                                        else
                                                state_next <= s0_idle;
                                        end if;
                                else 
                                        state_next <= s2_dispatch;
                                end if;
                        when s3_flushOne =>
                                state_next <= s0_idle;
                        when s3_flushAll =>
                                state_next <= s0_idle;
                end case;
        end process;


        process(state_reg, empty_buckets, busy_buckets, counter, fifo_flush)
        begin
                bubble_sig         <= '0';
                busy_bit           <= '0';
                empty_bit          <= '0';

                start_busIn        <= '0';
                start_flushOne     <= '0';
                start_flushAll     <= '0';

                point_enable_in    <= '0';

                counter_window_out <= '0';
                scalar_window_out  <= '0';

                fifo_write         <= '0';

                mem_enable         <= (others => '0'); 
                mem_write          <= (others => '0'); 
                mem_output_en            <= (others => '0'); 


                case state_reg is
                        when s0_idle  =>
                        when s2_dispatch =>
                                
                                -- El bucket esta ocupado. Prendo las seniales para enviarlo a las fifos y mando una burbuja al point adder
                                if busy_buckets(to_integer(unsigned(counter))) = '1' then
                                        fifo_write <= '1';
                                        bubble_sig <= '1';
                                        counter_window_out <= '1';

                                -- El bucket esta vacio. Habilito el bus para el punto y escribo sobre la memoria. La direccion ya tiene 
                                -- que estar sobre el bus. Tambien tengo que habilitar la burbuja. (Notar que la convencion es bit 0 = empty; bit 1 = occupied)
                                elsif empty_buckets(to_integer(unsigned(counter))) = '0' then
                                        point_enable_in <= '1';

                                        bubble_sig <= '1';
                                        counter_window_out <= '1';

                                        empty_bit <= '1'; 
                                        mem_enable <= (others => '0');
                                        mem_enable(to_integer(unsigned(counter))) <= '1';
                                        mem_write <= (others => '0');
                                        mem_write(to_integer(unsigned(counter))) <= '1';
                                -- El bucket ya esta disponible para procesar. Largo el bucket al bus con su respectivo punto. Largo el 
                                -- valor de la ventana y el scalar al bus para el point adder
                                else
                                        -- Saco los puntos hacia el point adder.
                                        mem_output_en <= (others => '0');
                                        mem_output_en(to_integer(unsigned(counter))) <= '1';
                                        point_enable_in <= '1';

                                        -- Saco la direccion hacia el point adder.
                                        counter_window_out <= '1';
                                        scalar_window_out <= '1';

                                        -- Escribo el bit de busy en los buckets. La direccion y el dato ya estan en el bus
                                        busy_bit <= '1';

                                        mem_enable <= (others => '0');
                                        mem_enable(to_integer(unsigned(counter))) <= '1';

                                        mem_write <= (others => '0');
                                        mem_write(to_integer(unsigned(counter))) <= '1';        
                                end if;
                                
                                if unsigned(counter) = K then
                                        if oneFull = '1' then
                                                start_flushOne <= '1';
                                        elsif someoneOnEach = '1' then
                                                start_flushAll <= '1';
                                        else
                                                start_busIn <= '1';
                                        end if;
                                else 
                                end if;
                        when s3_flushOne =>
                        when s3_flushAll =>

                end case;
        end process;

end Structural;
