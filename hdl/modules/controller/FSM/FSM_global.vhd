library IEEE;
library XPM;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.math_real.ALL;

use work.config.ALL;
use work.funciones.ALL;
use work.tipos.ALL;

use xpm.vcomponents.ALL;

use work.bucket_mem;
use work.point_adder_pip;
use work.fifo_bank;
use work.delay_M;
use work.controller;

entity FSM_global is
    port (
        clk                     : in std_logic;
        rst                     : in std_logic;

        start_MSM               : in std_logic;

        count_signals : out count_signals;
        output_fifo_we : out std_logic
    );

end FSM_global;

architecture Structural of FSM_global is

        signal bucket_status    : bucket_status;
        signal fifo_bank_status : fifo_bank_status;

        signal start_loop2 : std_logic;
        signal start_loop3 : std_logic;

        signal k_next_l1   : std_logic;
        signal k_next_l2   : std_logic;
        signal k_next_l3   : std_logic;

        signal padd_status_l1  : std_logic_vector(3 downto 0);
        signal padd_status_l2  : std_logic_vector(3 downto 0);

--        signal address_A_l1 :
--        signal address_A_l2 :
 
        signal data_A_select_L1 : std_logic_vector(1 downto 0); 
        signal data_B_select_L1 : std_logic_vector(2 downto 0); 
 
        signal data_A_select_L2 : std_logic_vector(1 downto 0); 
        signal data_B_select_L2 : std_logic_vector(2 downto 0); 

        signal loop_selection : std_logic_vector(1 downto 0);

        signal done_processing : std_logic;
begin

--                
--        U_SIGNAL_SELECTOR: entity work.FSM_output
--        port map(
--                        clk => clk,
--                        rst => rst,
--                        start_loop1 => start_MSM,
--                        start_loop2 => start_loop2,
--                        start_loop3 => start_loop3,
--                        done => done_processing,
--
--                        choose_signals => loop_selection
--                );
--
--        WINDOW_NEXT_ASSIGNMENT: process(loop_selection, k_next_l1, k_next_l2, k_next_l3)
--        begin
--                case loop_selection is
--                        when "00" =>   window_next  <= k_next_l1;
--                        when "01" =>   window_next  <= k_next_l2;
--                        when others => window_next  <= k_next_l3;
--                end case;
--        end process;
--
--        WRITE_DV_PADD: process(loop_selection, padd_status_l1, padd_status_l2)
--        begin
--                case loop_selection is
--                        when "00" =>   padd_status_out <= padd_status_l1;
--                        when others => padd_Status_out <= padd_status_l2;
--                end case;
--        end process;
--
--        PADD_OPERAND_A : process(loop_selection)
--        begin
--                case loop_selection is
--                        when "00" =>   padd_select_dinA <= data_A_select_L1;
--                        when others => padd_select_dinA <= data_A_select_L2;
--                end case;
--        end process;
--
--        PADD_OPERAND_B : process(loop_selection)
--        begin
--                case loop_selection is
--                        when "00" =>   padd_select_dinB <= data_B_select_L1;
--                        when others => padd_select_dinB <= data_B_select_L2;
--                end case;
--        end process;
--

end Structural;
