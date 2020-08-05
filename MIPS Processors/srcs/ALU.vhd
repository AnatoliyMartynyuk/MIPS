library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;


entity ALU is
port ( 
    a       : in std_logic_vector(31 downto 0);
    b       : in std_logic_vector(31 downto 0);
    funct   : in std_logic_vector( 2 downto 0);

    output  : out std_logic_vector(31 downto 0);
    zero    : out std_logic
);
end ALU;

architecture behavioral of ALU is

    signal result : std_logic_vector(31 downto 0);

begin
    ---------------------------------------------------
    -- behavioral definition of the ALU's operations
    ---------------------------------------------------
    pr_compute : process (all)
    begin
        case funct is
            when "000" => result <= a and b;        -- &
            when "001" => result <= a or b;         -- |
            when "010" => result <= a + b;          -- +
            when "100" => result <= a and (not b);  -- &~
            when "101" => result <= a or (not b);   -- |~
            when "110" => result <= a - b;          -- -
            when "111" =>                           -- slt
                if (a < b) then
                    result <= x"00000001";
                else 
                    result <= x"00000000";
                end if;

            when others => result <= x"00000000"; -- should nver happen
        end case;
    end process;

    zero <= '1' when (result = x"00000000") else '0';
    output <= result;

end behavioral;
