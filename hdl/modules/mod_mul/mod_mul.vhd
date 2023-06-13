library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.funciones.all;

-- Defines N_vect (number of bits) and q prime: 
use work.config.all;
use work.pipeline_cfg.all;

--library UN_vectISIM;
--use UN_vectISIM.VComponents.all;

entity mod_mul is
    generic(PIPELINED : string := "NO");
    port (
        clk : in std_logic;
        rst : in std_logic;
        a : in std_logic_vector (N_vect-1 downto 0);
        b : in std_logic_vector (N_vect-1 downto 0);
        r : out std_logic_vector (N_vect-1 downto 0) 
    );
end entity;

architecture structural of mod_mul is

    signal mult_int : std_logic_vector(2*N_vect-1 downto 0);--unsigned(2*N_vect-1 downto 0);
    signal mult_hi  : unsigned(N_vect-1 downto 0);
    signal mult_lo  : unsigned(N_vect+1 downto 0);

    signal l1    : unsigned(N_vect-1 downto 0);
    signal l1_int: unsigned(2*N_vect downto 0);
    signal lq_int: unsigned(2*N_vect-1 downto 0);  --: unsigned(2*N_vect-1 downto 0);
    signal lq    : unsigned(N_vect+1 downto 0);

    signal kq : unsigned(N_vect+1 downto 0);

    signal kq1 : unsigned(N_vect+1 downto 0);
    signal kq2 : unsigned(N_vect+1 downto 0);
    signal kq3 : unsigned(N_vect+1 downto 0);

    signal r_int : unsigned(N_vect+1 downto 0);
    signal rf    : unsigned(N_vect+1 downto 0);
    
    constant q_ext: unsigned(N_vect+1 downto 0) := "00" & q;

    -- k=N_vect
    constant k: natural := N_vect;

    -- m = (2^(k+N_vect))//q
    constant m : unsigned(N_vect downto 0) := "10" & x"61508d0cc4060e976c3ca0582ef4f73bbad0de6776b1a06af2d488d85a6d02d0ed687789c42a591f9fd58c5e4daffc";
    
    -- For debugging:
    -- constant m : unsigned(N_vect downto 0) := '1' & x"05";

    -- attribute use_dsp : string;
    -- attribute use_dsp of l1_int : signal is "no";

begin

    -- mult_int <= unsigned(a) * unsigned(b);
    U0: if (PIPELINED = "NO") generate
        U0_MULT: entity work.kara_mul(combinational)
        generic map(
            N => N_vect,                  -- Operands bit size
            K => get_partition(N_vect),   -- Partition
            D => KARAMUL_TREE_DEPTH, -- Tree depth
            L => 1                   -- Current tree level
        )
        port map(
            clk => GND,
            rst => GND,
            x => a,
            y => b,
            z => mult_int 
            );
    else generate

        U0_MULT: entity work.kara_mul(full_pipelined)
        generic map(
            N => N_vect,                  -- Operands bit size
            K => get_partition(N_vect),   -- Partition
            D => KARAMUL_TREE_DEPTH, -- Tree depth
            L => 1                   -- Current tree level
        )
        port map(
            clk => clk,
            rst => rst,
            x => a,
            y => b,
            z => mult_int 
            );

    end generate;

    mult_hi <= unsigned(mult_int((2*N_vect)-1 downto N_vect));
    mult_lo <= unsigned(mult_int(N_vect+1 downto 0));

    l1_int  <= mult_hi * m;
    l1      <= l1_int(2*N_vect-1 downto N_vect);

    lq_int <= l1 * q;
    -- Flopoco:
--  U1_CON_vectST_MULT: entity work.IntConstMult_377
--  port map(
--      clk => clk,
--      X   => std_logic_vector(l1),
--      R   => lq_int
--  );
    lq    <= unsigned(lq_int(N_vect+1 downto 0));

    r_int <= unsigned(mult_lo) - lq;

    -- Synth optimizes...
    kq1 <= to_unsigned(1, 2) * q;
    kq2 <= to_unsigned(2, 2) * q;
    kq3 <= to_unsigned(3, 2) * q;
    -- ... and produces the same output as:
    -- kq1 <= "00" & q;
    -- kq2 <= '0' & q & '0';
    -- kq3 <= unsigned("00" & q) + unsigned('0' & q & '0');

    kq <= (others => '0') when r_int < q_ext else
          kq1             when r_int < kq2 else
          kq2             when r_int < kq3 else
          kq3;

    rf <= r_int - kq;

    r <= std_logic_vector(rf(N_vect-1 downto 0));

end structural;
