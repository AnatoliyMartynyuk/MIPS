library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_MIPS_memory is
end tb_MIPS_memory;

architecture behave of tb_MIPS_memory is

    -- component declaration for DUT

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

    -- inputs
    signal clk          : std_logic := '0';
    signal addr1        : std_logic_vector( 6 downto 0) := (others => '0');
    signal addr2        : std_logic_vector( 6 downto 0) := (others => '0');
    signal data_wr      : std_logic_vector(31 downto 0) := (others => '0');
    signal wr_enable    : std_logic := '0';

    -- outputs
    signal data_rd1     : std_logic_vector(31 downto 0);
    signal data_rd2     : std_logic_vector(31 downto 0);

    -- clk period constants
    constant clk_period : time := 10ns;  -- 100 MHz

    begin

        -- instantiat DUT
        u_MIPS_memory : MIPS_memory
        port map (
            clk         => clk          ,
            addr1       => addr1        ,
            addr2       => addr2        ,
            data_wr     => data_wr      ,
            wr_enable   => wr_enable    ,

            data_rd1    => data_rd1     ,
            data_rd2    => data_rd2
        );

        -- clock simulation
        clk_process : process
        begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;


        -- simulation process
        stim_proc: process
        begin
            -- process init
            wait until rising_edge(clk);
            
            -- simple reading
            addr1 <= "0000100"; wait until rising_edge(clk);
            addr1 <= "0001000"; wait until rising_edge(clk);
            addr1 <= "0001100"; wait until rising_edge(clk);

            -- simple notable writes
            wr_enable <= '1';
            addr2 <= "0001100"; data_wr <= 32x"DEAD"; wait until rising_edge(clk);
            addr2 <= "0010000"; data_wr <= 32x"BEEF"; wait until rising_edge(clk);
            addr2 <= "0010100"; data_wr <= 32x"AAAA"; wait until rising_edge(clk);
            wr_enable <= '0';                         wait until rising_edge(clk);

            -- confirmative reads
            addr1 <= "0001100"; addr2 <= "0010100"; wait until rising_edge(clk);
            addr1 <= "0010000"; addr2 <= "0010000"; wait until rising_edge(clk);
            addr1 <= "0010100"; addr2 <= "0001100"; wait until rising_edge(clk);

            wait;
        end process;

end behave;