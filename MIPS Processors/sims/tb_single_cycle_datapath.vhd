library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_single_cycle_datapath is
end tb_single_cycle_datapath;

architecture behave of tb_single_cycle_datapath is

    component single_cycle_datapath is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        instr       : in std_logic_vector(31 downto 0);
        mem_data    : in std_logic_vector(31 downto 0);
        
        alu_ctrl    : in std_logic_vector( 2 downto 0);
        pc_src      : in std_logic;
        mem_to_reg  : in std_logic;
        alu_src     : in std_logic;
        reg_dst     : in std_logic;
        reg_wr      : in std_logic;
        jump        : in std_logic;
        
        pc          : out std_logic_vector(31 downto 0);
        alu_out     : out std_logic_vector(31 downto 0);
        data_wr     : out std_logic_vector(31 downto 0);
        zero        : out std_logic
    );
    end component single_cycle_datapath;

    -- data inputs
    signal clk         : std_logic;
    signal reset       : std_logic;
    signal instr       : std_logic_vector(31 downto 0);
    signal mem_data    : std_logic_vector(31 downto 0);
    
    -- ctrl inputs
    signal alu_ctrl    : std_logic_vector( 2 downto 0) := "000";
    signal pc_src      : std_logic := '0';
    signal mem_to_reg  : std_logic := '0';
    signal alu_src     : std_logic := '0';
    signal reg_dst     : std_logic := '0';
    signal reg_wr      : std_logic := '0';
    signal jump        : std_logic := '0';
    
    -- outputs
    signal pc          : std_logic_vector(31 downto 0) := (others => '0');
    signal alu_out     : std_logic_vector(31 downto 0) := (others => '0');
    signal data_wr     : std_logic_vector(31 downto 0) := (others => '0');
    signal zero        : std_logic := '0';

    -- clk period constants
    constant clk_period : time := 10ns;  -- 100 MHz
    
begin

    -- instantiate DUT
    u_single_cycle_datapath : single_cycle_datapath
    port map(
        clk         => clk          ,
        reset       => reset        ,
        instr       => instr        ,
        mem_data    => mem_data     ,
        
        alu_ctrl    => alu_ctrl     ,
        pc_src      => pc_src       ,
        mem_to_reg  => mem_to_reg   ,
        alu_src     => alu_src      ,
        reg_dst     => reg_dst      ,
        reg_wr      => reg_wr       ,
        jump        => jump         ,
        
        pc          => pc           ,
        alu_out     => alu_out      ,
        data_wr     => data_wr      ,
        zero        => zero
    );

    -- clock simulation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
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
        -- lw control init
        alu_ctrl <= "010"; reg_wr <= '1'; reg_dst <= '0'; alu_src <= '1'; mem_to_reg  <= '1';
        
        -- load xDEADBEEF to reg 8 from mem 6
        mem_data <= x"DEADBEEF";
        instr <= ("100011", 5d"0", 5d"8", 16d"6"); -- lw $8, 0x6($0)
        wait until rising_edge(clk);

        -- load xBEEFDEAD to reg 9 from mem 7
        mem_data <= x"BEEFDEAD";
        instr <= ("100011", 5d"0", 5d"9", 16d"7"); -- lw $9, 0x7($0)
        wait until rising_edge(clk);

        -- lw control deinit
        alu_ctrl <= "000"; reg_wr <= '0'; reg_dst <= '0'; alu_src <= '0'; mem_to_reg  <= '0';

        -----------------------------------------------------------------------
        -- sw (store word)
        -----------------------------------------------------------------------
        -- sw control init
        alu_ctrl <= "010"; reg_wr <= '0'; alu_src <= '1';

        -- store xDEADBEEF from reg 8 to mem 8
        instr <= ("101011", 5d"0", 5d"8", 16d"8"); -- sw $8, 0x8($0)
        wait until rising_edge(clk);

        -- store xBEEFDEAD from reg 9 to mem 9
        instr <= ("101011", 5d"0", 5d"9", 16d"9"); -- sw $9, 0x9($0)
        wait until rising_edge(clk);

        -- sw control deinit
        alu_ctrl <= "000"; reg_wr <= '0'; alu_src <= '0';

        -----------------------------------------------------------------------
        -- R-type (register type instructions)
        -----------------------------------------------------------------------
        -- R-type control init
        alu_ctrl <= "000"; reg_wr <= '1'; reg_dst <= '1'; alu_src <= '0'; mem_to_reg  <= '0';

        -- add xDEADBEEF to xBEEFDEAD into reg 1
        alu_ctrl <= "010";
        instr <= ("000000", 5d"8", 5d"9", 5d"1", 5d"0", "100000"); -- add $1, $8, $9
        wait until rising_edge(clk);

        -- subtract from xDEADBEEF by xBEEFDEAD into reg 2
        alu_ctrl <= "110";
        instr <= ("000000", 5d"8", 5d"9", 5d"2", 5d"0", "100010"); -- sub $2, $8, $9
        wait until rising_edge(clk);

        -- and xDEADBEEF with xBEEFDEAD into reg 3
        alu_ctrl <= "000";
        instr <= ("000000", 5d"8", 5d"9", 5d"3", 5d"0", "100100"); -- and $3, $8, $9
        wait until rising_edge(clk);

        -- or xDEADBEEF with xBEEFDEAD into reg 4
        alu_ctrl <= "001";
        instr <= ("000000", 5d"8", 5d"9", 5d"4", 5d"0", "100101"); -- or $4, $8, $9
        wait until rising_edge(clk);

        -- slt xDEADBEEF with xBEEFDEAD into reg 5
        alu_ctrl <= "111";
        instr <= ("000000", 5d"8", 5d"9", 5d"5", 5d"0", "101010"); -- slt $5, $8, $9
        wait until rising_edge(clk);

        -- R-type control deinit
        alu_ctrl <= "000"; reg_wr <= '0'; reg_dst <= '0'; alu_src <= '0'; mem_to_reg  <= '0';

        -----------------------------------------------------------------------
        -- beq (branch if equal)
        -----------------------------------------------------------------------
        -- beq control init
        alu_ctrl <= "110"; reg_wr <= '0'; alu_src <= '0'; pc_src <= '1';

        -- branches by comparing register to itself
        instr <= ("000100", 5d"8", 5d"8", 16d"4"); -- beq $8, $8, 2
        wait until rising_edge(clk);

        -- beq control deinit
        alu_ctrl <= "000"; reg_wr <= '0'; alu_src <= '0'; pc_src <= '0';

        -----------------------------------------------------------------------
        -- addi (add immediate)
        -----------------------------------------------------------------------
        -- addi control init
        alu_ctrl <= "010"; reg_wr <= '1'; reg_dst <= '0'; alu_src <= '1'; mem_to_reg  <= '0';

        -- puts 18 into reg 6
        instr <= ("001000", 5d"0", 5d"6", 16d"18"); -- addi $6, $0, 18
        wait until rising_edge(clk);

        -- puts -21 into reg 7
        instr <= ("001000", 5d"0", 5d"7", x"FFEB"); -- addi $7, $0, -21
        wait until rising_edge(clk);

        -- addi control deinit
        alu_ctrl <= "000"; reg_wr <= '0'; reg_dst <= '0'; alu_src <= '0'; mem_to_reg  <= '0';

        -----------------------------------------------------------------------
        -- j (jump)
        -----------------------------------------------------------------------
        -- j control init
        jump  <= '1';

        -- jump to address 0x00FFFFFC0
        instr <= ("000010", others => '1'); -- j 0x3FFFFFF
        wait until rising_edge(clk);

        -- j control deinit
        jump <= '0';

        wait;
    end process;

end behave;