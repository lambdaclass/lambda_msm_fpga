library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_topModule is
        generic(K : natural := 5);
        port(
                -------------------
                -- INPUT SIGNALS --
                -------------------
                -- Generic.
                clk, rst                : in std_logic;

                -- Start signal.
                start                   : in std_logic;

                -- Counter value. (DUDAAAAS. EL COUNTER TENDRIA QUE SER OTRO COMPONENTE DENTRO DEL TM)
                counter                 : in std_logic_vector(4 downto 0);

                done                    : out std_logic;
                        
                -- Memory signal
                mem_out                 : out std_logic_vector(K - 1 downto 0);

                -- point enable
                point_enable            : out std_logic;

                -- Buckets info - Empty and busy bits.
                empty_bin               : in std_logic_vector(K - 1 downto 0);
                busy_bin                : in std_logic_vector(K - 1 downto 0);

                scalar_w_out            : out std_logic_vector(K - 1 downto 0);
                counter_w_out           : out std_logic;

                fifo_write_sig          : out std_logic_vector(K - 1 downto 0);
                
                bubble_sig              : out std_logic;

                busy_bit                : out std_logic;
                empty_bit               : out std_logic
            );
end FSM_topModule;

architecture Structural of FSM_topModule is

        -- I have to define the intermediate signals to connect multiple FSMs
        signal busIn_to_dispatch : std_logic; 
        signal busIn_to_pointCounter : std_logic; 

        signal dispatch_to_FIFO : std_logic;
        signal FIFO_to_dispatch : std_logic_vector(K - 1 downto 0);

        signal process_done_to_dispatch : std_logic;

        signal tmp : std_logic;

        signal padd_empty_to_waitState : std_logic;

        signal memsig_to_dispatch : std_logic;

        signal fifo_flush_sig : std_logic;

        signal tmp_counter : std_logic_vector(4 downto 0);

        signal busIn_cable : std_logic;


begin

        FSM_1: entity work.FSM_L1_busIn
                port map(
                        clk => clk,
                        rst => rst,
                        start => busIn_cable,

                        scalar_out => busIn_to_dispatch,
                        new_processing => busIn_to_pointCounter,
                        mem_enable_in => mem_out
                );
--
        FSM_2: entity work.FSM_L1_FIFOs
                port map(
                        clk => clk,
                        rst => rst,

                        flush_sig => dispatch_to_FIFO,
                        fs_read_en => FIFO_to_dispatch
                );
--
        FSM_3: entity work.FSM_L1_dispatch
                port map(
                        clk => clk,
                        rst => rst,

                        data_ready => memsig_to_dispatch,
                        fifo_flush => fifo_flush_sig,

                        counter => tmp_counter,
                        empty_bin => empty_bin,
                        busy_bin => busy_bin,

                        -- Outputs
                        start_busIn => busIn_cable,
                        start_fifoIn => dispatch_to_FIFO,

                        point_enable_in => point_enable,

                        scalar_window_out => scalar_w_out,
                        counter_window_out => counter_w_out,
                        fifo_write => fifo_write_sig,
                        bubble_sig => bubble_sig,

                        busy_bit => busy_bit,
                        empty_bit => empty_bit
                );
--
        FSM_4: entity work.FSM_L1_inputCounter
                port map(
                        clk => clk,
                        rst => rst,

                        count => busIn_to_pointCounter,
                        processing_done => process_done_to_dispatch 
                );

        FSM_5: entity work.FSM_L1_waitState
                port map(

                        -- Inputs 
                        clk => clk,
                        rst => rst,

                        start_wait => process_done_to_dispatch,
                        padd_empty => padd_empty_to_waitState,

                        done_process => done
                );
end Structural;
