library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.funciones.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity kara_mul_high is
    generic(
        N : natural := 66;  -- Operands bit size
        K : natural := 14;  -- Partition
        D : natural := 7; -- Tree depth
        L : natural := 1  -- Current tree level
    );
    port (
        x : in  std_logic_vector (N-1 downto 0);
        y : in  std_logic_vector (N-1 downto 0);
        z : out std_logic_vector (2*N-1 downto N)
    );
end entity;

architecture structural of kara_mul_high is

    signal x0 : unsigned(K-1 downto 0);
    signal x1 : unsigned(N-K-1 downto 0);

    signal y0 : unsigned(K-1 downto 0);
    signal y1 : unsigned(N-K-1 downto 0);

    signal x_0 : unsigned(maximum(K, N-K) downto 0);
    signal y_1 : unsigned(maximum(K, N-K) downto 0);
    signal x_1 : unsigned(maximum(K, N-K) downto 0);
    signal y_0 : unsigned(maximum(K, N-K) downto 0);

    signal kmul1  : std_logic_vector(2*(N-K) -1 downto 0);
    signal kmul1_extended : unsigned((2*K)+kmul1'high downto 0);
    
    
    signal kmul2  : std_logic_vector(2*maximum(K, N - K ) + 1  downto 0);
    signal z_kmul2 : std_logic_vector(N - K  downto 0);
    
    signal kmul3  : std_logic_vector(2*maximum(K, N - K ) + 1  downto 0);
    signal z_kmul3 : std_logic_vector(N - K  downto 0);
    
     
    signal add1 : unsigned(2*maximum(K, N - K ) + 1  downto 0);   
    signal add1_extended  : unsigned(K+add1'high downto 0);
    
    signal add2 : unsigned((2*K)+kmul1'high downto 0); 
  

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
    
    KARA_MUL_1: entity work.kara_mul
    generic map(
        N => (N - K),
        K => get_partition(N-K),
        D => D,
        L => L+1
        )
    port map (
        x => std_logic_vector(x1),
        y => std_logic_vector(y1),
        z => kmul1
        );
               
    KARA_MUL_2: entity work.kara_mul_high
    generic map(
        N => maximum(K, N-K) + 1,
        K => get_partition(maximum(K, N-K) + 1), 
        D => D,
        L => L+1
        )
    port map (
        x => std_logic_vector(x_1),
        y => std_logic_vector(y_0),
        z => z_kmul2
        );
        
    KARA_MUL_3: entity work.kara_mul_high
    generic map(
        N => maximum(K, N-K) + 1,
        K => get_partition(maximum(K, N-K) + 1), 
        D => D,
        L => L+1
        )
    port map (
        x => std_logic_vector(x_0),
        y => std_logic_vector(y_1),
        z => z_kmul3
        );
       
        
    end generate;

    U0_DSP: if (maximum(K, N-K)<= 18) generate

          kmul1 <= std_logic_vector(x1 * y1);
          kmul2 <= std_logic_vector(x_1 * y_0);
          kmul3 <= std_logic_vector(x_0 * y_1);

    end generate;
    
    
    kmul1_extended(kmul1_extended'high downto kmul1_extended'high-kmul1'high) <= unsigned(kmul1);
    kmul1_extended(kmul1_extended'high - kmul1'high - 1 downto 0) <= (others => '0');

    add1 <= unsigned(kmul2) + unsigned(kmul3); --ranges
    
    add1_extended(add1_extended'high downto add1_extended'high - add1'high) <= add1;
    add1_extended(add1_extended'high - add1'high - 1 downto 0) <= (others =>'0');

    add2 <= unsigned(kmul1_extended) + add1_extended;
    
    -- Completar pipeline
    z <= std_logic_vector(add2(2*N-1 downto N));

                    
end architecture;
