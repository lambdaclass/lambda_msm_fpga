library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config.all;
use work.pipeline_cfg.all;
use work.funciones.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity kara_mul is
    generic(
        N : natural := 377;                 -- Operands bit size
        K : natural := get_partition(377);  -- Partition
        D : natural := 5;                   -- Tree depth
        L : natural := 1                    -- Current tree level
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        x   : in std_logic_vector(N-1 downto 0);
        y   : in std_logic_vector(N-1 downto 0);
        z   : out std_logic_vector(2*N - 1 downto 0) 
    );
end entity;


-- Full combinational architecture (for fully-pipeline architecture see below)
-- Note: Tools will sinthesize last architecture by default.
architecture combinational of kara_mul is

    signal x0 : unsigned(K-1 downto 0);
    signal x1 : unsigned(N-K-1 downto 0);

    signal y0 : unsigned(K-1 downto 0);
    signal y1 : unsigned(N-K-1 downto 0);

    signal x_sum : unsigned(maximum(K, N-K) downto 0);
    signal y_sum : unsigned(maximum(K, N-K) downto 0);

    signal kmul0 : std_logic_vector(2*K - 1 downto 0);
    signal kmul1 : std_logic_vector(2*((N-K)) -1 downto 0);
    signal kmul2 : std_logic_vector(2*(maximum(K, N - K) + 1) -1 downto 0);

    signal sub1 : unsigned(kmul2'high downto 0);
    signal sub2 : unsigned(sub1'high downto 0);

    signal sub2_extended  : unsigned(K+sub2'high downto 0);
    signal kmul1_extended : unsigned((2*K)+kmul1'high downto 0);

    signal add1 : unsigned(maximum(kmul1_extended'high, sub2_extended'high) downto 0);
    signal add2 : unsigned(2*N - 1 downto 0);

    attribute use_dsp : string;
    attribute use_dsp of sub1 : signal is "no";
    attribute use_dsp of sub2 : signal is "no";
    attribute use_dsp of add1 : signal is "no";
    attribute use_dsp of add2 : signal is "no";

begin

    x0 <= unsigned(x(K-1 downto 0));
    y0 <= unsigned(y(K-1 downto 0));

    x1 <= unsigned(x(N-1 downto K));
    y1 <= unsigned(y(N-1 downto K));

    x_sum <= resize(x0, maximum(K, N-K) + 1) + resize(x1, maximum(K, N-K) + 1);
    y_sum <= resize(y0, maximum(K, N-K) + 1) + resize(y1, maximum(K, N-K) + 1);


    -- Sub-products
    ---------------

    U0_RECURSE : if (K > DSP_SIZE) generate
        KARA_MUL_0: entity work.kara_mul(combinational)
        generic map(
            N => K,
            K => get_partition(K),
            D => D,
            L => L+1
            )
        port map (
            clk => '0',
            rst => '0',
            x   => std_logic_vector(x0),
            y   => std_logic_vector(y0),
            z   => kmul0
            );
    end generate;

    U1_RECURSE : if ((N - K) > DSP_SIZE) generate
        KARA_MUL_1: entity work.kara_mul(combinational)
        generic map(
            N => (N - K),
            K => get_partition(N-K),
            D => D,
            L => L+1
            )
        port map (
            clk => '0',
            rst => '0',
            x   => std_logic_vector(x1),
            y   => std_logic_vector(y1),
            z   => kmul1
            );
            
        KARA_MUL_2: entity work.kara_mul(combinational)
        generic map(
            N => maximum(K, N-K) + 1,
            K => get_partition(maximum(K, N-K) + 1),
            D => D,
            L => L+1
            )
        port map (
            clk => '0',
            rst => '0',
            x   => std_logic_vector(x_sum),
            y   => std_logic_vector(y_sum),
            z   => kmul2
            );
    end generate;

    -- If operands fit within one DSP (end recusion):
    U0_DSP: if (K <= DSP_SIZE) generate
        kmul0 <= std_logic_vector(x0 * y0);
    end generate;

    U1_DSP: if ((N - K) <= DSP_SIZE) generate
        kmul1 <= std_logic_vector(x1 * y1);
        kmul2 <= std_logic_vector(x_sum * y_sum);
    end generate;

    sub1 <= unsigned(kmul2) - resize(unsigned(kmul1),2*(maximum(K, N - K) + 1) - 1);
    sub2 <= sub1 - resize(unsigned(kmul0),2*(maximum(K, N - K) + 1) - 1);

    sub2_extended(sub2_extended'high downto sub2_extended'high - sub2'high) <= sub2;
    sub2_extended(sub2_extended'high - sub2'high - 1 downto 0) <= (others =>'0');

    kmul1_extended(kmul1_extended'high downto kmul1_extended'high-kmul1'high) <= unsigned(kmul1);
    kmul1_extended(kmul1_extended'high - kmul1'high - 1 downto 0) <= (others => '0');

    add1 <= sub2_extended + kmul1_extended;
    add2 <= add1 + unsigned(kmul0);

    z <= std_logic_vector(add2);

end architecture;


-- Full pipelined architecture: 5 delays per tree level
architecture full_pipelined of kara_mul is

    signal x0 : unsigned(K-1 downto 0);
    signal x1 : unsigned(N-K-1 downto 0);

    signal y0 : unsigned(K-1 downto 0);
    signal y1 : unsigned(N-K-1 downto 0);

    signal x_sum : unsigned(maximum(K, N-K) downto 0);
    signal y_sum : unsigned(maximum(K, N-K) downto 0);

    signal x0_d : unsigned(K-1 downto 0);
    signal x1_d : unsigned(N-K-1 downto 0);

    signal y0_d : unsigned(K-1 downto 0);
    signal y1_d : unsigned(N-K-1 downto 0);

    signal kmul0 : std_logic_vector(2*K - 1 downto 0);
    signal kmul1 : std_logic_vector(2*((N-K)) -1 downto 0);
    signal kmul2 : std_logic_vector(2*(maximum(K, N - K) + 1) -1 downto 0);

    signal kmul0_d : std_logic_vector(2*K - 1 downto 0);
    signal kmul1_dd : std_logic_vector(2*((N-K)) -1 downto 0);
    signal kmul2_d : std_logic_vector(2*(maximum(K, N - K) + 1) -1 downto 0);

    signal kmul0_dd : std_logic_vector(2*K - 1 downto 0);

    signal dsp_kmul0 : std_logic_vector(2*K - 1 downto 0);
    signal dsp_kmul1 : std_logic_vector(2*((N-K)) -1 downto 0);
    signal dsp_kmul2 : std_logic_vector(2*(maximum(K, N - K) + 1) -1 downto 0);

    signal sub1 : unsigned(kmul2'high downto 0);
    signal sub2 : unsigned(sub1'high downto 0);

    signal sub2_extended  : unsigned(K+sub2'high downto 0);
    signal kmul1_extended : unsigned((2*K)+kmul1'high downto 0);

    signal add1 : unsigned(maximum(kmul1_extended'high, sub2_extended'high) downto 0);
    signal add2 : unsigned(2*N - 1 downto 0); -- r?

    -- Limits DSP inference to multiplications
    attribute use_dsp : string;
    attribute use_dsp of sub1 : signal is "no";
    attribute use_dsp of sub2 : signal is "no";
    attribute use_dsp of add1 : signal is "no";
    attribute use_dsp of add2 : signal is "no";


begin

    x0 <= unsigned(x(K-1 downto 0));
    y0 <= unsigned(y(K-1 downto 0));
    x1 <= unsigned(x(N-1 downto K));
    y1 <= unsigned(y(N-1 downto K));


    -- Inputs pipeline
    ------------------
    U_IN_PIPE: process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                x0_d <= (others => '0');
                x1_d <= (others => '0');
    
                y0_d <= (others => '0');
                y1_d <= (others => '0');
    
                x_sum <= (others => '0');
                y_sum <= (others => '0');
            else
                x0_d <= x0;
                x1_d <= x1;

                y0_d <= y0;
                y1_d <= y1;

                x_sum <= resize(x0, maximum(K, N-K) + 1) + resize(x1, maximum(K, N-K) + 1);
                y_sum <= resize(y0, maximum(K, N-K) + 1) + resize(y1, maximum(K, N-K) + 1);
            end if;
        end if;
    end process;


    -- Sub-products
    ---------------

    U0_RECURSE: if (K > DSP_SIZE) generate
    
    KARA_MUL_0: entity work.kara_mul(full_pipelined)
        generic map(
            N => K,
            K => get_partition(K),
            D => D,
            L => L+1
            )
        port map (
            clk => clk,
            rst => rst,
            x   => std_logic_vector(x0_d),
            y   => std_logic_vector(y0_d),
            z   => kmul0
            );
    end generate;

    U1_RECURSE: if (N - K > DSP_SIZE) generate
        KARA_MUL_1: entity work.kara_mul(full_pipelined)
        generic map(
            N => (N - K),
            K => get_partition(N-K),
            D => D,
            L => L+1
            )
        port map (
            clk => clk,
            rst => rst,
            x   => std_logic_vector(x1_d),
            y   => std_logic_vector(y1_d),
            z   => kmul1
            );
            
        KARA_MUL_2: entity work.kara_mul(full_pipelined)
        generic map(
            N => maximum(K, N-K) + 1,
            K => get_partition(maximum(K, N-K) + 1),
            D => D,
            L => L+1
            )
        port map (
            clk => clk,
            rst => rst,
            x   => std_logic_vector(x_sum),
            y   => std_logic_vector(y_sum),
            z   => kmul2
            );
    end generate;

    -- If operands fit within one DSP (end recusion):

    U0_DSP: if K <= DSP_SIZE generate
        dsp_kmul0 <= std_logic_vector(x0_d * y0_d);

        U_SYNC_DSP0: entity work.delay_M
        generic map(
            WORD_WIDTH => kmul0'length,
            DELAY      => (D-L)*KARAMUL_DELAY_PER_LEVEL
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => dsp_kmul0,
            s_delayed => kmul0
        );
    end generate;
    
    -- Syncs results if its a leaf of the tree that is not in the last level
    U1_DSP: if (N - K <= DSP_SIZE) generate
        dsp_kmul1 <= std_logic_vector(x1_d * y1_d);
        dsp_kmul2 <= std_logic_vector(x_sum * y_sum);

        U_SYNC_DSP1: entity work.delay_M
        generic map(
            WORD_WIDTH => kmul1'length,
            DELAY      => (D-L)*KARAMUL_DELAY_PER_LEVEL
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => dsp_kmul1,
            s_delayed => kmul1
        );

        U_SYNC_DSP2: entity work.delay_M
        generic map(
            WORD_WIDTH => kmul2'length,
            DELAY      => (D-L)*KARAMUL_DELAY_PER_LEVEL
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => dsp_kmul2,
            s_delayed => kmul2
        );
    end generate;
  
    -- Ouputs pipeline
    ------------------

    U_PIPE1: process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                sub2        <= (others => '0');
                sub1        <= (others => '0');
                kmul0_d     <= (others => '0');
            else
                sub2        <= sub1 - resize(unsigned(kmul0_d),2*(maximum(K, N - K) + 1) - 1);
                sub1        <= unsigned(kmul2) - resize(unsigned(kmul1),2*(maximum(K, N - K) + 1) - 1);
                kmul0_d     <= kmul0;
            end if;
        end if;
    end process;

    U_DELAY_KMUL1: entity work.delay_M
    generic map(
        WORD_WIDTH => kmul1'length,
        DELAY      => 2
    )
    port map(
        clk       => clk,
        rst       => rst,
        s         => kmul1,
        s_delayed => kmul1_dd
    );

    U_DELAY_KMUL0: entity work.delay_M
    generic map(
        WORD_WIDTH => kmul0'length,
        DELAY      => 2
    )
    port map(
        clk       => clk,
        rst       => rst,
        s         => kmul0_d,
        s_delayed => kmul0_dd
    );

    sub2_extended(sub2_extended'high downto sub2_extended'high - sub2'high) <= sub2;
    sub2_extended(sub2_extended'high - sub2'high - 1 downto 0) <= (others =>'0');

    kmul1_extended(kmul1_extended'high downto kmul1_extended'high-kmul1_dd'high) <= unsigned(kmul1_dd);
    kmul1_extended(kmul1_extended'high - kmul1_dd'high - 1 downto 0) <= (others => '0');

    U_PIPE2: process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                add1 <= (others => '0');
                add2 <= (others => '0');
            else    
                add1 <= sub2_extended + kmul1_extended;
                add2 <= add1 + unsigned(kmul0_dd);
            end if;
        end if;
    end process;

    z <= std_logic_vector(add2);

end architecture;
