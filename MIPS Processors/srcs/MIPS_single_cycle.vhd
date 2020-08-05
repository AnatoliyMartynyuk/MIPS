library ieee;
use ieee.std_logic_1164.all;

entity MIPS_single_cycle is
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
end MIPS_single_cycle;

architecture struct of MIPS_single_cycle is

    ---------------------------------------------------------------------------
    -- Information datapath. Maintains data words within internal register
    -- file and operates on them with ALU.
    ---------------------------------------------------------------------------
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


    ---------------------------------------------------------------------------
    -- command and ALU decoder set up for the instructions: // TODO Fill in
    ---------------------------------------------------------------------------
    component single_cycle_control is
    port ( 
        opcode      : in std_logic_vector(5 downto 0);
        funct       : in std_logic_vector(5 downto 0);
    
        mem_to_reg  : out std_logic;
        mem_write   : out std_logic;
        branch      : out std_logic;
        ALU_ctrl    : out std_logic_vector(2 downto 0); 
        ALU_src     : out std_logic;
        reg_dst     : out std_logic;
        reg_write   : out std_logic;
        jump        : out std_logic
    );
    end component single_cycle_control;
    
    -- ctrl signals
    signal alu_ctrl     : std_logic_vector( 2 downto 0);
    signal mem_to_reg   : std_logic;
    signal alu_src      : std_logic;
    signal reg_dst      : std_logic;
    signal reg_wr       : std_logic;
    signal branch       : std_logic;
    signal jump         : std_logic;
    signal zero         : std_logic;
    
begin

    u_single_cycle_datapath : single_cycle_datapath
    port map(
        clk         => clk              ,
        reset       => reset            ,
        instr       => instr            ,
        mem_data    => mem_data         ,
        
        alu_ctrl    => alu_ctrl         ,
        pc_src      => zero and branch  ,
        mem_to_reg  => mem_to_reg       ,
        alu_src     => alu_src          ,
        reg_dst     => reg_dst          ,
        reg_wr      => reg_wr           ,
        jump        => jump             ,

        pc          => pc               ,
        alu_out     => alu_out          ,
        data_wr     => data_wr          ,
        zero        => zero
    );

    u_single_cycle_control : single_cycle_control
    port map (
        opcode      => instr(31 downto 26)  ,
        funct       => instr( 5 downto  0)  ,

        mem_to_reg  => mem_to_reg   ,
        mem_write   => mem_write    ,
        branch      => branch       ,
        ALU_ctrl    => ALU_ctrl     ,
        ALU_src     => ALU_src      ,
        reg_dst     => reg_dst      ,
        reg_write   => reg_wr       ,
        jump        => jump
    );

end struct;