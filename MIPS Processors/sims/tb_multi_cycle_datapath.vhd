library iee;
use ieee.logic.all;

entity tb_multi_cycle_datapath is
end tb_multi_cycle_datapath;

architecture behave of tb_multi_cycle_datapath is

    component multi_cycle_datapath is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        mem_word    : in std_logic_vector(31 downto 0);
        
        pc_wr       : in std_logic;
        i_or_d      : in std_logic;
        instr_wr    : in std_logic;
        reg_wr      : in std_logic;
        src_a_ctrl  : in std_logic;
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
    signal pc_wr       : std_logic := '0';
    signal i_or_d      : std_logic := '0';
    signal instr_wr    : std_logic := '0';
    signal reg_wr      : std_logic := '0';
    signal src_a_ctrl  : std_logic := '0';
    signal src_b_ctrl  : std_logic_vector( 1 downto 0 := (others => '0'));
    signal alu_ctrl    : std_logic_vector( 2 downto 0) := (others => '0');
    
    -- outputs
    signal mem_addr    : std_logic_vector(31 downto 0) := (others => '0');
    signal data_wr     : std_logic_vector(31 downto 0) := (others => '0');
    signal zero        : std_logic := '0';

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
            
        pc_wr       => pc_wr        ,
        i_or_d      => i_or_d       ,
        instr_wr    => instr_wr     ,
        reg_wr      => reg_wr       ,
        src_a_ctrl  => src_a_ctrl   ,
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
        -- load xDEADBEEF to reg 8 from mem 6
        instr <= ("100011", 5d"0", 5d"8", 16d"6"); -- lw $8, 0x6($0)
        mem_data <= x"DEADBEEF";
        
        i_or_d <= '0'; instr_wr <= '1'; wait until rising_edge(clk);
        instr_wr <= '0';                wait until rising_edge(clk);
        alu_src_a <= '1'; alu_src_b <= "10"; alu_ctrl <= "010"; wait until rising_edge(clk);
        alu_src_a <= '0'; alu_src_b <= "01"; i_or_d <= '1'; mem_wr <= '1'; pc_wr <= '1'; wait until rising_edge(clk)

        sim_done <= '1';

        wait;
    end process;

end behave;