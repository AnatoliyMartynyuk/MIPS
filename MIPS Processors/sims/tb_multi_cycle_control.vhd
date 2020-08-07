library ieee;
use ieee.std_logic_1164.all;

entity tb_multi_cycle_control is
end tb_multi_cycle_control;

architecture behave of tb_multi_cycle_control is

    component multi_cycle_control is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        opcode      : in std_logic_vector(5 downto 0);
        funct       : in std_logic_vector(5 downto 0);

        branch      : out std_logic;    -- enable
        pc_wr       : out std_logic;    -- enable
        i_or_d      : out std_logic;    -- mux
        instr_wr    : out std_logic;    -- enable
        reg_wr      : out std_logic;    -- enable
        mem_to_reg  : out std_logic;    -- mux
        reg_dst     : out std_logic;    -- mux
        mem_write   : out std_logic;    -- enable
        src_a_ctrl  : out std_logic;    -- mux
        pc_src      : out std_logic_vector( 1 downto 0);    -- mux
        src_b_ctrl  : out std_logic_vector( 1 downto 0);    -- mux
        alu_ctrl    : out std_logic_vector( 2 downto 0)
    );
    end component multi_cycle_control;

    -- inputs
    signal clk         : std_logic;
    signal reset       : std_logic;
    signal opcode      : std_logic_vector(5 downto 0);
    signal funct       : std_logic_vector(5 downto 0);

    -- outputs
    signal branch      : std_logic;    -- enable
    signal pc_wr       : std_logic;    -- enable
    signal i_or_d      : std_logic;    -- mux
    signal instr_wr    : std_logic;    -- enable
    signal reg_wr      : std_logic;    -- enable
    signal mem_to_reg  : std_logic;    -- mux
    signal reg_dst     : std_logic;    -- mux
    signal mem_write   : std_logic;    -- enable
    signal src_a_ctrl  : std_logic;    -- mux
    signal pc_src      : std_logic_vector( 1 downto 0);    -- mux
    signal src_b_ctrl  : std_logic_vector( 1 downto 0);    -- mux
    signal alu_ctrl    : std_logic_vector( 2 downto 0);

    -- clk period constants
    constant clk_period : time := 10ns;  -- 100 MHz
    signal sim_done     : std_logic := '0';

begin

    -- instantiate DUT
    u_multi_cycle_control : multi_cycle_control
    port map (
        clk         => clk          ,
        reset       => reset        ,
        opcode      => opcode       ,
        funct       => funct        ,

        branch      => branch       ,
        pc_wr       => pc_wr        ,
        i_or_d      => i_or_d       ,
        instr_wr    => instr_wr     ,
        reg_wr      => reg_wr       ,
        mem_to_reg  => mem_to_reg   ,
        reg_dst     => reg_dst      ,
        mem_write   => mem_write    ,
        src_a_ctrl  => src_a_ctrl   ,
        pc_src      => pc_src       ,
        src_b_ctrl  => src_b_ctrl   ,
        alu_ctrl    => alu_ctrl
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

        opcode <= "000000"; funct <= "100000"; -- r-type add
        wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk);

        opcode <= "000000"; funct <= "100010";  -- r-type sub
        wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk);

        opcode <= "000000"; funct <= "100100"; -- r-type and
        wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk);

        opcode <= "000000"; funct <= "100101"; -- r-type or
        wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk);
        
        opcode <= "000000"; funct <= "101010"; -- r-type slt
        wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk);

        opcode <= "100011"; -- lw
        wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk);

        opcode <= "101011";  -- sw
        wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk);

        opcode <= "000100";  -- beq
        wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk);

        opcode <= "001000";  -- addi
        wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk);

        opcode <= "000010";  -- j
        wait until rising_edge(clk); wait until rising_edge(clk); wait until rising_edge(clk);

        -- end sim
        wait until rising_edge(clk);
        sim_done <= '1';

        wait;
    end process;

end behave;
