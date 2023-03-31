library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.funciones.all;
use work.config.all;

entity bucket_mem is
  generic(
    K      : integer := 3;      -- 29 Frames
    DWIDTH : integer := 72*5;  -- 72*16N * 3;   -- Data Width
    AWIDTH : integer := 12*3     --253 Address Width
  );
  port(
    clk         : in std_logic;                                  -- Clock
    rst         : in std_logic;                                  -- Reset
    -- Port A
    wea         : in std_logic;                                  -- Write Enable - Port A
    dina        : in std_logic_vector(DWIDTH-1 downto 0);       -- Data Input - Port A
    addra       : in std_logic_vector(AWIDTH-1 downto 0);      -- Address Input - Port A
    douta       : out std_logic_vector(DWIDTH-1 downto 0);      -- Data Output - Port A
    kwa         : in std_logic_vector(ceil2power(K)-1 downto 0);-- K select for write - Port A
    kra         : in std_logic_vector(ceil2power(K)-1 downto 0);-- K select for read - Port A
    -- Port B
    web         : in std_logic;                                  -- Write Enable - Port B
    dinb        : in std_logic_vector(DWIDTH-1 downto 0);       -- Data Input - Port B
    addrb       : in std_logic_vector(AWIDTH-1 downto 0);      -- Address Input - Port B
    doutb       : out std_logic_vector(DWIDTH-1 downto 0);     -- Data Output - Port B
    kwb         : in std_logic_vector(ceil2power(K)-1 downto 0); -- K select for write - Port B
    krb         : in std_logic_vector(ceil2power(K)-1 downto 0); -- K select for read - Port A
    -- Flags
    busya_o     : out std_logic_vector(K-1 downto 0);   -- Busy bit output for addressed K buckets - Port A
    busyb_o     : out std_logic_vector(K-1 downto 0);   -- Busy bit output for addressed K buckets - Port B
    emptya_o    : out std_logic_vector(K-1 downto 0);   -- Empty bit output for addressed K buckets - Port A
    emptyb_o    : out std_logic_vector(K-1 downto 0)    -- Empty bit output for addressed K buckets - Port B
  );
end bucket_mem;

architecture rtl of bucket_mem is

  signal wea_k : std_logic_vector(K-1 downto 0);
  signal web_k : std_logic_vector(K-1 downto 0);

  signal kra_d : std_logic_vector(ceil2power(K)-1 downto 0);
  signal krb_d : std_logic_vector(ceil2power(K)-1 downto 0);

  type out_bus is array(natural range<>) of std_logic_vector(DWIDTH-1 downto 0);
  signal douta_k : out_bus(K-1 downto 0);
  signal doutb_k : out_bus(K-1 downto 0);

begin

U0_URAMS: for i in 0 to K-1 generate

  U_RAM: entity work.uram_dp_wf
    generic map(
      AWIDTH => AWIDTH,  -- Address Width
      DWIDTH => DWIDTH        -- Data Width 
    )
    port map(
      clk     => clk,       -- 
      wea     => wea_k(i),  -- Write Enable - Port A
      web     => web_k(i),  -- Write Enable - Port B
      mem_ena  => '1',      -- Memory Enable - Port A
      mem_enb  => '1',      -- Memory Enable - Port B
      dina    => dina,      -- Data Input - Port A
      addra   => addra,   
      douta   => douta_k(i),-- Data Output - Port A
      dinb    => dinb,      -- Data Input - Port B
      addrb   => addrb,     -- Address Input - Port B
      doutb   => doutb_k(i) -- Data Output - Port B
    );

    busya_o(i) <= douta_k(i)(DWIDTH-1);
    busyb_o(i) <= doutb_k(i)(DWIDTH-1);

    emptya_o(i) <= douta_k(i)(DWIDTH-2);
    emptyb_o(i) <= doutb_k(i)(DWIDTH-2);

    end generate;

  U1A_WEA_DECODER: process(kwa, wea)
    begin
      wea_k <= (others => '0');   -- default
      wea_k(to_integer(unsigned(kwa))) <= wea;
    end process;

  U1B_WEB_DECODER: process(kwb, web)
    begin
      web_k <= (others => '0');   -- default
      web_k(to_integer(unsigned(kwb))) <= web;
    end process;

  U2A_DOUT_MUX: process(kra_d, douta_k)
  begin
    douta <= douta_k(to_integer(unsigned(kra_d)));
  end process;

  U2B_DOUT_MUX: process(krb_d, doutb_k)
  begin
    doutb <= doutb_k(to_integer(unsigned(krb_d)));
  end process;

  U3_DELAYS_PROC: process(clk)
  begin
    if rising_edge(clk) then
      kra_d <= kra;
      krb_d <= krb;
    end if;
  end process;

end rtl;
