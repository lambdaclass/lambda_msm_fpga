library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.funciones.all;
use work.config.all;

entity bucket_mem_tb is
end entity;

architecture behavioral of bucket_mem_tb is

    constant CLK_PERIOD : time := 5 ns;
    constant RST_TIME   : time := CLK_PERIOD * 5 + 1 ps;

    constant K      : integer := 5;     -- Frames
    constant DWIDTH : integer := 72;    -- Data Width
    constant AWIDTH : integer := 12 * K;-- Address Width

    signal clk      : std_logic;                                -- Clock
    signal rst      : std_logic;                                -- Reset
    signal wea      : std_logic := '0';                                -- Write Enable - Port A
    signal web      : std_logic := '0';                                -- Write Enable - Port B
--  signal regcea   : std_logic;                                -- Output Register Enable - Port A
--  signal regceb   : std_logic;                                -- Output Register Enable - Port B
    signal dina     : std_logic_vector(DWIDTH-1 downto 0) := (others =>'0');      -- Data Input - Port A
    signal addra    : std_logic_vector(AWIDTH-1 downto 0) := (others =>'0');      -- Address Input - Port A
    signal douta    : std_logic_vector(DWIDTH-1 downto 0);      -- Data Output - Port A
    signal kwa      : std_logic_vector(ceil2power(K)-1 downto 0) := (others =>'0');   -- K select for write - Port A
    signal kra      : std_logic_vector(ceil2power(K)-1 downto 0) := (others =>'0');   -- K select for read - Port A
    signal dinb     : std_logic_vector(DWIDTH-1 downto 0) := (others =>'0');      -- Data Input - Port B
    signal addrb    : std_logic_vector(AWIDTH-1 downto 0) := (others =>'0');      -- Address Input - Port B
    signal doutb    : std_logic_vector(DWIDTH-1 downto 0);      -- Data Output - Port B
    signal kwb      : std_logic_vector(ceil2power(K)-1 downto 0) := (others =>'0');   -- K select for write - Port B
    signal krb      : std_logic_vector(ceil2power(K)-1 downto 0) := (others =>'0');   -- K select for read - Port A
    signal busya_o  : std_logic_vector(K-1 downto 0);   -- Busy bit output for addressed K buckets - Port A
    signal busyb_o  : std_logic_vector(K-1 downto 0);   -- Busy bit output for addressed K buckets - Port B
    signal emptya_o : std_logic_vector(K-1 downto 0);   -- Empty bit output for addressed K buckets - Port A
    signal emptyb_o : std_logic_vector(K-1 downto 0);   -- Empty bit output for addressed K buckets - Port B


begin

CLK_PROC: process
begin
    clk <= '1';
    wait for CLK_PERIOD/2;
    clk <= '0';
    wait for CLK_PERIOD/2;
end process;

RST_PROC: process
begin
    rst <= '1';
    wait for RST_TIME;
    rst <= '0';
    wait;
end process;

STIM_PROC: process
begin
    wait for RST_TIME;
    wait for CLK_PERIOD;
    -- Write
    for i in 0 to 10 loop
        for j in 0 to K-1 loop
            wea     <= '1';      -- Write Enable - Port A
            web     <= '1';      -- Write Enable - Port B
            dina    <= std_logic_vector(to_unsigned(2*K*i+j, DWIDTH));     -- Data Input - Port A
            addra   <= std_logic_vector(to_unsigned(2*i, AWIDTH));    -- Address Input - Port A
            kwa     <= std_logic_vector(to_unsigned(j, kwa'length));      -- K select for write - Port A
            dinb    <= std_logic_vector(to_unsigned(((2*i)+1)*K+j, DWIDTH));     -- Data Input - Port B
            addrb   <= std_logic_vector(to_unsigned((2*i)+1, AWIDTH));    -- Address Input - Port B
            kwb     <= std_logic_vector(to_unsigned(j, kwb'length));      -- K select for write - Port B
            wait for CLK_PERIOD;
        end loop;    
    end loop;
    -- Read
    for i in 0 to 10 loop
        for k in 0 to K-1 loop
            wea     <= '0';      -- Write Enable - Port A
            web     <= '0';      -- Write Enable - Port B
            dina    <= std_logic_vector(to_unsigned(2*i+k, DWIDTH));     -- Data Input - Port A
            addra   <= std_logic_vector(to_unsigned(2*i, AWIDTH));    -- Address Input - Port A
            kra     <= std_logic_vector(to_unsigned(k, kwa'length));      -- K select for write - Port A
            dinb    <= std_logic_vector(to_unsigned((2*i)+1+k, DWIDTH));     -- Data Input - Port B
            addrb   <= std_logic_vector(to_unsigned((2*i)+1, AWIDTH));    -- Address Input - Port B
            krb     <= std_logic_vector(to_unsigned(k, kwb'length));      -- K select for write - Port B
            wait for CLK_PERIOD;
        end loop;    
    end loop;
    -- Write / Read
    for i in 0 to 10 loop
        for k in 0 to K-1 loop
            wea     <= '1';      -- Write Enable - Port A
            web     <= '1';      -- Write Enable - Port B
            dina    <= std_logic_vector(to_unsigned(2*i+k, DWIDTH));     -- Data Input - Port A
            addra   <= std_logic_vector(to_unsigned(2*i, AWIDTH));    -- Address Input - Port A
            kra     <= std_logic_vector(to_unsigned(k, kwa'length));      -- K select for write - Port A
            kra     <= std_logic_vector(to_unsigned(k, kwa'length));      -- K select for read - Port A
            dinb    <= std_logic_vector(to_unsigned((2*i)+1+k, DWIDTH));     -- Data Input - Port B
            addrb   <= std_logic_vector(to_unsigned((2*i)+1, AWIDTH));    -- Address Input - Port B
            krb     <= std_logic_vector(to_unsigned(k, kwb'length));      -- K select for write - Port B
            krb     <= std_logic_vector(to_unsigned(k, kwb'length));      -- K select for read - Port A
            wait for CLK_PERIOD;
        end loop;    
    end loop;
    
end process STIM_PROC;


UUT: entity work.bucket_mem
  generic map(
    K      => K,      -- Frames
    DWIDTH => DWIDTH, -- Data Width
    AWIDTH => AWIDTH  -- Address Width
  )
  port map(
    clk     => clk,      -- Clock
    rst     => rst,      -- Reset
    wea     => wea,      -- Write Enable - Port A
    web     => web,      -- Write Enable - Port B
--  regcea  => regcea,   -- Output Register Enable - Port A
--  regceb  => regceb,   -- Output Register Enable - Port B
    dina    => dina,     -- Data Input - Port A
    addra   => addra,    -- Address Input - Port A
    douta   => douta,    -- Data Output - Port A
    kwa     => kwa,      -- K select for write - Port A
    kra     => kra,      -- K select for read - Port A
    dinb    => dinb,     -- Data Input - Port B
    addrb   => addrb,    -- Address Input - Port B
    doutb   => doutb,    -- Data Output - Port B
    kwb     => kwb,      -- K select for write - Port B
    krb     => krb,      -- K select for read - Port A
    busya_o  => busya_o,   -- Busy bit output for addressed K buckets - Port A
    busyb_o  => busyb_o,   -- Busy bit output for addressed K buckets - Port B
    emptya_o => emptya_o,  -- Empty bit output for addressed K buckets - Port A
    emptyb_o => emptyb_o   -- Empty bit output for addressed K buckets - Port B
  );


end architecture;