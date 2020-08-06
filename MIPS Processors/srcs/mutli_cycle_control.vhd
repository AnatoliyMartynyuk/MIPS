library ieee;
use ieee.std_logic_1164.all;

entity multi_cycle_control is
port (
    clk
    reset
    opcode
    funct

    pc_src      : out std_logic;    -- mux
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
    type FSM_state is (fetch, decode, mem_addr, mem_read, mem_writeback,
                       mem_write, compute, alu_writeback, branch, addi_compute
                       addi_writeback, jump);
    signal ps   : FSM_state;
    signal ns   : FSM_state;

begin

    --------------------------------------------------------------
    -- process aresponsible for ultimately assigning ps to 
    -- ns each clock cycle
    --------------------------------------------------------------
    pr_state_transition : process (clk, reset) begin
        if (reset <= '1') then
            ps <= fetch;
        elsif (rising_edge(clk)) then
            ps <= ns;
        end if;
    end process pr_state_transition;

    --------------------------------------------------------------
    -- determines the ns based on the ps and the opcode provided
    --------------------------------------------------------------
    pr_state_traversal : process (ps) begin
        case ps is
            when fetch          => ns <= decode;
            
            when decode         => 

                if (opcode = "100011" or opcode = "101011") -- if lw or sw
                    ns <= mem_addr
                elsif (opcode = "000000")                   -- if r-type
                    ns <= compute;
                elsif (opcode = "000100")                   -- if branch
                    ns <= branch; 
                elsif (opcode = "000010")                   -- if addi
                    ns <= addi_compute;
                else                                        -- if jump
                    ns <= jump;
                end if;

            when mem_addr       =>

                if (opcode = "100011" )                     -- if lw
                    ns <= mem_read
                else                                        -- if sw
                    ns <= mem_write;
                end if;

            when mem_read       => ns <= mem_writeback

            when mem_writeback  => ns <= fetch;

            when mem_write      => ns <= fetch;

            when compute        => ns <= alu_writeback;

            when alu_writeback  => ns <= fetch;

            when branch         => ns <= fetch;

            when addi_compute   => ns <= addi_writeback;

            when addi_writeback => ns <= fetch;

            when jump           => ns <= fetch;

        end case;
    end process pr_state_traversal;

    ------------------------------------------------------------
    -- sets the output control values for muxes and enables 
    -- based on the current state of the fsm
    ------------------------------------------------------------
    pr_state_decoder : process (ps) begin
        case ps is

            -- instruction fetch
            when fetch =>
                alu_op      <= "00";

                i_or_d      <= '0';
                alu_src_a   <= '0';
                alu_src_b   <= "01";
                pc_src      <= "00";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '1';
                pc_wr       <= '1';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when decode =>
                alu_op      <= "00";

                i_or_d      <= '-';
                alu_src_a   <= '0';
                alu_src_b   <= "11";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when mem_addr =>
                alu_op      <= "00";

                i_or_d      <= '-';
                alu_src_a   <= '1';
                alu_src_b   <= "10";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when mem_read =>
                alu_op      <= "--";

                i_or_d      <= '1';
                alu_src_a   <= '-';
                alu_src_b   <= "--";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when mem_writeback =>
                alu_op      <= "--";

                i_or_d      <= '-';
                alu_src_a   <= '-';
                alu_src_b   <= "--";
                pc_src      <= "--";
                reg_dst     <= '0';
                mem_to_reg  <= '1';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '1';
                mem_write   <= '0';
                branch      <= '0';

            when mem_write =>
                alu_op      <= "--";

                i_or_d      <= '1';
                alu_src_a   <= '-';
                alu_src_b   <= "--";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '1';
                branch      <= '0';

            when compute =>
                alu_op      <= "10";

                i_or_d      <= '-';
                alu_src_a   <= '1';
                alu_src_b   <= "00";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when alu_writeback =>
                alu_op      <= "--";

                i_or_d      <= '-';
                alu_src_a   <= '-';
                alu_src_b   <= "--";
                pc_src      <= "--";
                reg_dst     <= '1';
                mem_to_reg  <= '0';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '1';
                mem_write   <= '0';
                branch      <= '0';

            when branch =>
                alu_op      <= "01";

                i_or_d      <= '-';
                alu_src_a   <= '1';
                alu_src_b   <= "00";
                pc_src      <= "01";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '1';

            when addi_compute =>
                alu_op      <= "00";

                i_or_d      <= '-';
                alu_src_a   <= '1';
                alu_src_b   <= "10";
                pc_src      <= "--";
                reg_dst     <= '-';
                mem_to_reg  <= '-';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '0';
                mem_write   <= '0';
                branch      <= '0';

            when addi_writeback =>
                alu_op      <= "--";

                i_or_d      <= '-';
                alu_src_a   <= '-';
                alu_src_b   <= "--";
                pc_src      <= "--";
                reg_dst     <= '0';
                mem_to_reg  <= '0';

                instr_wr    <= '0';
                pc_wr       <= '0';
                reg_wr      <= '1';
                mem_write   <= '0';
                branch      <= '0';

            when jump           =>
                alu_op      <= "--";

                i_or_d      <= '-';
                alu_src_a   <= '-';
                alu_src_b   <= "--";
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