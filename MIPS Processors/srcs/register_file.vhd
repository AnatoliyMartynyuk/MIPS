library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity register_file is
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
end register_file;

architecture behavioral of register_file is

    type t_memory is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal memory : t_memory;

begin

    -----------------------------------------------------------------------
    -- asyncronous dual port read process. R0 is hardwired to 0x00000000
    -----------------------------------------------------------------------
    pr_read_async : process (addr_rd1, addr_rd2)
    begin

        -- addr/rd port 1
        if (addr_rd1 = "00000") then
            data_rd1 <= x"00000000";
        else
            data_rd1 <= memory(to_integer(unsigned(addr_rd1)));
        end if;

        -- addr/rd port 2
        if (addr_rd2 = "00000") then
            data_rd2 <= x"00000000";
        else
            data_rd2 <= memory(to_integer(unsigned(addr_rd2)));
        end if;

    end process;

    -----------------------------------------------------------------------
    -- syncronous single port write pocess
    -----------------------------------------------------------------------
    pr_write_sync : process(clk)
    begin
        if (rising_edge(clk) and wr_enable = '1') then
            memory(to_integer(unsigned(addr_wr))) <= data_wr;
        end if;
    end process;


end behavioral;
