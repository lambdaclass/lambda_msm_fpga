library ieee;
use ieee.std_logic_1164.all;

--* @brief Tipos de datos auxiliares de uso general
use work.config.all;

package tipos is
  
  type std_logic_2d is
    array (natural range <>, natural range <>) of std_logic;
  
  type std_logic_vector_a2 is
    array (natural range <>) of std_logic_vector(1 downto 0);

  type std_logic_vector_a8 is
    array (natural range <>) of std_logic_vector(7 downto 0);
  
  type natural_vector is 
    array(natural range <>) of natural;

  type point_t is 
    array(natural range<>) of std_logic_vector(N_vect - 1 downto 0);

  type mem_t is 
    array(natural range<>) of std_logic_vector(C_DWIDTH - 1 downto 0);

  type array_xn is 
    array(natural range<>) of std_logic_vector(C - 1 downto 0);

  type memory_in_t is record
          we    : std_logic;
          addr  : std_logic_vector(C - 1 downto 0);
          din   : std_logic_vector(C_DWIDTH - 1 downto 0);
  end record memory_in_t;

  type dp_memory_out_t is record
          douta   : std_logic_vector(C_DWIDTH - 1 downto 0);
          doutb   : std_logic_vector(C_DWIDTH - 1 downto 0);
  end record dp_memory_out_t;

  type bucket_kstatus is record
          empty_o : std_logic_vector(K - 1 downto 0);
          busy_o  : std_logic_vector(K - 1 downto 0);
  end record bucket_kstatus;

  type bucket_status is record
          empty_o : std_logic;
          busy_o  : std_logic;
  end record bucket_status;

  type fifo_in_t is record
          we    : std_logic;
          re    : std_logic;

          din_x : std_logic_vector(N_vect - 1 downto 0);
          din_y : std_logic_vector(N_vect - 1 downto 0);
          din_z : std_logic_vector(N_vect - 1 downto 0);
  end record fifo_in_t;

  type fifo_out_t is record
          dout_x      : std_logic_vector(N_vect - 1 downto 0);
          dout_y      : std_logic_vector(N_vect - 1 downto 0);
          dout_z      : std_logic_vector(N_vect - 1 downto 0);

          empty_o         : std_logic;
          full_o          : std_logic;
          almost_empty_o  : std_logic;
          almost_full_o   : std_logic;
          rst_busy_o      : std_logic;
  end record fifo_out_t;

  type counters is record
          window            : std_logic_vector(5 - 1 downto 0);
          segment           : std_logic_vector(3 - 1 downto 0);
          element           : std_logic_vector(9 - 1 downto 0);
  end record counters;

  type fifo_bank_in_t is record
          we    : std_logic;
          re    : std_logic;

          data_in : std_logic_vector(N_vect + C - 1 downto 0);
  end record fifo_bank_in_t;

  type fifo_bank_out_t is record
          dout : std_logic_vector(N_vect + C - 1 downto 0);
          empty_o : std_logic_vector(K - 1 downto 0);
          full_o : std_logic_vector(K - 1 downto 0);
  end record fifo_bank_out_t;

  type fifo_bank_status is record
        fb_empty        : std_logic;
        fb_anyFull      : std_logic;
        fb_allWithElem  : std_logic;
  end record fifo_bank_status;

--  type fifo_bank_kstatus is record
--        fb_kempty       : std_logic_vector(K - 1 downto 0);
--        fb_kfull        : std_logic_vector(K - 1 downto 0);
--  end record fifo_bank_kstatus;

  type padd_status is record
        data_valid      : std_logic;
        bucket_we       : std_logic;
        mem_we          : std_logic;
        aux_we          : std_logic;
  end record padd_status;

  type padd_delay is record
        data_valid      : std_logic;
        bucket_we       : std_logic;
        mem_we          : std_logic;
        aux_we          : std_logic;
        window          : std_logic_vector(5 - 1 downto 0);
        address         : std_logic_vector(C - 1 downto 0);
  end record padd_delay;

  type counters_status is record
          status_w_done     : std_logic;
          status_m_done     : std_logic;
          status_u_done     : std_logic;
          status_fifo_done  : std_logic;
          status_log_done   : std_logic;
          status_input_done : std_logic;
          status_padd_done  : std_logic;
  end record counters_status;

  type count_signals is record
          w_count     : std_logic;
          m_count     : std_logic;
          u_count     : std_logic;
          fifo_count  : std_logic;
          log_count   : std_logic;
          input_count : std_logic;
          padd_count  : std_logic;
  end record count_signals;

  type padd_op_A is (bucket_op, segment_op, aux_op);

  type padd_op_B is (bucket_op, fifo_op, segment_op, aux_op, input_op);

  type address_A is (xn, fifo, g_k, g_km, s_k, s_km);

  type address_B is (xn, bucket, s_k, s_km, s_km_b, g_km);

end package;
