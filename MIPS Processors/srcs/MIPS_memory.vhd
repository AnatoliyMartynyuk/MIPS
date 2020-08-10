library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use STD.TEXTIO.all;

entity MIPS_memory is
port (
    clk         : in std_logic;
    addr1       : in std_logic_vector( 6 downto 0);  -- read only port
    addr2       : in std_logic_vector( 6 downto 0);  -- read/write port
    data_wr     : in std_logic_vector(31 downto 0);
    wr_enable   : in std_logic;

    data_rd1    : out std_logic_vector(31 downto 0);
    data_rd2    : out std_logic_vector(31 downto 0)
);
end MIPS_memory;

architecture behave of MIPS_memory is

    -- memory array: 128 byte addressable words
    type t_memory is array (511 downto 0) of std_logic_vector(7 downto 0);

    ---------------------------------------------------------------------------
    -- memory initialization function
    -- Takes a 128 line file of 32 bit words and organizes them in little 
    -- endian order with the first word in the file corrsponding to word 0 
    ---------------------------------------------------------------------------
    impure function init_memory_hfile (file_name : in string) return t_memory is   -- add impure to make the function work
        file     text_file       : text open read_mode is file_name;
        variable text_line       : line;
        variable word            : std_logic_vector(31 downto 0);
        variable memory_contents : t_memory;
    begin
        for i in 0 to 127 loop
            -- reads line out of file and stores it into 32 bit variable word
            readline(text_file, text_line);
            hread(text_line, word);

            -- arranges the words in little endien format
            memory_contents((i * 4) + 0) := word( 7 downto  0);
            memory_contents((i * 4) + 1) := word(15 downto  8);
            memory_contents((i * 4) + 2) := word(23 downto 16);
            memory_contents((i * 4) + 3) := word(31 downto 24);
        end loop;

        return memory_contents;
    end function;

    signal memory : t_memory := init_memory_hfile("../srcs/instruction_mif.txt");

begin
    -- asynchronous reading from the memory
    data_rd1 <= (memory(to_integer(unsigned(addr1)) + 3), memory(to_integer(unsigned(addr1)) + 2),
                 memory(to_integer(unsigned(addr1)) + 1), memory(to_integer(unsigned(addr1)) + 0));

    data_rd2 <= (memory(to_integer(unsigned(addr2)) + 3), memory(to_integer(unsigned(addr2)) + 2),
                 memory(to_integer(unsigned(addr2)) + 1), memory(to_integer(unsigned(addr2)) + 0));

    -- synchronous write tied to the wr_enable control signal
    pr_data_wr : process(clk)
    begin
        if (rising_edge(clk)) then
            if (wr_enable = '1') then
                memory(to_integer(unsigned(addr2)) + 3) <= data_wr(31 downto 24);
                memory(to_integer(unsigned(addr2)) + 2) <= data_wr(23 downto 16);
                memory(to_integer(unsigned(addr2)) + 1) <= data_wr(15 downto  8);
                memory(to_integer(unsigned(addr2)) + 0) <= data_wr( 7 downto  0);
            end if;
        end if;
    end process;

end behave;
