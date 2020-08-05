library ieee;
use ieee.std_logic_1164.all;

entity tb_MIPS_single_cycle is
end tb_MIPS_single_cycle;

architecture behave of tb_MIPS_single_cycle is

    component MIPS_single_cycle is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        instr       : in std_logic_vector(31 downto 0);
        mem_data    : in std_logic_vector(31 downto 0);

        mem_write   : out std_logic;

        pc          : out std_logic_vector(31 downto 0);
        alu_out     : out std_logic_vector(31 downto 0);
        data_wr     : out std_logic_vector(31 downto 0)
    );
    end component MIPS_single_cycle;

    -- inputs
    signal clk         : std_logic;
    signal reset       : std_logic;
    signal instr       : std_logic_vector(31 downto 0);
    signal mem_data    : std_logic_vector(31 downto 0);

    -- control output
    signal mem_write   : std_logic;

    -- outputs
    signal pc          : std_logic_vector(31 downto 0);
    signal alu_out     : std_logic_vector(31 downto 0);
    signal data_wr     : std_logic_vector(31 downto 0);

    -- clk period constants
    constant clk_period : time := 10ns;  -- 100 MHz
    signal sim_done     : std_logic := '0';

begin

    -- instantiate DUT
    u_MIPS_single_cycle : MIPS_single_cycle
    port map (
        clk         => clk          ,
        reset       => reset        ,
        instr       => instr        ,
        mem_data    => mem_data     ,
    
        mem_write   => mem_write    ,
    
        pc          => pc           ,
        alu_out     => alu_out      ,
        data_wr     => data_wr
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

        -- load xDEADBEEF to reg 8 from mem 6
        mem_data <= x"DEADBEEF";
        instr <= ("100011", 5d"0", 5d"8", 16d"6"); -- lw $8, 0x6($0)
        wait until rising_edge(clk);

        -- load xBEEFDEAD to reg 9 from mem 7
        mem_data <= x"BEEFDEAD";
        instr <= ("100011", 5d"0", 5d"9", 16d"7"); -- lw $9, 0x7($0)
        wait until rising_edge(clk);


        -----------------------------------------------------------------------
        -- sw (store word)
        -----------------------------------------------------------------------

        -- store xDEADBEEF from reg 8 to mem 8
        instr <= ("101011", 5d"0", 5d"8", 16d"8"); -- sw $8, 0x8($0)
        wait until rising_edge(clk);

        -- store xBEEFDEAD from reg 9 to mem 9
        instr <= ("101011", 5d"0", 5d"9", 16d"9"); -- sw $9, 0x9($0)
        wait until rising_edge(clk);

        -----------------------------------------------------------------------
        -- R-type (register type instructions)
        -----------------------------------------------------------------------

        -- add xDEADBEEF to xBEEFDEAD into reg 1
        instr <= ("000000", 5d"8", 5d"9", 5d"1", 5d"0", "100000"); -- add $1, $8, $9
        wait until rising_edge(clk);

        -- subtract from xDEADBEEF by xBEEFDEAD into reg 2
        instr <= ("000000", 5d"8", 5d"9", 5d"2", 5d"0", "100010"); -- sub $2, $8, $9
        wait until rising_edge(clk);

        -- and xDEADBEEF with xBEEFDEAD into reg 3
        instr <= ("000000", 5d"8", 5d"9", 5d"3", 5d"0", "100100"); -- and $3, $8, $9
        wait until rising_edge(clk);

        -- or xDEADBEEF with xBEEFDEAD into reg 4
        instr <= ("000000", 5d"8", 5d"9", 5d"4", 5d"0", "100101"); -- or $4, $8, $9
        wait until rising_edge(clk);

        -- slt xDEADBEEF with xBEEFDEAD into reg 5
        instr <= ("000000", 5d"8", 5d"9", 5d"5", 5d"0", "101010"); -- slt $5, $8, $9
        wait until rising_edge(clk);


        -----------------------------------------------------------------------
        -- beq (branch if equal)
        -----------------------------------------------------------------------

        -- branches by comparing register to itself
        instr <= ("000100", 5d"8", 5d"8", 16d"4"); -- beq $8, $8, 4
        wait until rising_edge(clk);

        -----------------------------------------------------------------------
        -- addi (add immediate)
        -----------------------------------------------------------------------

        -- puts 18 into reg 6
        instr <= ("001000", 5d"0", 5d"6", 16d"18"); -- addi $6, $0, 18
        wait until rising_edge(clk);

        -- puts -21 into reg 7
        instr <= ("001000", 5d"0", 5d"7", x"FFEB"); -- addi $7, $0, -21
        wait until rising_edge(clk);

        
        -----------------------------------------------------------------------
        -- j (jump)
        -----------------------------------------------------------------------

        -- jump to address 0x00FFFFFC0
        instr <= ("000010", others => '1'); -- j 0x3FFFFFF
        wait until rising_edge(clk);

        sim_done  <= '1';

        wait;
    end process;

end behave;