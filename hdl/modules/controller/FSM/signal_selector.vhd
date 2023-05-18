library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.funciones.ALL;
use work.tipos.ALL;
use work.config.ALL;

entity signal_selector is
        generic(K : natural := 22);
        port(
                w_value                 : in std_logic_vector(ceil2power(K) - 1 downto 0);

                bucket_kstatus          : in bucket_kstatus;
                fifo_bank_kempty        : in std_logic_vector(K - 1 downto 0);

                bucket_status           : out bucket_status;
                fifo_bank_empty         : out std_logic
);

end signal_selector;

architecture Structural of signal_selector is
        
begin

        BUCKET_EMPTY_SIG : process(bucket_kstatus, w_value)
        begin
                bucket_status.empty_o <= bucket_kstatus.empty_o(to_integer(unsigned(w_value))); 
        end process;

        BUCKET_BUSY_SIG  : process(bucket_kstatus, w_value)
        begin
                bucket_status.busy_o <= bucket_kstatus.busy_o(to_integer(unsigned(w_value))); 
        end process;

        FIFO_K_EMPTY_SIG  : process(fifo_bank_kempty, w_value)
        begin
                fifo_bank_empty <= fifo_bank_kempty(to_integer(unsigned(w_value)));
        end process;

end Structural;
