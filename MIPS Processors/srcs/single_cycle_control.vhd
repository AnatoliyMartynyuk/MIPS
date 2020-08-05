library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity single_cycle_control is
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
end single_cycle_control;

architecture rt1 of single_cycle_control is

    signal ALU_op : std_logic_vector(1 downto 0);

begin

    ---------------------------------------------------------------------------
    -- primary control unit responsible for r-type, lw, sw, beq, addi and j
    -- instructions
    ---------------------------------------------------------------------------
    control_pr : process(opcode)
    begin
        case opcode is
            -- R-type instruction
            when "000000" =>
                mem_to_reg  <= '0';
                mem_write   <= '0';
                branch      <= '0';
                ALU_op      <= "10";
                ALU_src     <= '0';
                reg_dst     <= '1';
                reg_write   <= '1';
                jump        <= '0';

            -- load word (lw)
            when "100011" =>
                mem_to_reg  <= '1';
                mem_write   <= '0';
                branch      <= '0';
                ALU_op      <= "00";
                ALU_src     <= '1';
                reg_dst     <= '0';
                reg_write   <= '1';
                jump        <= '0';

            -- store word (sw)
            when "101011" =>
                mem_to_reg  <= '-';
                mem_write   <= '1';
                branch      <= '0';
                ALU_op      <= "00";
                ALU_src     <= '1';
                reg_dst     <= '-';
                reg_write   <= '0';
                jump        <= '0';

            -- branch if equal (beq)
            when "000100" =>
                mem_to_reg  <= '-';
                mem_write   <= '0';
                branch      <= '1';
                ALU_op      <= "01";
                ALU_src     <= '0';
                reg_dst     <= '-';
                reg_write   <= '0';
                jump        <= '0';

            -- add immediate (addi)
            when "001000" =>
                mem_to_reg  <= '0';
                mem_write   <= '0';
                branch      <= '0';
                ALU_op      <= "00";
                ALU_src     <= '1';
                reg_dst     <= '0';
                reg_write   <= '1';
                jump        <= '0';

            -- jump (j)
            when "000010" =>
                mem_to_reg  <= '-';
                mem_write   <= '0';
                branch      <= '-';
                ALU_op      <= "--";
                ALU_src     <= '-';
                reg_dst     <= '-';
                reg_write   <= '0';
                jump        <= '1';
            
            -- default
            when others =>
                mem_to_reg  <= '-';
                mem_write   <= '-';
                branch      <= '-';
                ALU_op      <= "--";
                ALU_src     <= '-';
                reg_dst     <= '-';
                reg_write   <= '-';
                jump        <= '-';
        end case;
    end process;

    ---------------------------------------------------------------------------
    -- ALU control unit deciding what computation to preform
    ---------------------------------------------------------------------------
    ALU_control_pr : process(ALU_op, funct)
    begin
        if (ALU_op = "00") then
            ALU_ctrl <= "010";  -- add

        elsif (ALU_op = "01") then
            ALU_ctrl <= "110"; -- subtract

        else
            case funct is
                when "100000" => ALU_ctrl <= "010"; -- add
                when "100010" => ALU_ctrl <= "110"; -- subtract
                when "100100" => ALU_ctrl <= "000"; -- and
                when "100101" => ALU_ctrl <= "001"; -- or
                when "101010" => ALU_ctrl <= "111"; -- set less than
                when others   => ALU_ctrl <= "---";
            end case;

        end if;
    end process;

end rt1;
