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
    type FSM_state is (fetch_s, decode_s, mem_addr_s, mem_read_s, mem_writeback_s,
                       mem_write_s, compute_s, alu_writeback_s, branch_s, addi_compute_s,
                       addi_writeback_s, jump_s);
    signal ps   : FSM_state := decode_s;
    signal ns   : FSM_state;

begin

    --------------------------------------------------------------
    -- process aresponsible for ultimately assigning ps to 
    -- ns each clock cycle
    --------------------------------------------------------------
    pr_state_transition : process (clk, reset) begin
        if (reset <= '1') then
            ps <= fetch_s;
        elsif (rising_edge(clk)) then
            ps <= ns;
        end if;
    end process pr_state_transition;

    --------------------------------------------------------------
    -- determines the ns based on the ps and the opcode provided
    --------------------------------------------------------------
    pr_state_traversal : process (ps) begin
        case ps is
            when fetch_s          => ns <= decode_s;
            
            when decode_s         => 

                if (opcode = "100011" or opcode = "101011") then    -- if lw or sw
                    ns <= mem_addr_s;
                elsif (opcode = "000000") then                      -- if r-type
                    ns <= compute_s;
                elsif (opcode = "000100") then                      -- if branch
                    ns <= branch_s; 
                elsif (opcode = "000010") then                      -- if addi
                    ns <= addi_compute_s;
                else                                                -- if jump
                    ns <= jump_s;
                end if;

            when mem_addr_s       =>

                if (opcode = "100011" ) then                        -- if lw
                    ns <= mem_read_s;
                else                                                -- if sw
                    ns <= mem_write_s;
                end if;

            when mem_read_s       => ns <= mem_writeback_s;

            when mem_writeback_s  => ns <= fetch_s;

            when mem_write_s      => ns <= fetch_s;

            when compute_s        => ns <= alu_writeback_S;

            when alu_writeback_s  => ns <= fetch_s;

            when branch_s         => ns <= fetch_s;

            when addi_compute_s   => ns <= addi_writeback_s;

            when addi_writeback_s => ns <= fetch_s;

            when jump_s           => ns <= fetch_s;

        end case;
    end process pr_state_traversal;

    ------------------------------------------------------------
    -- sets the output control values for muxes and enables 
    -- based on the current state of the fsm
    ------------------------------------------------------------
    pr_state_decoder : process (ps) begin
        case ps is

            -- instruction fetch
            when fetch_s =>
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

            when decode_s =>
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

            when mem_addr_s =>
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

            when mem_read_s =>
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

            when mem_writeback_s =>
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

            when mem_write_s =>
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

            when compute_s =>
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

            when alu_writeback_s =>
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

            when branch_s =>
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

            when addi_compute_s =>
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

            when addi_writeback_s =>
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

            when jump_s           =>
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