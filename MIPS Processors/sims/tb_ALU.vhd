----------------------------------------------------------------------------------
-- Engineer: Anatoliy
-- 
-- Create Date: 07/15/2020 04:58:37 PM
-- Module Name: tb_ALU
-- Project Name: MIPS
-- Target Devices: ARTY A7 T100
-- Tool Versions: Vivado 2017.4
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_ALU is
end tb_ALU;

architecture Behavioral of tb_ALU is

    component ALU is
    port ( 
        a       : in std_logic_vector(31 downto 0);
        b       : in std_logic_vector(31 downto 0);
        funct   : in std_logic_vector( 2 downto 0);

        output  : out std_logic_vector(31 downto 0);
        zero    : out std_logic
    );
    end component ALU;

    -- inputs
    signal a        : std_logic_vector(31 downto 0);
    signal b        : std_logic_vector(31 downto 0);
    signal funct    : std_logic_vector( 2 downto 0);

    -- outputs
    signal output   : std_logic_vector(31 downto 0);
    signal zero     : std_logic;

    constant period : time := 10ns;  -- 100 MHz

begin

    -- instantiate DUT
    u_ALU : ALU
    port map (
        a       => a        ,
        b       => b        ,
        funct   => funct    ,

        output  => output   ,
        zero    => zero
    );

    -- simulation process
    stim_proc : process
    begin
        wait for period;

        -- addition / subtraction
        a <= 32d"4"; b <= 32d"4"; funct <= "010"; wait for period; -- 4 + 4
        a <= 32d"4"; b <= 32d"4"; funct <= "110"; wait for period; -- 4 - 4

        -- logical operators
        a <= x"FFFFF000"; b <= x"000FFFFF"; funct <= "000"; wait for period; -- a and b
        a <= x"FFFFF000"; b <= x"000FFFFF"; funct <= "001"; wait for period; -- a or b
        a <= x"FFFFF000"; b <= x"000FFFFF"; funct <= "100"; wait for period; -- a and not b
        a <= x"FFFFF000"; b <= x"000FFFFF"; funct <= "101"; wait for period; -- a or not b

        -- stl
        a <= 32b"1"; b <= 32b"0"; funct <= "111"; wait for period; -- a < b
        a <= 32b"0"; b <= 32b"1"; funct <= "111"; wait for period; -- a !< b

        a <= x"FFFFFFFF"; b <= x"0FFFFFFF"; wait for period;
        a <= x"DEADBEEF"; b <= x"BEEFDEAD"; wait for period;

        wait;
    end process;


end Behavioral;
