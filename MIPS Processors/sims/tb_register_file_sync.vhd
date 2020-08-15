library ieee;
use ieee.std_logic_1164.all;


entity tb_register_file_sync is
end tb_register_file_sync;

architecture Behavioral of tb_register_file_sync is

    -- component declaration for DUT

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

    -- inputs
    signal clk         : std_logic := '0';
    signal addr_rd1    : std_logic_vector( 4 downto 0) := (others => '0');
    signal addr_rd2    : std_logic_vector( 4 downto 0) := (others => '0');
    signal addr_wr     : std_logic_vector( 4 downto 0) := (others => '0');
    signal data_wr     : std_logic_vector(31 downto 0) := (others => '0');
    signal wr_enable   : std_logic := '0';

    -- outputs
    signal data_rd1    : std_logic_vector(31 downto 0);
    signal data_rd2    : std_logic_vector(31 downto 0);

    -- clk period constants
    constant clk_period : time := 10ns;  -- 100 MHz

    begin

        -- instantiat DUT
        u_register_file_sync : register_file_sync
        port map (
            clk         => clk          ,
            addr_rd1    => addr_rd1     ,
            addr_rd2    => addr_rd2     ,
            addr_wr     => addr_wr      ,
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
        end process clk_process;


        -- simulation process
        stim_proc: process
        begin
            -- process init
            wait until rising_edge(clk);

            -- fill 0x1 with 0xDEADBEEF and 0x2 with 0xBEEFDEAD
            addr_wr <= "00000"; wr_enable <= '0'; data_wr <= x"DEADBEEF"; wait until rising_edge(clk);
            addr_wr <= "00001"; wr_enable <= '1';                         wait until rising_edge(clk);
            addr_wr <= "00010";                   data_wr <= x"BEEFDEAD"; wait until rising_edge(clk);
            addr_wr <= "00011"; wr_enable <= '0';                         wait until rising_edge(clk);

            -- traverse addresses 0x0 through 0x3 with both read ports starting at opposite ends
            addr_rd1 <= "00000"; addr_rd2 <= "00011"; wait until rising_edge(clk);
            addr_rd1 <= "00001"; addr_rd2 <= "00010"; wait until rising_edge(clk);
            addr_rd1 <= "00010"; addr_rd2 <= "00001"; wait until rising_edge(clk);
            addr_rd1 <= "00011"; addr_rd2 <= "00000"; wait until rising_edge(clk);

            wait;
        end process stim_proc;

end Behavioral;
