library ieee;
use ieee.std_logic_1164.all;

entity tb_single_cycle_comp is
end tb_single_cycle_comp;

architecture behave of tb_single_cycle_comp is

    component single_cycle_comp is
    port (
        clk     : in std_logic;
        reset   : in std_logic
    );
    end component single_cycle_comp;

    signal clk      : std_logic;
    signal reset    : std_logic;

    -- clk period constants
    constant clk_period : time := 10ns;  -- 100 MHz
    signal sim_done     : std_logic := '0';

begin

    -- instantiate DUT
    u_single_cycle_comp : single_cycle_comp
    port map (
        clk     => clk,
        reset   => reset
    );

    -- clock simulation
    clk_process : process
    begin
        if (sim_done = '0') then
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        else
            wait;
        end if;
    end process;

        -- simulation process
    stim_proc: process
    begin

        -- process init
        wait until rising_edge(clk);
        reset <= '1';
        wait until rising_edge(clk);
        reset <= '0';

        timer : for i in 0 to 17 loop
            wait until rising_edge(clk);
        end loop timer;

        sim_done <= '1';

        wait;
    end process;

end behave;