library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity pipleined_datapath is
port (

);
end pipleined_datapath;

architecture behave of pipleined_datapath is

    ---------------------------------------------------------------------------
    -- 32 word register file, 2 read ports and 1 write port
    ---------------------------------------------------------------------------
    component register_file_sync is
    port (
        clk         : in std_logic;
        addr_rd1    : in std_logic_vector( 4 downto 0);
        addr_rd2    : in std_logic_vector( 4 downto 0);
        addr_wr     : in std_logic_vector( 4 downto 0);
        data_wr     : in std_logic_vector(31 downto 0);
        wr_enable   : in std_logic;

        data_rd1    : out std_logic_vector(31 downto 0);
        data_rd2    : out std_logic_vector(31 downto 0)
    );
    end component register_file_sync;

    ---------------------------------------------------------------------------
    -- command and ALU decoder set up for the instructions: add, subtract, 
    -- and, or, slt, and not, and or not
    ---------------------------------------------------------------------------
    component ALU is
    port ( 
        a       : in std_logic_vector(31 downto 0);
        b       : in std_logic_vector(31 downto 0);
        funct   : in std_logic_vector( 2 downto 0);

        output  : out std_logic_vector(31 downto 0);
        zero    : out std_logic
    );
    end component ALU;

    -- ************************************************************************
    -- internal signals



begin

end behave;