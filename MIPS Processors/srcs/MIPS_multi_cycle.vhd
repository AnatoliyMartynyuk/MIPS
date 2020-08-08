library ieee;
use ieee.std_logic_1164.all;

entity MIPS_multi_cycle is
port (
    clk         : in std_logic;
    reset       : in std_logic;
    mem_word    : in std_logic_vector(31 downto 0);

    mem_write   : out std_logic;

    mem_addr    : out std_logic_vector(31 downto 0);
    data_wr     : out std_logic_vector(31 downto 0);
);
end MIPS_multi_cycle;