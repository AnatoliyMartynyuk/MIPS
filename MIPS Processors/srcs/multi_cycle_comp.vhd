library ieee;
use ieee.std_logic_1164.all;

entity multi_cycle_comp is
port (
    clk     : in std_logic;
    reset   : in std_logic
);
end multi_cycle_comp;

architecture struct of multi_cycle_comp is

    -- multi_cycle MIPS processor
    component MIPS_multi_cycle is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        mem_word    : in std_logic_vector(31 downto 0);
        
        mem_write   : out std_logic;
        
        mem_addr    : out std_logic_vector(31 downto 0);
        data_wr     : out std_logic_vector(31 downto 0)
    );
    end component MIPS_multi_cycle;

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

    -- wires between memory and processor
    signal mem_word    : std_logic_vector(31 downto 0);
    signal mem_write   : std_logic;
    signal mem_addr    : std_logic_vector(31 downto 0);
    signal data_wr     : std_logic_vector(31 downto 0);

begin

    u_MIPS_multi_cycle : MIPS_multi_cycle
    port map (
        clk         => clk          ,
        reset       => reset        ,
        mem_word    => mem_word     ,
        
        mem_write   => mem_write    ,
        
        mem_addr    => mem_addr     ,
        data_wr     => data_wr
    );

    u_MIPS_memory : MIPS_memory
    port map (
        clk         => clk                      ,
        addr1       => (others => '0')          , -- unused
        addr2       => mem_addr( 6 downto 0)    ,
        data_wr     => data_wr                  ,
        wr_enable   => mem_write                ,

        data_rd1    => open                     , -- unused
        data_rd2    => mem_word
    );

end struct;