library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_loop1 is
        generic(N : natural := 5);
        port(
                -- Fundamental signals 
                clk, rst   : in std_logic;

                -- Start signal
                start      : in std_logic;

                -- End signal (Finished processing all the points)
                end_input        : in std_logic;

                -- Buckets - Empty and busy bits
                empty_bin  : in std_logic_vector(N - 1 downto 0);
                busy_bin   : in std_logic_vector(N - 1 downto 0);

                -- 5-Counter
                counter    : in std_logic_vector(4 downto 0);

                -- PADD finish signal (Haven't thought of it...)
                padd_finish : in std_logic;

                -- FIFO signals 
                fifo_full  : in std_logic;
                all_fifos_empty : in std_logic;

                -- Input out
                scalar_enable_in  : out std_logic;
                point_enable_in   : out std_logic;

                -- Scalar and window output.
                scalar_out : out std_logic_vector(N - 1 downto 0);
                counter_out : out std_logic;

                -- FIFO outputs
                fifo_read   : out std_logic_vector(N - 1 downto 0);
                fifo_write  : out std_logic_vector(N - 1 downto 0);
                
                -- Bubble output
                bubble_sig : out std_logic;

                -- Extra bits for memory
                busy_bit : out std_logic;
                empty_bit : out std_logic;

                -- Memory outputs  
                mem_enable   : out std_logic_vector(N - 1 downto 0);
                mem_read     : out std_logic_vector(N - 1 downto 0);
                mem_write    : out std_logic_vector(N - 1 downto 0);
                mem_out      : out std_logic_vector(N - 1 downto 0);

                -- Loop 1 end signal
                finish_out : out std_logic
            );
end FSM_loop1;

architecture Structural of FSM_loop1 is
        signal flush_done : std_logic;

        type loop1_state is (s0_idle, s1_busIn, s2_dispatch_points, s3_flush, s4_wait_for_processing);
        signal state_reg, state_next : loop1_state;
begin
        
        -- Parte del circuito que me define el cambio de estado. Ahora lo que necesito es la logica que me va a definir como transiciono
        -- de un estado a otro.

        process(clk, rst)
        begin 
                if (rst = '1') then
                        state_reg <= s0_idle;
                elsif (clk'event and clk='1') then
                        state_reg <= state_next;
                end if;
        end process;

        -- Una vez definida esta logica de transicion, tengo el registro que me guarda en que estado estoy. Ahora necesito saber cual es el output
        -- de mi maquina. 

        process(state_reg, counter, start, flush_done, fifo_full, end_input, all_fifos_empty, padd_finish)
        begin
                state_next <= state_reg;

                case state_reg is
                        when s0_idle =>
                                state_next <= s1_busIn when start = '1' else
                                              s0_idle;
                        when s1_busIn => 
                                state_next <= s2_dispatch_points;
                        when s2_dispatch_points => 
                                if unsigned(counter) = N then
                                        if fifo_full = '1' then
                                                state_next <= s3_flush;
                                        else
                                                if end_input = '0' then
                                                        state_next <= s1_busIn;
                                                else
                                                        state_next <= s4_wait_for_processing;
                                                end if;
                                        end if;
                                else 
                                        state_next <= s2_dispatch_points;
                                end if;
                        when s3_flush =>
                                state_next <= s2_dispatch_points;
                        when s4_wait_for_processing =>
                                if all_fifos_empty = '0' or padd_finish = '0' then
                                        state_next <= s4_wait_for_processing;
                                elsif all_fifos_empty = '1' and padd_finish = '1' then
                                        state_next <= s0_idle;
                                end if;
                end case;
        end process;

        -- En base a lo que tenemos, mi opinion es que deberiamos hacer una Mealy machine porque para transicionar al proceso de las FIFOs necesito depender de mi input, pero por ahora puedo definir todo en base a maquinas de Moore.

        process(state_reg, counter, empty_bin, busy_bin, all_fifos_empty, padd_finish)
        begin
                bubble_sig <= '0';
                scalar_enable_in <= '0';
                point_enable_in <= '0';

                busy_bit <= '0';
                empty_bit <= '0';
                counter_out <= '0';
                scalar_out <= (others => '0');

                fifo_read  <= (others => '0'); 
                fifo_write <= (others => '0'); 

                mem_enable <= (others => '0'); 
                mem_read   <= (others => '0'); 
                mem_write  <= (others => '0'); 
                mem_out    <= (others => '0'); 

                finish_out <= '0';

                case state_reg is
                        -- Idle -> Corresponde al estado inicial. No saca ninguna senial.
                        when s0_idle  =>
                        -- busIn -> Habilita la senial para que el escalar entre al componente y a la vez lea los K buckets.
                        when s1_busIn =>
                                scalar_enable_in <= '1';

                                mem_enable <= (others => '1');
                                mem_read  <= (others => '1');
                        -- dispatch_points -> Dada la lectura realizada, se itera por sobre todos los Ks y dependiendo de la combinacion
                        --                    de busy-empty, se prenden ciertas seniales
                        when s2_dispatch_points =>
                                
                                -- El bucket esta ocupado. Prendo las seniales para enviarlo a las fifos y mando una burbuja al point adder
                                if busy_bin(to_integer(unsigned(counter))) = '1' then
                                        fifo_write <= (others => '0');
                                        fifo_write(to_integer(unsigned(counter))) <= '1';
                                        bubble_sig <= '1';
                                        counter_out <= '1';

                                -- El bucket esta vacio. Habilito el bus para el punto y escribo sobre la memoria. La direccion ya tiene 
                                -- que estar sobre el bus.
                                elsif empty_bin(to_integer(unsigned(counter))) = '0' then
                                        point_enable_in <= '1';
                                        empty_bit <= '1'; 
                                        mem_enable <= (others => '0');
                                        mem_enable(to_integer(unsigned(counter))) <= '1';

                                        mem_write <= (others => '0');
                                        mem_write(to_integer(unsigned(counter))) <= '1';
                                -- El bucket ya esta disponible para procesar. Largo el bucket al bus con su respectivo punto. Largo el 
                                -- valor de la ventana y el scalar al bus para el point adder
                                else
                                        -- Saco los puntos hacia el point adder.
                                        mem_out <= (others => '0');
                                        mem_out(to_integer(unsigned(counter))) <= '1';
                                        point_enable_in <= '1';

                                        -- Saco la direccion hacia el point adder.
                                        counter_out <= '1';
                                        scalar_out <= (others => '0');
                                        scalar_out(to_integer(unsigned(counter))) <= '1';

                                        -- Escribo el bit de busy en los buckets. La direccion y el dato ya estan en el bus
                                        busy_bit <= '1';

                                        mem_enable <= (others => '0');
                                        mem_enable(to_integer(unsigned(counter))) <= '1';

                                        mem_write <= (others => '0');
                                        mem_write(to_integer(unsigned(counter))) <= '1';        
                                end if;

                      when s3_flush =>
                                fifo_read <= (others => '1');
                                mem_read <= (others => '1');

                      when s4_wait_for_processing =>
                              if padd_finish = '1' and all_fifos_empty = '1' then
                                      finish_out <= '1';
                              else
                                      finish_out <= '0';
                              end if;
                end case;
        end process;
        
end Structural;
