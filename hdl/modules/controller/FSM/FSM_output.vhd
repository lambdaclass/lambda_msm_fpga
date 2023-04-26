library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_output is
        port( 
                -----------------------
                -------- INPUT --------
                -----------------------
                clk, rst        : in std_logic;

                start_loop1     : in std_logic;
                start_loop2     : in std_logic;
                start_loop3     : in std_logic;
                done            : in std_logic;
                
                ------------------------
                -------- OUTPUT --------
                ------------------------
                choose_signals  : out std_logic_vector(1 downto 0)
            );
end FSM_output;

architecture Structural of FSM_output is
        
        type states_loop is (s0_idle, s1_loop1, s2_loop2, s3_loop3);
        signal state_next, state_reg : states_loop;

begin

        process(clk, rst)
        begin
                if (rst = '1') then
                        state_reg <= s0_idle;
                elsif (clk'event and clk='1') then
                        state_reg <= state_next;
                end if;
        end process;

        process(state_reg,  start_loop1, start_loop2, start_loop3)
        begin
                state_next <= state_reg;

                case state_reg is
                        when s0_idle =>
                                state_next <= s1_loop1 when start_loop1 = '1' else
                                              s0_idle;
                        when s1_loop1=>
                                state_next <= s2_loop2 when start_loop2 = '1' else
                                              s1_loop1;
                        when s2_loop2 =>
                                state_next <= s3_loop3 when start_loop3 = '1' else
                                              s2_loop2;
                        when s3_loop3 =>
                                state_next <= s0_idle when done = '1' else
                                              s3_loop3;
                end case;
        end process;

        process(state_reg)
        begin
                choose_signals <= "00"; 

                case state_reg is
                        when s0_idle =>
                        when s1_loop1=>
                                choose_signals <= "00";
                        when s2_loop2 =>
                                choose_signals <= "01";
                        when s3_loop3 =>
                                choose_signals <= "10";
                end case;
        end process;

end Structural;
