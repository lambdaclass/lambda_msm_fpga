library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uram_dp_wf is
  generic (
    AWIDTH : integer := 12;  -- Address Width
    DWIDTH : integer := 1152  -- Data Width
   );
port    (
    clk : in std_logic;                                  -- Clock 
    -- Port A
    wea : in std_logic;                                   -- Write Enable
    mem_ena : in std_logic;                               -- Memory Enable
    dina : in std_logic_vector(DWIDTH-1 downto 0);        -- Data Input  
    addra : in std_logic_vector(AWIDTH-1 downto 0);       -- Address Input
    douta : out std_logic_vector(DWIDTH-1 downto 0);      -- Data Output
    -- Port B
    web : in std_logic;                                   -- Write Enable
    mem_enb : in std_logic;                               -- Memory Enable
    dinb : in std_logic_vector(DWIDTH-1 downto 0);        -- Data Input  
    addrb : in std_logic_vector(AWIDTH-1 downto 0);       -- Address Input
    doutb : out std_logic_vector(DWIDTH-1 downto 0)       -- Data Output
   );
end uram_dp_wf;

architecture rtl of uram_dp_wf is

  constant C_AWIDTH : integer := AWIDTH;
  constant C_DWIDTH : integer := DWIDTH;
  
  -- Internal Signals
  type mem_t is array(natural range<>) of std_logic_vector(C_DWIDTH-1 downto 0);
  
  shared variable mem : mem_t(2**C_AWIDTH-1 downto 0);  -- Memory Declaration
  
  attribute ram_style : string;
  attribute ram_style of mem : variable is "ultra";

  attribute cascade_height : integer;
  attribute cascade_height of mem : variable is 16; 
  
begin
  
  -- Port B
  process(clk)
  begin
    if(rising_edge(clk))then
      if(mem_enb = '1') then
        if(web = '1') then
          mem(to_integer(unsigned(addrb))) := dinb;
        else
          doutb <= mem(to_integer(unsigned(addrb)));
        end if;
      end if;
    end if;
  end process;

  -- Port A
  process(clk)
  begin
    if(rising_edge(clk))then
      if(mem_ena = '1') then
        if(wea = '1') then
          mem(to_integer(unsigned(addra))) := dina;
        else
          douta <= mem(to_integer(unsigned(addra)));
        end if;
      end if;
    end if;
  end process;
    
end rtl;
