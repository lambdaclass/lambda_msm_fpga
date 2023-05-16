library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.funciones.all;
use work.config.all;
use work.tipos.all;

entity bucket_mem is
  generic(
    K      : integer := 22;      -- 29 Frames
    DWIDTH : integer := 72*16;  -- 72*16N * 3;   -- Data Width
    AWIDTH : integer := 12     --253 Address Width
  );
  port(
    clk         : in std_logic;                                  -- Clock
--    rst         : in std_logic;                                  -- Reset

    port_a      : in memory_in_t;
    port_b      : in memory_in_t;

    kwa         : in std_logic_vector(ceil2power(K)-1 downto 0);-- K select for write - Port A
    kra         : in std_logic_vector(ceil2power(K)-1 downto 0);-- K select for read - Port A
    kwb         : in std_logic_vector(ceil2power(K)-1 downto 0); -- K select for write - Port B
    krb         : in std_logic_vector(ceil2power(K)-1 downto 0); -- K select for read - Port A

    -- Flags
    busya_o     : out std_logic_vector(K-1 downto 0);   -- Busy bit output for addressed K buckets - Port A
    busyb_o     : out std_logic_vector(K-1 downto 0);   -- Busy bit output for addressed K buckets - Port B
    emptya_o    : out std_logic_vector(K-1 downto 0);   -- Empty bit output for addressed K buckets - Port A
    emptyb_o    : out std_logic_vector(K-1 downto 0);    -- Empty bit output for addressed K buckets - Port B

    mem_out     : out dp_memory_out_t
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
      dina    => port_a.din,      -- Data Input - Port A
      addra   => port_a.addr,   
      douta   => douta_k(i),-- Data Output - Port A
      dinb    => port_b.din,      -- Data Input - Port B
      addrb   => port_b.addr,     -- Address Input - Port B
      doutb   => doutb_k(i) -- Data Output - Port B
    );

    busya_o(i) <= douta_k(i)(DWIDTH-1);
    busyb_o(i) <= doutb_k(i)(DWIDTH-1);

    emptya_o(i) <= douta_k(i)(DWIDTH-2);
    emptyb_o(i) <= doutb_k(i)(DWIDTH-2);

    end generate;

  U1A_WEA_DECODER: process(kwa, port_a)
    begin
      wea_k <= (others => '0');   -- default
      wea_k(to_integer(unsigned(kwa))) <= port_a.we;
    end process;

  U1B_WEB_DECODER: process(kwb, port_b)
    begin
      web_k <= (others => '0');   -- default
      web_k(to_integer(unsigned(kwb))) <= port_b.we;
    end process;

  U2A_DOUT_MUX: process(kra_d, douta_k)
  begin
    mem_out.douta <= douta_k(to_integer(unsigned(kra_d)));
  end process;

  U2B_DOUT_MUX: process(krb_d, doutb_k)
  begin
    mem_out.doutb <= doutb_k(to_integer(unsigned(krb_d)));
  end process;

  U3_DELAYS_PROC: process(clk)
  begin
    if rising_edge(clk) then
      kra_d <= kra;
      krb_d <= krb;
    end if;
  end process;

end rtl;
