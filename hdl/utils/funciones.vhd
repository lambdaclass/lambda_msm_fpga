library IEEE;
--library UTILS;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.TIPOS.all;

--* @brief Librería de funciones básicas
package funciones is

  --* Devuelve la mínima potencia de 2 mayor o igual a <var>N</var>
  function ceil2power (N   :    natural) return natural;
  --* Devuelve la mínima potencia de <var>radix</var> mayor o igual 
  --* a <var>N</var>
  function ceilpower (N    : in natural; radix : in natural) return natural;
  --* Devuelve un std_logic_vector de <var>int</var> ceros
  function zeros(int       : in integer) return std_logic_vector;
  --* Convierte un std_logic a un std_logic_vector(0 downto 0)
  function to_slv(sl       : in std_logic) return std_logic_vector;
  --* Convierte un natural a un std_logic_vector de largo<var>b</var> 
  function to_slv(n, b     :    natural) return std_logic_vector;
  --* Convierte un std_logic_vector(0 downto 0) a un std_logic
  function to_sl(slv       : in std_logic_vector) return std_logic;
  --* Incrementa en 1 el valor sin signo del std_logic_vector
  function increment(value : in std_logic_vector) return std_logic_vector;
  --* Incrementa en 1 un natural y lo devuelve como std_logic_vector
  function increment(value : in natural) return std_logic_vector;
  --* Incrementa en <var>amount</var> el valor sin signo del std_logic_vector
  function increment(value : in std_logic_vector; amount : in natural)
    return std_logic_vector;
  --* Decrementa en 1 el valor sin signo del std_logic_vector           
  function decrement(value : in std_logic_vector)
    return std_logic_vector;
  --* Decrementa en 1 un natural y lo devuelve como std_logic_vector           
  function decrement(value : in natural) return std_logic_vector;
  --* Decrementa en <var>amount</var> el valor sin signo del std_logic_vector
  function decrement(value : in std_logic_vector; amount : in natural)
    return std_logic_vector;
  --* Devuelve el máximo entre dos naturals
  function max(a, b : natural)
    return natural;
   --* Devuelve el máximo entre dos naturals
  function get_partition(N : natural)
    return natural;
  
end package;


package body funciones is

------------------------------------------------------------------------

  function ceil2power(N : natural) return natural is

    variable m, p : natural;
  begin
    m := 0;
    p := 1;

    while p <= N loop
      m := m + 1;
      p := p * 2;
    end loop;

    return m;
    
  end ceil2power;

------------------------------------------------------------------------

  function ceilpower(N : in natural; radix : in natural) return natural is

    variable m, p : natural;
  begin
    m := 0;
    p := 1;

    while p <= N loop
      m := m + 1;
      p := p * radix;
    end loop;

    return m;
    
  end ceilpower;
------------------------------------------------------------------------

  function zeros(int : in integer) return std_logic_vector is
    variable result : std_logic_vector(int -1 downto 0);
  begin
    for index in result'range loop
      result(index) := '0';
    end loop;
    return result;
  end zeros;

------------------------------------------------------------------------


  function to_slv(sl : in std_logic) return std_logic_vector is
    
    variable result : std_logic_vector(0 downto 0);
  begin
    result(0) := sl;
    return result;
  end to_slv;

------------------------------------------------------------------------

  function to_sl(slv : in std_logic_vector) return std_logic is
    
    variable result : std_logic;
  begin
    result := slv(0);
    return result;
  end to_sl;

------------------------------------------------------------------------

  function increment(value : in std_logic_vector) return std_logic_vector is

    variable result : std_logic_vector(value'range);
  begin
    result := std_logic_vector(unsigned(value) + to_unsigned(1, value'length));
    return result;
  end increment;

------------------------------------------------------------------------

  function increment(value : in std_logic_vector; amount : in natural) return std_logic_vector is

    variable result : std_logic_vector(value'range);
  begin
    result := std_logic_vector(unsigned(value) + to_unsigned(amount, value'length));
    return result;
  end increment;
------------------------------------------------------------------------

  function decrement(value : in std_logic_vector) return std_logic_vector is

    variable result : std_logic_vector(value'range);
  begin
    result := std_logic_vector(unsigned(value) - to_unsigned(1, value'length));
    return result;
  end decrement;

---------------------------------------------------------------------------------       


  function increment(value : in natural) return std_logic_vector is
    
    variable result : std_logic_vector(ceil2power(value) - 1 downto 0);
    
  begin
    result := std_logic_vector(to_unsigned(value + 1, result'length));
    return result;
  end increment;

  ----------------------------------------------------------------------

  function decrement(value : in natural) return std_logic_vector is
    
    variable result : std_logic_vector(ceil2power(value) - 1 downto 0);
    
  begin
    result := std_logic_vector(to_unsigned(value - 1, result'length));
    return result;
  end decrement;

------------------------------------------------------------------------

  function decrement(value : in std_logic_vector; amount : in natural) return std_logic_vector is

    variable result : std_logic_vector(value'range);
  begin
    result := std_logic_vector(unsigned(value) - to_unsigned(amount, value'length));
    return result;
  end decrement;

------------------------------------------------------------------------    

  function to_slv(n, b : natural) return std_logic_vector is
    
    variable result : std_logic_vector(b - 1 downto 0);
    
  begin
    result := std_logic_vector(to_unsigned(n, result'length));
    return result;
  end to_slv;

------------------------------------------------------------------------  

-----------------------------------------------------------------------    

function get_partition(N : natural) return natural is
    
  variable result : natural;
  
begin
	result := 0  when N = 1  else 
		  0  when N = 2    else 
		  0  when N = 3    else 
		  0  when N = 4    else 
		  0  when N = 5    else 
		  0  when N = 6    else 
		  0  when N = 7    else 
		  0  when N = 8    else 
		  0  when N = 9    else 
		  0  when N = 10   else 
		  0  when N = 11   else 
		  0  when N = 12   else 
		  0  when N = 13   else 
		  0  when N = 14   else 
		  0  when N = 15   else 
		  0  when N = 16   else 
		  0  when N = 17   else 
		  0  when N = 18   else 
		  2  when N = 19   else 
		  3  when N = 20   else 
		  4  when N = 21   else 
		  5  when N = 22   else 
		  6  when N = 23   else 
		  7  when N = 24   else 
		  8  when N = 25   else 
		  9  when N = 26   else 
		  10 when N = 27   else 
		  11 when N = 28   else 
		  12 when N = 29   else 
		  13 when N = 30   else 
		  14 when N = 31   else 
		  15 when N = 32   else 
		  16 when N = 33   else 
		  17 when N = 34   else 
		  17 when N = 35   else 
		  18 when N = 36   else 
		  4  when N = 37   else 
		  5  when N = 38   else 
		  6  when N = 39   else 
		  7  when N = 40   else 
		  8  when N = 41   else 
		  9  when N = 42   else 
		  10 when N = 43   else 
		  11 when N = 44   else 
		  12 when N = 45   else 
		  13 when N = 46   else 
		  14 when N = 47   else 
		  15 when N = 48   else 
		  16 when N = 49   else 
		  17 when N = 50   else 
		  18 when N = 51   else 
		  18 when N = 52   else 
		  20 when N = 53   else 
		  21 when N = 54   else 
		  22 when N = 55   else 
		  23 when N = 56   else 
		  24 when N = 57   else 
		  25 when N = 58   else 
		  26 when N = 59   else 
		  27 when N = 60   else 
		  28 when N = 61   else 
		  29 when N = 62   else 
		  30 when N = 63   else 
		  31 when N = 64   else 
		  32 when N = 65   else 
		  33 when N = 66   else 
		  33 when N = 67   else 
		  34 when N = 68   else 
		  34 when N = 69   else 
		  34 when N = 70   else 
		  21 when N = 71   else 
		  22 when N = 72   else 
		  23 when N = 73   else 
		  24 when N = 74   else 
		  25 when N = 75   else 
		  26 when N = 76   else 
		  27 when N = 77   else 
		  28 when N = 78   else 
		  29 when N = 79   else 
		  30 when N = 80   else 
		  31 when N = 81   else 
		  32 when N = 82   else 
		  33 when N = 83   else 
		  34 when N = 84   else 
		  34 when N = 85   else 
		  36 when N = 86   else 
		  22 when N = 87   else 
		  23 when N = 88   else 
		  24 when N = 89   else 
		  25 when N = 90   else 
		  26 when N = 91   else 
		  27 when N = 92   else 
		  28 when N = 93   else 
		  29 when N = 94   else 
		  30 when N = 95   else 
		  31 when N = 96   else 
		  32 when N = 97   else 
		  33 when N = 98   else 
		  34 when N = 99   else 
		  50 when N = 100  else 
		  36 when N = 101  else 
		  51 when N = 102  else 
		  38 when N = 103  else 
		  39 when N = 104  else 
		  40 when N = 105  else 
		  41 when N = 106  else 
		  42 when N = 107  else 
		  43 when N = 108  else 
		  44 when N = 109  else 
		  45 when N = 110  else 
		  46 when N = 111  else 
		  47 when N = 112  else 
		  48 when N = 113  else 
		  49 when N = 114  else 
		  50 when N = 115  else 
		  51 when N = 116  else 
		  51 when N = 117  else 
		  53 when N = 118  else 
		  54 when N = 119  else 
		  55 when N = 120  else 
		  56 when N = 121  else 
		  57 when N = 122  else 
		  58 when N = 123  else 
		  59 when N = 124  else 
		  60 when N = 125  else 
		  61 when N = 126  else 
		  62 when N = 127  else 
		  63 when N = 128  else 
		  64 when N = 129  else 
		  65 when N = 130  else 
		  65 when N = 131  else 
		  66 when N = 132  else 
		  66 when N = 133  else 
		  66 when N = 134  else 
		  67 when N = 135  else 
		  68 when N = 136  else 
		  68 when N = 137  else 
		  69 when N = 138  else 
		  56 when N = 139  else 
		  57 when N = 140  else 
		  58 when N = 141  else 
		  59 when N = 142  else 
		  60 when N = 143  else 
		  61 when N = 144  else 
		  62 when N = 145  else 
		  63 when N = 146  else 
		  64 when N = 147  else 
		  65 when N = 148  else 
		  66 when N = 149  else 
		  66 when N = 150  else 
		  68 when N = 151  else 
		  68 when N = 152  else 
		  68 when N = 153  else 
		  55 when N = 154  else 
		  56 when N = 155  else 
		  57 when N = 156  else 
		  58 when N = 157  else 
		  59 when N = 158  else 
		  60 when N = 159  else 
		  61 when N = 160  else 
		  62 when N = 161  else 
		  63 when N = 162  else 
		  64 when N = 163  else 
		  65 when N = 164  else 
		  66 when N = 165  else 
		  83 when N = 166  else 
		  68 when N = 167  else 
		  84 when N = 168  else 
		  84 when N = 169  else 
		  84 when N = 170  else 
		  56 when N = 171  else 
		  57 when N = 172  else 
		  58 when N = 173  else 
		  59 when N = 174  else 
		  60 when N = 175  else 
		  61 when N = 176  else 
		  62 when N = 177  else 
		  63 when N = 178  else 
		  64 when N = 179  else 
		  65 when N = 180  else 
		  66 when N = 181  else 
		  83 when N = 182  else 
		  84 when N = 183  else 
		  84 when N = 184  else 
		  86 when N = 185  else 
		  57 when N = 186  else 
		  58 when N = 187  else 
		  59 when N = 188  else 
		  60 when N = 189  else 
		  61 when N = 190  else 
		  62 when N = 191  else 
		  63 when N = 192  else 
		  64 when N = 193  else 
		  65 when N = 194  else 
		  66 when N = 195  else 
		  97 when N = 196  else 
		  98 when N = 197  else 
		  99 when N = 198  else 
		  99 when N = 199  else 
		  100 when N = 200  else 
		  100 when N = 201  else 
		  100 when N = 202  else 
		  74 when N = 203  else 
		  75 when N = 204  else 
		  76 when N = 205  else 
		  77 when N = 206  else 
		  78 when N = 207  else 
		  79 when N = 208  else 
		  80 when N = 209  else 
		  81 when N = 210  else 
		  82 when N = 211  else 
		  83 when N = 212  else 
		  84 when N = 213  else 
		  99 when N = 214  else 
		  100 when N = 215  else 
		  100 when N = 216  else 
		  102 when N = 217  else 
		  89 when N = 218  else 
		  90 when N = 219  else 
		  91 when N = 220  else 
		  92 when N = 221  else 
		  93 when N = 222  else 
		  94 when N = 223  else 
		  95 when N = 224  else 
		  96 when N = 225  else 
		  97 when N = 226  else 
		  98 when N = 227  else 
		  99 when N = 228  else 
		  100 when N = 229  else 
		  115 when N = 230  else 
		  102 when N = 231  else 
		  116 when N = 232  else 
		  104 when N = 233  else 
		  105 when N = 234  else 
		  106 when N = 235  else 
		  107 when N = 236  else 
		  108 when N = 237  else 
		  109 when N = 238  else 
		  110 when N = 239  else 
		  111 when N = 240  else 
		  112 when N = 241  else 
		  113 when N = 242  else 
		  114 when N = 243  else 
		  115 when N = 244  else 
		  116 when N = 245  else 
		  116 when N = 246  else 
		  118 when N = 247  else 
		  119 when N = 248  else 
		  120 when N = 249  else 
		  121 when N = 250  else 
		  122 when N = 251  else 
		  123 when N = 252  else 
		  124 when N = 253  else 
		  125 when N = 254  else 
		  126 when N = 255  else 
		  127 when N = 256  else 
		  128 when N = 257  else 
		  129 when N = 258  else 
		  129 when N = 259  else 
		  130 when N = 260  else 
		  130 when N = 261  else 
		  130 when N = 262  else 
		  131 when N = 263  else 
		  132 when N = 264  else 
		  132 when N = 265  else 
		  133 when N = 266  else 
		  132 when N = 267  else 
		  133 when N = 268  else 
		  134 when N = 269  else 
		  135 when N = 270  else 
		  135 when N = 271  else 
		  136 when N = 272  else 
		  125 when N = 273  else 
		  126 when N = 274  else 
		  127 when N = 275  else 
		  128 when N = 276  else 
		  129 when N = 277  else 
		  130 when N = 278  else 
		  130 when N = 279  else 
		  132 when N = 280  else 
		  132 when N = 281  else 
		  132 when N = 282  else 
		  132 when N = 283  else 
		  136 when N = 284  else 
		  136 when N = 285  else 
		  136 when N = 286  else 
		  136 when N = 287  else 
		  123 when N = 288  else 
		  124 when N = 289  else 
		  125 when N = 290  else 
		  126 when N = 291  else 
		  127 when N = 292  else 
		  128 when N = 293  else 
		  129 when N = 294  else 
		  130 when N = 295  else 
		  148 when N = 296  else 
		  132 when N = 297  else 
		  149 when N = 298  else 
		  149 when N = 299  else 
		  149 when N = 300  else 
		  136 when N = 301  else 
		  151 when N = 302  else 
		  136 when N = 303  else 
		  136 when N = 304  else 
		  123 when N = 305  else 
		  124 when N = 306  else 
		  125 when N = 307  else 
		  126 when N = 308  else 
		  127 when N = 309  else 
		  128 when N = 310  else 
		  129 when N = 311  else 
		  130 when N = 312  else 
		  148 when N = 313  else 
		  149 when N = 314  else 
		  149 when N = 315  else 
		  151 when N = 316  else 
		  151 when N = 317  else 
		  151 when N = 318  else 
		  122 when N = 319  else 
		  123 when N = 320  else 
		  124 when N = 321  else 
		  125 when N = 322  else 
		  126 when N = 323  else 
		  127 when N = 324  else 
		  128 when N = 325  else 
		  129 when N = 326  else 
		  130 when N = 327  else 
		  163 when N = 328  else 
		  164 when N = 329  else 
		  165 when N = 330  else 
		  165 when N = 331  else 
		  166 when N = 332  else 
		  166 when N = 333  else 
		  166 when N = 334  else 
		  167 when N = 335  else 
		  168 when N = 336  else 
		  168 when N = 337  else 
		  169 when N = 338  else 
		  125 when N = 339  else 
		  126 when N = 340  else 
		  127 when N = 341  else 
		  128 when N = 342  else 
		  129 when N = 343  else 
		  130 when N = 344  else 
		  148 when N = 345  else 
		  149 when N = 346  else 
		  165 when N = 347  else 
		  166 when N = 348  else 
		  166 when N = 349  else 
		  168 when N = 350  else 
		  168 when N = 351  else 
		  168 when N = 352  else 
		  124 when N = 353  else 
		  125 when N = 354  else 
		  126 when N = 355  else 
		  127 when N = 356  else 
		  128 when N = 357  else 
		  129 when N = 358  else 
		  130 when N = 359  else 
		  163 when N = 360  else 
		  164 when N = 361  else 
		  165 when N = 362  else 
		  166 when N = 363  else 
		  182 when N = 364  else 
		  168 when N = 365  else 
		  183 when N = 366  else 
		  183 when N = 367  else 
		  183 when N = 368  else 
		  125 when N = 369  else 
		  126 when N = 370  else 
		  127 when N = 371  else 
		  128 when N = 372  else 
		  129 when N = 373  else 
		  130 when N = 374  else 
		  178 when N = 375  else 
		  179 when N = 376  else 
		  180;
  return result;
end get_partition;

------------------------------------------------------------------------  

-----------------------------------------------------------------------    

function max(a, b : natural) return natural is
    
  variable result : natural;
  
begin
  if a > b then
    result := a;
  else -- Corregir
    result := b;
  end if;

  return result;
end max;

------------------------------------------------------------------------  

end package body;
