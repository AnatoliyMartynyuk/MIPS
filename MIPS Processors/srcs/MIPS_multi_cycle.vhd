library ieee;
use ieee.std_logic_1164.all;

entity MIPS_multi_cycle is
port (
    clk         : in std_logic;
    reset       : in std_logic;
    mem_word    : in std_logic_vector(31 downto 0);

    mem_write   : out std_logic;

    mem_addr    : out std_logic_vector(31 downto 0);
    data_wr     : out std_logic_vector(31 downto 0)
);
end MIPS_multi_cycle;

architecture struct of MIPS_multi_cycle is

    ---------------------------------------------------------------------------
    -- Information datapath. Maintains data words within internal register
    -- file and operates on them with ALU.
    ---------------------------------------------------------------------------
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
    
        instr       : out std_logic_vector(31 downto 0);
        mem_addr    : out std_logic_vector(31 downto 0);
        data_wr     : out std_logic_vector(31 downto 0);
        zero        : out std_logic
    );
    end component multi_cycle_datapath;


    ---------------------------------------------------------------------------
    -- command and ALU decoder set up for the instructions: add, subtract, 
    -- and, or, slt, and not, and or not
    ---------------------------------------------------------------------------
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

    -- ctrl wires between control and datapth
    signal branch       : std_logic;
    signal pc_wr        : std_logic;
    signal i_or_d       : std_logic;
    signal instr_wr     : std_logic;
    signal reg_wr       : std_logic;
    signal mem_to_reg   : std_logic;
    signal reg_dst      : std_logic;
    signal src_a_ctrl   : std_logic;
    signal pc_src       : std_logic_vector( 1 downto 0);
    signal src_b_ctrl   : std_logic_vector( 1 downto 0);
    signal alu_ctrl     : std_logic_vector( 2 downto 0);
    signal zero         : std_logic;

    signal instr        : std_logic_vector(31 downto 0);


begin

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
            
        instr       => instr        ,
        mem_addr    => mem_addr     ,
        data_wr     => data_wr      ,
        zero        => zero
    );

    u_multi_cycle_control : multi_cycle_control
    port map (
        clk         => clk                  ,
        reset       => reset                ,
        opcode      => instr(31 downto 26)  ,
        funct       => instr( 5 downto  0)  ,

        branch      => branch               ,
        pc_wr       => pc_wr                ,
        i_or_d      => i_or_d               ,
        instr_wr    => instr_wr             ,
        reg_wr      => reg_wr               ,
        mem_to_reg  => mem_to_reg           ,
        reg_dst     => reg_dst              ,
        mem_write   => mem_write            ,
        src_a_ctrl  => src_a_ctrl           ,
        pc_src      => pc_src               ,
        src_b_ctrl  => src_b_ctrl           ,
        alu_ctrl    => alu_ctrl
    );


end struct;