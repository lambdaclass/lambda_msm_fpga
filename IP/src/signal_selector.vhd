library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.funciones.ALL;
use work.tipos.ALL;
use work.config.ALL;

entity signal_selector is
        generic(K : natural := 5);
        port(
                -- Input --
                w_value                 : in std_logic_vector(ceil2power(K) - 1 downto 0);

                bucket_kempty           : in std_logic_vector(K - 1 downto 0);
                bucket_kbusy            : in std_logic_vector(K - 1 downto 0);
                fifo_kfull              : in std_logic_vector(K - 1 downto 0);
                fifo_kempty             : in std_logic_vector(K - 1 downto 0);


                bucket_empty_b          : out std_logic;
                bucket_busy_b           : out std_logic;
                fifo_anyFull            : out std_logic;
                fifo_allWithElem        : out std_logic;
                fifo_k_empty            : out std_logic
);

end signal_selector;

architecture Structural of signal_selector is
        
begin

        BUCKET_EMPTY_SIG : process(bucket_kempty, w_value)
        begin
                bucket_empty_b <= bucket_kempty(to_integer(unsigned(w_value))); 
        end process;

        BUCKET_BUSY_SIG  : process(bucket_kbusy, w_value)
        begin
                bucket_busy_b  <= bucket_kbusy(to_integer(unsigned(w_value))); 
        end process;

        FIFO_ANY_FULL_SIG  : process(fifo_kfull)
        begin
                fifo_anyFull     <= or fifo_kfull;
        end process;

        FIFO_ALL_W_ELEM_SIG  : process(fifo_kempty)
        begin
                fifo_allWithElem <= and (not fifo_kempty);
        end process;

        FIFO_K_EMPTY_SIG  : process(fifo_kempty, w_value)
        begin
                fifo_k_empty <= fifo_kempty(to_integer(unsigned(w_value)));
        end process;

end Structural;
