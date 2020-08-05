----------------------------------------------------------------------------------
-- Engineer: Anatoliy
-- 
-- Create Date: 07/14/2020 04:55:37 PM
-- Module Name: tb_single_cycle_control - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity tb_single_cycle_control is
end tb_single_cycle_control;

architecture Behavioral of tb_single_cycle_control is

    -- component declaration for DUT
    component single_cycle_control is
    port ( 
        opcode      : in std_logic_vector(5 downto 0);
        funct       : in std_logic_vector(5 downto 0);
    
        mem_to_reg  : out std_logic;
        mem_write   : out std_logic;
        branch      : out std_logic;
        ALU_ctrl    : out std_logic_vector(2 downto 0); 
        ALU_src     : out std_logic;
        reg_dst     : out std_logic;
        reg_write   : out std_logic;
        jump        : out std_logic
    );
    end component single_cycle_control;

    -- inputs
    signal opcode      : std_logic_vector(5 downto 0) := (others => '0');
    signal funct       : std_logic_vector(5 downto 0) := (others => '0');

    -- outputs
    signal mem_to_reg  : std_logic := '0';
    signal mem_write   : std_logic := '0';
    signal branch      : std_logic := '0';
    signal ALU_ctrl    : std_logic_vector(2 downto 0) := (others => '0'); 
    signal ALU_src     : std_logic := '0';
    signal reg_dst     : std_logic := '0';
    signal reg_write   : std_logic := '0';
    signal jump        : std_logic := '0';

    constant period : time := 10ns;  -- 100 MHz

begin

    -- instantiate DUT
    u_single_cycle_control : single_cycle_control
    port map (
        opcode      => opcode       ,
        funct       => funct        ,

        mem_to_reg  => mem_to_reg   ,
        mem_write   => mem_write    ,
        branch      => branch       ,
        ALU_ctrl    => ALU_ctrl     ,
        ALU_src     => ALU_src      ,
        reg_dst     => reg_dst      ,
        reg_write   => reg_write    ,
        jump        => jump
    );

    -- simulation process
    stim_proc: process
    begin
        -- process init
        wait for period;

        -- loop through each set of instructions
        opcode <= "000000"; funct <= "100000"; wait for period; -- r-type add
        opcode <= "000000"; funct <= "100010"; wait for period; -- r-type sub
        opcode <= "000000"; funct <= "100100"; wait for period; -- r-type and
        opcode <= "000000"; funct <= "100101"; wait for period; -- r-type or
        opcode <= "000000"; funct <= "101010"; wait for period; -- r-type slt

        opcode <= "100011"; wait for period; -- lw
        opcode <= "101011"; wait for period; -- sw
        opcode <= "000100"; wait for period; -- beq
        opcode <= "001000"; wait for period; -- addi
        opcode <= "000010"; wait for period; -- j

        wait;
    end process;


end Behavioral;
