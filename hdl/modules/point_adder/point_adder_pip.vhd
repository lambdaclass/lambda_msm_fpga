library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config.all;
use work.pipeline_cfg.all;
use work.funciones.all;

--library UNISIM;
--use UNISIM.VComponents.all;

entity point_adder_pip is
    port (
        clk : in std_logic;
        rst : in std_logic;

        data_in_valid: in std_logic;
        data_out_valid: out std_logic;
        -- P1
        x1 : in std_logic_vector (N-1 downto 0);
        y1 : in std_logic_vector (N-1 downto 0);
        z1 : in std_logic_vector (N-1 downto 0); 
        -- P2 
        x2 : in std_logic_vector (N-1 downto 0);
        y2 : in std_logic_vector (N-1 downto 0);
        z2 : in std_logic_vector (N-1 downto 0);
        -- R
        xr : out std_logic_vector (N-1 downto 0);
        yr : out std_logic_vector (N-1 downto 0);
        zr : out std_logic_vector (N-1 downto 0)
    );
    constant DELAY : NATURAL := POINT_ADDER_DELAY;
end entity;

architecture full_pipelined of point_adder_pip is

    constant SUM  : std_logic := '0';
    constant DIFF : std_logic := '1';

    -- Circuit layer 1
    signal m11 : std_logic_vector(N-1 downto 0);
    signal m21 : std_logic_vector(N-1 downto 0);
    signal m31 : std_logic_vector(N-1 downto 0);
    signal a11 : std_logic_vector(N-1 downto 0);
    signal a21 : std_logic_vector(N-1 downto 0);
    signal a31 : std_logic_vector(N-1 downto 0);
    signal a41 : std_logic_vector(N-1 downto 0);
    signal a51 : std_logic_vector(N-1 downto 0);
    signal a61 : std_logic_vector(N-1 downto 0);

    -- Circuit layer 2
    signal a12 : std_logic_vector(N-1 downto 0);
    signal a22 : std_logic_vector(N-1 downto 0);
    signal a32 : std_logic_vector(N-1 downto 0);
    signal m12 : std_logic_vector(N-1 downto 0);
    signal m22 : std_logic_vector(N-1 downto 0);
    signal m32 : std_logic_vector(N-1 downto 0);

    -- Circuit layer 3
    signal d13      : std_logic_vector(N-1 downto 0);
    signal d23      : std_logic_vector(N-1 downto 0);
    signal c3m13    : std_logic_vector(N-1 downto 0);
    signal s13      : std_logic_vector(N-1 downto 0);
    signal s23      : std_logic_vector(N-1 downto 0);
    signal s33      : std_logic_vector(N-1 downto 0);

    -- Ciurcuit layer 4
    signal c3m14    : std_logic_vector(N-1 downto 0);
    signal a14      : std_logic_vector(N-1 downto 0);
    signal a14_d    : std_logic_vector(N-1 downto 0);

    signal s14      : std_logic_vector(N-1 downto 0);
    signal s14_d    : std_logic_vector(N-1 downto 0);

    signal d14      : std_logic_vector(N-1 downto 0);
    signal c3m24    : std_logic_vector(N-1 downto 0);
    signal d24      : std_logic_vector(N-1 downto 0);

    -- Ciurcuit layer 5
    signal m15 : std_logic_vector(N-1 downto 0);
    signal m25 : std_logic_vector(N-1 downto 0);
    signal m35 : std_logic_vector(N-1 downto 0);
    signal m45 : std_logic_vector(N-1 downto 0);
    signal m55 : std_logic_vector(N-1 downto 0);
    signal m65 : std_logic_vector(N-1 downto 0);

    -- Circuit layer 6 (output)
    signal s16 : std_logic_vector(N-1 downto 0);
    signal a26 : std_logic_vector(N-1 downto 0);
    signal a36 : std_logic_vector(N-1 downto 0);

    signal data_out_valid_slv: std_logic_vector(0 downto 0);

begin
    -- Layer 1
    UM11: entity work.mod_mul_pip
        port map(
            clk => clk,
            rst => rst,
            a => x1,
            b => x2,
            r => m11
        );
    
    UM21: entity work.mod_mul_pip
        port map(
            clk => clk,
            rst => rst,
            a => y1,
            b => y2,
            r => m21
        );

    UM31: entity work.mod_mul_pip
        port map(
            clk => clk,
            rst => rst,
            a => z1,
            b => z2,
            r => m31
        );

    UA11: entity work.mod_add_pip
            port map(
                clk => clk,
                rst => rst,
                x => x1,
                y => y1,
                op => SUM,
                result => a11
            );

    UA21: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => x2,
        y => y2,
        op => SUM,
        result => a21
    );

    UA31: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => x1,
        y => z1,
        op => SUM,
        result => a31
    );

    UA41: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => x2,
        y => z2,
        op => SUM,
        result => a41
    );

    UA51: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => y1,
        y => z1,
        op => SUM,
        result => a51
    );

    UA61: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => y2,
        y => z2,
        op => SUM,
        result => a61
    );

    -- Layer 2

    UA12: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => m11,
        y => m21,
        op => SUM,
        result => a12
    );    

    UA22: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => m11,
        y => m31,
        op => SUM,
        result => a22
    );    

    UA32: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => m21,
        y => m31,
        op => SUM,
        result => a32
    );    
   
    UM12: entity work.mod_mul_pip
        port map(
            clk => clk,
            rst => rst,
            a => a11,
            b => a21,
            r => m12
        );
    
    UM22: entity work.mod_mul_pip
        port map(
            clk => clk,
            rst => rst,
            a => a31,
            b => a41,
            r => m22
        );

    UM32: entity work.mod_mul_pip
        port map(
            clk => clk,
            rst => rst,
            a => a51,
            b => a61,
            r => m32
        );

    --Layer 3
    
    UD13: entity work.delay_M
        generic map(
            WORD_WIDTH => N,
            DELAY      => 2 * MODADD_DELAY
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => m11,
            s_delayed => d13
        );
        
    UD23: entity work.delay_M
        generic map(
            WORD_WIDTH => N,
            DELAY      => 2 * MODADD_DELAY
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => m21,
            s_delayed => d23
        );

    UM13: entity work.mod_mul_x3
        port map(
            clk => clk,
            rst => rst,
            x => m31,
            r => c3m13
        );

    US13: entity work.mod_add_pip
        port map(
            clk => clk,
            rst => rst,
            x => m12,
            y => a12,
            op => DIFF,
            result => s13
        );   

    US23: entity work.mod_add_pip
        port map(
            clk => clk,
            rst => rst,
            x => m22,
            y => a22,
            op => DIFF,
            result => s23
        );   

    US33: entity work.mod_add_pip
        port map(
            clk => clk,
            rst => rst,
            x => m32,
            y => a32,
            op => DIFF,
            result => s33
        );   

    -- Layer 4

    UM14: entity work.mod_mul_x3
        port map(
            clk => clk,
            rst => rst,
            x => d13,
            r => c3m14
        );

    UA14: entity work.mod_add_pip
        port map(
            clk => clk,
            rst => rst,
            x => d23,
            y => c3m13,
            op => SUM,
            result => a14
        ); 

    UA14_D: entity work.delay_M
        generic map(
            WORD_WIDTH => N,
            DELAY      => MODADD_DELAY
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => a14,
            s_delayed => a14_d
        );    

    US14: entity work.mod_add_pip
        port map(
            clk => clk,
            rst => rst,
            x => d23,
            y => c3m13,
            op => DIFF,
            result => s14
        );   

    US14_D: entity work.delay_M
        generic map(
            WORD_WIDTH => N,
            DELAY      => MODADD_DELAY
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => s14,
            s_delayed => s14_d
        );  

    UD14: entity work.delay_M
        generic map(
            WORD_WIDTH => N,
            DELAY      => 2 * MODADD_DELAY
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => s13,
            s_delayed => d14
        );    

    UM24: entity work.mod_mul_x3
    port map(
        clk => clk,
        rst => rst,
        x => s23,
        r => c3m24
    );

    UD24: entity work.delay_M
    generic map(
        WORD_WIDTH => N,
        DELAY      => 2 * MODADD_DELAY
    )
    port map(
        clk       => clk,
        rst       => rst,
        s         => s33,
        s_delayed => d24
    );

    -- Layer 5

    UM15: entity work.mod_mul_pip
    port map(
        clk => clk,
        rst => rst,
        a => s14_d,
        b => d14,
        r => m15
    );

    UM25: entity work.mod_mul_pip
    port map(
        clk => clk,
        rst => rst,
        a => c3m24,
        b => d24,
        r => m25
    );

    UM35: entity work.mod_mul_pip
    port map(
        clk => clk,
        rst => rst,
        a => a14_d,
        b => s14_d,
        r => m35
    );

    UM45: entity work.mod_mul_pip
    port map(
        clk => clk,
        rst => rst,
        a => c3m14,
        b => c3m24,
        r => m45
    );

    UM55: entity work.mod_mul_pip
    port map(
        clk => clk,
        rst => rst,
        a => a14_d,
        b => d24,
        r => m55
    );
    
    UM65: entity work.mod_mul_pip
    port map(
        clk => clk,
        rst => rst,
        a => c3m14,
        b => d14,
        r => m65
    );

    -- Layer 6

    US16: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => m15,
        y => m25,
        op => DIFF,
        result => s16
    );   

    UA26: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => m35,
        y => m45,
        op => SUM,
        result => a26
    );       

    UA36: entity work.mod_add_pip
    port map(
        clk => clk,
        rst => rst,
        x => m55,
        y => m65,
        op => SUM,
        result => a36
    );    

    -- output
    xr <= s16;
    yr <= a26;
    zr <= a36;

    --processing delay 

    data_valid: entity work.delay_M
        generic map(
            WORD_WIDTH => 1,
            DELAY      => POINT_ADDER_DELAY
        )
        port map(
            clk       => clk,
            rst       => rst,
            s         => to_slv(data_in_valid),
            s_delayed => data_out_valid_slv
        );

        data_out_valid <= data_out_valid_slv(0);
end architecture;