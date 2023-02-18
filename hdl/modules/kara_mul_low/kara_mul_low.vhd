library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.funciones.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity kara_mul_low is
    generic(
        N : natural := 118;  -- Operands bit size
        K : natural := 52;  -- Partition
        D : natural := 5; -- Tree depth
        L : natural := 1;  -- Current tree level
        s : natural := 2  -- Sigma
    );
    port (
        x : in  std_logic_vector (N-1 downto 0);
        y : in  std_logic_vector (N-1 downto 0);
        z : out std_logic_vector (N+s-1 downto 0)
    );
end entity;

architecture structural of kara_mul_low is

    signal x0 : unsigned(K-1 downto 0);
    signal x1 : unsigned(N-K-1 downto 0);

    signal y0 : unsigned(K-1 downto 0);
    signal y1 : unsigned(N-K-1 downto 0);

    signal x_0 : unsigned(maximum(K, N-K) downto 0);
    signal y_1 : unsigned(maximum(K, N-K) downto 0);
    signal x_1 : unsigned(maximum(K, N-K) downto 0);
    signal y_0 : unsigned(maximum(K, N-K) downto 0);

    signal kmul0  : std_logic_vector(2*K - 1 downto 0);
    signal kmul1  : std_logic_vector(2*maximum(K, N - K ) + 1  downto 0);
    signal kmul2  : std_logic_vector(2*maximum(K, N - K ) + 1  downto 0);
   
    signal z_kmul1 : std_logic_vector(N + s - K  downto 0);
    signal z_kmul2 : std_logic_vector(N + s - K  downto 0);
     
    signal add1 : unsigned(2*maximum(K, N - K ) + 1  downto 0);   
    signal add1_extended  : unsigned(K+add1'high downto 0);
    
    signal add2 : unsigned(K+add1'high downto 0); 
  

begin

    x0 <= unsigned(x(K-1 downto 0));
    y0 <= unsigned(y(K-1 downto 0));

    x1 <= unsigned(x(N-1 downto K));
    y1 <= unsigned(y(N-1 downto K));

    x_0 <= resize(x0, maximum(K, N-K) + 1); -- revisar extensión
    y_1 <= resize(y1, maximum(K, N-K) + 1);
    y_0 <= resize(y0, maximum(K, N-K) + 1); -- revisar extensión
    x_1 <= resize(x1, maximum(K, N-K) + 1);


    U0_RECURSE : if (maximum(K, N-K) > 18) generate
    
    KARA_MUL_1: entity work.kara_mul_low
    generic map(
        s => N + s - K - maximum(K, N-K),
        N => maximum(K, N-K) + 1,
        K => get_partition(maximum(K, N-K) + 1),-- get_partition_low(N-K),
        D => D,
        L => L+1
        )
    port map (
        x => std_logic_vector(x_0),
        y => std_logic_vector(y_1),
        z => z_kmul1
        );
        
     -- kmul1(N+s-1 downto 0) <= z_kmul1;
            
    KARA_MUL_0: entity work.kara_mul
    generic map(
        N => K,
        K => get_partition(K),
        D => D,
        L => L+1
        )
    port map (
        x => std_logic_vector(x0),
        y => std_logic_vector(y0),
        z => kmul0
        );
        
    KARA_MUL_2: entity work.kara_mul_low
    generic map(
        s => N + s - K - maximum(K, N-K),
        N => maximum(K, N-K) + 1,
        K => get_partition(maximum(K, N-K) + 1), --get_partition_low(maximum(K, N-K)),
        D => D,
        L => L+1
        )
    port map (
        x => std_logic_vector(x_1),
        y => std_logic_vector(y_0),
        z => z_kmul2
        );
    end generate;

    U0_DSP: if (maximum(K, N-K)<= 18) generate

          kmul0 <= std_logic_vector(x0 * y0);
          kmul1 <= std_logic_vector(x_0 * y_1);
          kmul2 <= std_logic_vector(x_1 * y_0);

    end generate;

    add1 <= unsigned(kmul2) + unsigned(kmul1); --ranges
    
    add1_extended(add1_extended'high downto add1_extended'high - add1'high) <= add1;
    add1_extended(add1_extended'high - add1'high - 1 downto 0) <= (others =>'0');

    add2 <= unsigned(kmul0) + add1_extended;
    
    -- Completar pipeline
    z <= std_logic_vector(add2(N+s-1 downto 0));

                    
end architecture;
