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
                fifo_bank_kstatus       : in fifo_bank_kstatus;

                fifo_bank_status        : out fifo_bank_status;
                bucket_status           : out bucket_status
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

        FIFO_ANY_FULL_SIG  : process(fifo_bank_kstatus)
        begin
                fifo_bank_status.fb_anyFull <= or fifo_bank_kstatus.fb_kfull;
        end process;

        FIFO_ALL_W_ELEM_SIG  : process(fifo_bank_kstatus)
        begin
                fifo_bank_status.fb_allWithElem <= and (not fifo_bank_kstatus.fb_kempty);
        end process;

        FIFO_K_EMPTY_SIG  : process(fifo_bank_kstatus, w_value)
        begin
                fifo_bank_status.fb_empty <= fifo_bank_kstatus.fb_kempty(to_integer(unsigned(w_value)));
        end process;

end Structural;
