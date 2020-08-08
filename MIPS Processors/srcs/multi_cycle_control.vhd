library ieee;
use ieee.std_logic_1164.all;

entity multi_cycle_control is
port (
    clk         : in std_logic;
    reset       : in std_logic;
    opcode      : in std_logic_vector(5 downto 0);
    funct       : in std_logic_vector(5 downto 0);

    branch      : out std_logic;    -- enable
    pc_wr       : out std_logic;    -- enable
    i_or_d      : out std_logic;    -- mux
    instr_wr    : out std_logic;    -- enable
    reg_wr      : out std_logic;    -- enable
    mem_to_reg  : out std_logic;    -- mux
    reg_dst     : out std_logic;    -- mux
    mem_write   : out std_logic;    -- enable
    src_a_ctrl  : out std_logic;    -- mux
    pc_src      : out std_logic_vector( 1 downto 0);    -- mux
    src_b_ctrl  : out std_logic_vector( 1 downto 0);    -- mux
    alu_ctrl    : out std_logic_vector( 2 downto 0)
);
end multi_cycle_control;

architecture behave of multi_cycle_control is

    signal ALU_op : std_logic_vector(1 downto 0);

    -- FSM states and signals
    type FSM_state is (S_FETCH, S_DECODE, S_MEM_ADDR, S_MEM_READ, S_MEM_WRITEBACK,
                       S_MEM_WRITE, S_COMPUTE, S_ALU_WRITEBACK, S_BRANCH, S_ADDI_COMPUTE,
                       S_ADDI_WRITEBACK, S_JUMP);
    signal ps   : FSM_state;
    signal ns   : FSM_state;

begin

    --------------------------------------------------------------
    -- process aresponsible for ultimately assigning ps to 
    -- ns each clock cycle
    --------------------------------------------------------------
    pr_state_transition : process (clk, reset) begin
        if (reset = '1') then
            ps <= S_FETCH;
        elsif (rising_edge(clk)) then
            ps <= ns;
        end if;
    end process pr_state_transition;

    --------------------------------------------------------------
    -- determines the ns based on the ps and the opcode provided
    --------------------------------------------------------------
    pr_state_traversal : process (ps) begin
        case ps is
            when S_FETCH          => ns <= S_DECODE;
            
            when S_DECODE         => 

                if (opcode = "100011" or opcode = "101011") then    -- if lw or sw
                    ns <= S_MEM_ADDR;
                elsif (opcode = "000000") then                      -- if r-type
                    ns <= S_COMPUTE;
                elsif (opcode = "000100") then                      -- if branch
                    ns <= S_BRANCH; 
                elsif (opcode = "001000") then                      -- if addi
                    ns <= S_ADDI_COMPUTE;
                else                                                -- if jump
                    ns <= S_JUMP;
                end if;

            when S_MEM_ADDR       =>

                if (opcode = "100011" ) then                        -- if lw
                    ns <= S_MEM_READ;
                else                                                -- if sw
                    ns <= S_MEM_WRITE;
                end if;

            when S_MEM_READ       => ns <= S_MEM_WRITEBACK;

            when S_MEM_WRITEBACK  => ns <= S_FETCH;

            when S_MEM_WRITE      => ns <= S_FETCH;

            when S_COMPUTE        => ns <= S_ALU_WRITEBACK;

            when S_ALU_WRITEBACK  => ns <= S_FETCH;

            when S_BRANCH         => ns <= S_FETCH;

            when S_ADDI_COMPUTE   => ns <= S_ADDI_WRITEBACK;

            when S_ADDI_WRITEBACK => ns <= S_FETCH;

            when S_JUMP           => ns <= S_FETCH;

        end case;
    end process pr_state_traversal;

    ------------------------------------------------------------
    -- sets the output control values for muxes and enables 
    -- based on the current state of the fsm
    ------------------------------------------------------------
    pr_state_decoder : process (ps) begin
        case ps is

            -- instruction fetch
            when S_FETCH =>
                alu_op      <= "00";

                i_or_d      <= '0';
                src_a_ctrl  <= '0';
                src_b_ctrl  <= "01";
                pc_src      <= "00";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '1';
                pc_wr       <= '1';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when S_DECODE =>
                alu_op      <= "00";

                i_or_d      <= '-';
                src_a_ctrl  <= '0';
                src_b_ctrl  <= "11";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when S_MEM_ADDR =>
                alu_op      <= "00";

                i_or_d      <= '-';
                src_a_ctrl  <= '1';
                src_b_ctrl  <= "10";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when S_MEM_READ =>
                alu_op      <= "--";

                i_or_d      <= '1';
                src_a_ctrl  <= '-';
                src_b_ctrl  <= "--";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when S_MEM_WRITEBACK =>
                alu_op      <= "--";

                i_or_d      <= '-';
                src_a_ctrl  <= '-';
                src_b_ctrl  <= "--";
                pc_src      <= "--";
                reg_dst     <= '0';
                mem_to_reg  <= '1';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '1';
                mem_write   <= '0';
                branch      <= '0';

            when S_MEM_WRITE =>
                alu_op      <= "--";

                i_or_d      <= '1';
                src_a_ctrl  <= '-';
                src_b_ctrl  <= "--";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '1';
                branch      <= '0';

            when S_COMPUTE =>
                alu_op      <= "10";

                i_or_d      <= '-';
                src_a_ctrl  <= '1';
                src_b_ctrl  <= "00";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when S_ALU_WRITEBACK =>
                alu_op      <= "--";

                i_or_d      <= '-';
                src_a_ctrl  <= '-';
                src_b_ctrl  <= "--";
                pc_src      <= "--";
                reg_dst     <= '1';
                mem_to_reg  <= '0';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '1';
                mem_write   <= '0';
                branch      <= '0';

            when S_BRANCH =>
                alu_op      <= "01";

                i_or_d      <= '-';
                src_a_ctrl  <= '1';
                src_b_ctrl  <= "00";
                pc_src      <= "01";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '1';

            when S_ADDI_COMPUTE =>
                alu_op      <= "00";

                i_or_d      <= '-';
                src_a_ctrl  <= '1';
                src_b_ctrl  <= "10";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when S_ADDI_WRITEBACK =>
                alu_op      <= "--";

                i_or_d      <= '-';
                src_a_ctrl  <= '-';
                src_b_ctrl  <= "--";
                pc_src      <= "--";
                reg_dst     <= '0';
                mem_to_reg  <= '0';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '1';
                mem_write   <= '0';
                branch      <= '0';

            when S_JUMP           =>
                alu_op      <= "--";

                i_or_d      <= '-';
                src_a_ctrl  <= '-';
                src_b_ctrl  <= "--";
                pc_src      <= "10";
                reg_dst     <= '0';
                mem_to_reg  <= '0';

                instr_wr    <= '0';
                pc_wr       <= '1';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

        end case;
    end process pr_state_decoder;

    ---------------------------------------------------------------------------
    -- ALU control unit deciding what computation to preform
    ---------------------------------------------------------------------------
    pr_ALU_control : process(ALU_op, funct)
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
    end process pr_ALU_control;
end behave;