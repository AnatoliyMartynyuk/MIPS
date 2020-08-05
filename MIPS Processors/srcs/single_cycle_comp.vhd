library ieee;
use ieee.std_logic_1164.all;

entity single_cycle_comp is
port (
    clk     : in std_logic;
    reset   : in std_logic
);
end single_cycle_comp;

architecture struct of single_cycle_comp is

    -- single cycle MIPS processor
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

    -- 128 word dual port memory.
    component MIPS_memory is
    port (
        clk         : in std_logic;
        addr1       : in std_logic_vector( 6 downto 0);  -- read only port
        addr2       : in std_logic_vector( 6 downto 0);  -- read/write port
        data_wr     : in std_logic_vector(31 downto 0);
        wr_enable   : in std_logic;

        data_rd1    : out std_logic_vector(31 downto 0);
        data_rd2    : out std_logic_vector(31 downto 0)
    );
    end component MIPS_memory;

    signal instr        : std_logic_vector(31 downto 0);
    signal mem_data     : std_logic_vector(31 downto 0);
    signal pc           : std_logic_vector(31 downto 0);
    signal data_addr    : std_logic_vector(31 downto 0);
    signal data_wr      : std_logic_vector(31 downto 0);

    signal mem_write    : std_logic;

begin

    u_MIPS_single_cycle : MIPS_single_cycle
    port map (
        clk         => clk          ,
        reset       => reset        ,
        instr       => instr        ,
        mem_data    => mem_data     ,
    
        mem_write   => mem_write    ,
    
        pc          => pc           ,
        alu_out     => data_addr    ,
        data_wr     => data_wr
    );

    u_MIPS_memory : MIPS_memory
    port map (
        clk         => clk                      ,
        addr1       => pc (6 downto 0)          ,
        addr2       => data_addr (6 downto 0)   ,
        data_wr     => data_wr                  ,
        wr_enable   => mem_write                ,

        data_rd1    => instr                    ,
        data_rd2    => mem_data
    );

end struct;