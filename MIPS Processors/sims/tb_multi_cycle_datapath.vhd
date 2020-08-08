library ieee;
use ieee.std_logic_1164.all;

entity tb_multi_cycle_datapath is
end tb_multi_cycle_datapath;

architecture behave of tb_multi_cycle_datapath is

    component multi_cycle_datapath is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        mem_word    : in std_logic_vector(31 downto 0);
    
        branch      : in std_logic;
        pc_wr       : in std_logic;
        i_or_d      : in std_logic;
        instr_wr    : in std_logic;
        reg_wr      : in std_logic;
        mem_to_reg  : in std_logic;
        reg_dst     : in std_logic;
        src_a_ctrl  : in std_logic;
        pc_src      : in std_logic_vector( 1 downto 0);
        src_b_ctrl  : in std_logic_vector( 1 downto 0);
        alu_ctrl    : in std_logic_vector( 2 downto 0);
    
        mem_addr    : out std_logic_vector(31 downto 0);
        data_wr     : out std_logic_vector(31 downto 0);
        zero        : out std_logic
    );
    end component multi_cycle_datapath;

    -- inputs
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal mem_word    : std_logic_vector(31 downto 0) := (others => '0');
    
    -- control inputs
    signal branch      : std_logic;
    signal pc_wr       : std_logic;
    signal i_or_d      : std_logic;
    signal instr_wr    : std_logic;
    signal reg_wr      : std_logic;
    signal mem_to_reg  : std_logic;
    signal reg_dst     : std_logic;
    signal src_a_ctrl  : std_logic;
    signal pc_src      : std_logic_vector( 1 downto 0);
    signal src_b_ctrl  : std_logic_vector( 1 downto 0);
    signal alu_ctrl    : std_logic_vector( 2 downto 0);
    
    -- outputs
    signal mem_addr    : std_logic_vector(31 downto 0);
    signal data_wr     : std_logic_vector(31 downto 0);
    signal zero        : std_logic;

    -- clk period constants
    constant clk_period : time := 10ns;  -- 100 MHz
    signal   sim_done   : std_logic := '0';

begin

    -- instantiate DUT
    u_multi_cycle_datapath : multi_cycle_datapath
    port map (
        clk         => clk          ,
        reset       => reset        ,
        mem_word    => mem_word     ,
            
        branch      => branch       ,
        pc_wr       => pc_wr        ,
        i_or_d      => i_or_d       ,
        instr_wr    => instr_wr     ,
        reg_wr      => reg_wr       ,
        mem_to_reg  => mem_to_reg   ,
        reg_dst     => reg_dst      ,
        src_a_ctrl  => src_a_ctrl   ,
        pc_src      => pc_src       ,
        src_b_ctrl  => src_b_ctrl   ,
        alu_ctrl    => alu_ctrl     ,
            
        mem_addr    => mem_addr     ,
        data_wr     => data_wr      ,
        zero        => zero
    );


    -- clock simulation
    clk_process : process
    begin
        if (sim_done = '0') then
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        else
            wait;
        end if;
    end process;


    -- simulation process
    stim_proc: process
    begin

        -- process init
        wait until rising_edge(clk);
        reset <= '1';
        wait until rising_edge(clk);
        reset <= '0';

        -----------------------------------------------------------------------
        -- lw (load word)
        -----------------------------------------------------------------------

        --------------------------------------
        -- load xDEADBEEF to reg 8 from mem 6
        ---------------------------------------

        -- fetch
        mem_word <= ("100011", 5d"0", 5d"8", 16d"6"); -- lw $8, 0x6($0)

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- mem_addr (compute mem address)
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "10";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- mem_read (read memory word)
        mem_word <= x"DEADBEEF";

        alu_ctrl    <= "---";

        i_or_d      <= '1';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- mem_writeback
        alu_ctrl    <= "---";

        i_or_d      <= '-';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '0';
        mem_to_reg  <= '1';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '1';
        branch      <= '0';
        wait until rising_edge(clk);

        ---------------------------------------
        -- load xBEEFDEAD to reg 9 from mem 7
        ---------------------------------------
        
        -- fetch
        mem_word <= ("100011", 5d"0", 5d"9", 16d"7"); -- lw $9, 0x7($0)

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- mem_addr (compute mem address)
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "10";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';

        branch      <= '0';
        wait until rising_edge(clk);

        -- mem_read (read memory word)
        mem_word <= x"BEEFDEAD";

        alu_ctrl    <= "---";

        i_or_d      <= '1';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- mem_writeback
        alu_ctrl    <= "---";

        i_or_d      <= '-';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '0';
        mem_to_reg  <= '1';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '1';
        branch      <= '0';
        wait until rising_edge(clk);

        -----------------------------------------------------------------------
        -- sw (store word)
        -----------------------------------------------------------------------

        ---------------------------------------
        -- store xDEADBEEF from reg 8 to mem 8
        ---------------------------------------
        -- fetch
        mem_word <= ("101011", 5d"0", 5d"8", 16d"8"); -- sw $8, 0x8($0)

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- mem_addr (compute mem address)
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "10";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- mem_write (write back into external memory)
        alu_ctrl    <= "---";

        i_or_d      <= '1';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);


        ---------------------------------------
        -- store xBEEFDEAD from reg 9 to mem 9
        ---------------------------------------
        -- fetch
        mem_word <= ("101011", 5d"0", 5d"9", 16d"9"); -- sw $9, 0x9($0)

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- mem_addr (compute mem address)
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "10";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- mem_write (write back into external memory)
        alu_ctrl    <= "---";

        i_or_d      <= '1';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -----------------------------------------------------------------------
        -- R-type (register type instructions)
        -----------------------------------------------------------------------

        ------------------------------------------
        -- add xDEADBEEF to xBEEFDEAD into reg 1
        ------------------------------------------
        -- fetch
        mem_word <= ("000000", 5d"8", 5d"9", 5d"1", 5d"0", "100000"); -- add $1, $8, $9

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- compute
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "00";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        --writeback
        alu_ctrl    <= "---";

        i_or_d      <= '-';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '1';
        mem_to_reg  <= '0';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '1';
        branch      <= '0';
        wait until rising_edge(clk);

        ------------------------------------------
        -- subtract from xDEADBEEF by xBEEFDEAD into reg 2
        ------------------------------------------
        -- fetch
        mem_word <= ("000000", 5d"8", 5d"9", 5d"2", 5d"0", "100010"); -- sub $2, $8, $9

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- compute
        alu_ctrl    <= "110";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "00";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        --writeback
        alu_ctrl    <= "---";

        i_or_d      <= '-';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '1';
        mem_to_reg  <= '0';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '1';
        branch      <= '0';
        wait until rising_edge(clk);

        ------------------------------------------
        -- and xDEADBEEF with xBEEFDEAD into reg 3
        ------------------------------------------
        -- fetch
        mem_word <= ("000000", 5d"8", 5d"9", 5d"3", 5d"0", "100100"); -- and $3, $8, $9

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- compute
        alu_ctrl    <= "000";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "00";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        --writeback
        alu_ctrl    <= "---";

        i_or_d      <= '-';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '1';
        mem_to_reg  <= '0';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '1';
        branch      <= '0';
        wait until rising_edge(clk);

        ------------------------------------------
        -- or xDEADBEEF with xBEEFDEAD into reg 4
        ------------------------------------------
        -- fetch
        mem_word <= ("000000", 5d"8", 5d"9", 5d"4", 5d"0", "100101"); -- or $4, $8, $9

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- compute
        alu_ctrl    <= "001";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "00";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        --writeback
        alu_ctrl    <= "---";

        i_or_d      <= '-';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '1';
        mem_to_reg  <= '0';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '1';
        branch      <= '0';
        wait until rising_edge(clk);

        ------------------------------------------
        -- slt xDEADBEEF with xBEEFDEAD into reg 5
        ------------------------------------------
        -- fetch
        mem_word <= ("000000", 5d"8", 5d"9", 5d"5", 5d"0", "101010"); -- slt $5, $8, $9

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- compute
        alu_ctrl    <= "111";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "00";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        --writeback
        alu_ctrl    <= "---";

        i_or_d      <= '-';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '1';
        mem_to_reg  <= '0';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '1';
        branch      <= '0';
        wait until rising_edge(clk);

        
        -----------------------------------------------------------------------
        -- beq (branch if equal)
        -----------------------------------------------------------------------
        -- fetch
        mem_word <= ("000100", 5d"8", 5d"8", 16d"4"); -- beq $8, $8, 2

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- branch
        alu_ctrl    <= "110";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "00";
        pc_src      <= "01";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '1';
        wait until rising_edge(clk);

        -----------------------------------------------------------------------
        -- addi (add immediate)
        -----------------------------------------------------------------------

        --------------------------
        -- puts 18 into reg 6
        ---------------------------

        -- fetch
        mem_word <= ("001000", 5d"0", 5d"6", 16d"18"); -- addi $6, $0, 18

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- addi_compute
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "10";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- addi_writeback
        alu_ctrl    <= "---";

        i_or_d      <= '-';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '0';
        mem_to_reg  <= '0';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '1';
        branch      <= '0';
        wait until rising_edge(clk);

        --------------------------
        -- puts -21 into reg 7
        ---------------------------

        -- fetch
        mem_word <= ("001000", 5d"0", 5d"7", x"FFEB"); -- addi $7, $0, -21

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- addi_compute
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '1';
        src_b_ctrl  <= "10";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- addi_writeback
        alu_ctrl    <= "---";

        i_or_d      <= '-';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "--";
        reg_dst     <= '0';
        mem_to_reg  <= '0';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '1';
        branch      <= '0';
        wait until rising_edge(clk);

        -----------------------------------------------------------------------
        -- j (jump)
        -----------------------------------------------------------------------
        -- fetch
        mem_word <= ("000010", others => '1'); -- j 0x3FFFFFF

        alu_ctrl    <= "010";

        i_or_d      <= '0';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "01";
        pc_src      <= "00";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '1';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        -- decode
        alu_ctrl    <= "010";

        i_or_d      <= '-';
        src_a_ctrl  <= '0';
        src_b_ctrl  <= "11";
        pc_src      <= "--";
        reg_dst     <= '-';
        mem_to_reg  <= '-';

        instr_wr    <= '0';
        pc_wr       <= '0';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        alu_ctrl    <= "---";

        i_or_d      <= '-';
        src_a_ctrl  <= '-';
        src_b_ctrl  <= "--";
        pc_src      <= "10";
        reg_dst     <= '0';
        mem_to_reg  <= '0';

        instr_wr    <= '0';
        pc_wr       <= '1';
        reg_wr      <= '0';
        branch      <= '0';
        wait until rising_edge(clk);

        wait until rising_edge(clk);
        sim_done <= '1';

        wait;
    end process;

end behave;