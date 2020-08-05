library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity multi_cycle_datapath is
port (
    clk         : in std_logic;
    reset       : in std_logic;
    mem_word    : in std_logic_vector(31 downto 0);

    pc_wr       : in std_logic;
    mem_access  : in std_logic;
    instr_wr    : in std_logic;
    reg_wr      : in std_logic;
    src_a_ctrl  : in std_logic;
    src_b_ctrl  : in std_logic_vector( 1 downto 0);
    alu_ctrl    : in std_logic_vector( 2 downto 0);

    mem_addr    : out std_logic_vector(31 downto 0);
    data_wr     : out std_logic_vector(31 downto 0);
    zero        : out std_logic
);
end multi_cycle_datapath;

architecture behave of multi_cycle_datapath is

    ---------------------------------------------------------------------------
    -- 32 word register file, 2 read ports and 1 write port
    ---------------------------------------------------------------------------
    component register_file is
    port (
        clk         : in std_logic;
        addr_rd1    : in std_logic_vector( 4 downto 0);
        addr_rd2    : in std_logic_vector( 4 downto 0);
        addr_wr     : in std_logic_vector( 4 downto 0);
        data_wr     : in std_logic_vector(31 downto 0);
        wr_enable   : in std_logic;
    
        data_rd1    : out std_logic_vector(31 downto 0);
                : out std_logic_vector(31 downto 0)
    );
    end component register_file;
    
    ---------------------------------------------------------------------------
    -- computation unit with the capacity to compute // TODO Fill in
    ---------------------------------------------------------------------------
    component ALU is
    port ( 
        a       : in std_logic_vector(31 downto 0);
        b       : in std_logic_vector(31 downto 0);
        funct   : in std_logic_vector( 2 downto 0);
    
        output  : out std_logic_vector(31 downto 0);
        zero    : out std_logic
    );
    end component ALU;
    
    -- ************************************************************************
    -- internal signals

    signal pc           : std_logic_vector(31 downto 0);
    signal pc_n         : std_logic_vector(31 downto 0);      

    signal instr        : std_logic_vector(31 downto 0);
    signal mem_data     : std_logic_vector(31 downto 0);
    signal sign_imm     : std_logic_vector(31 downto 0);

    signal reg_rd1      : std_logic_vector(31 downto 0);
    signal reg_rd2      : std_logic_vector(31 downto 0);
    signal reg_rd1_d1   : std_logic_vector(31 downto 0);
    signal reg_rd2_d1   : std_logic_vector(31 downto 0);

    signal src_a        : std_logic_vector(31 downto 0);
    signal src_b        : std_logic_vector(31 downto 0);
    signal alu_out      : std_logic_vector(31 downto 0);
    signal alu_out_d1   : std_logic_vector(31 downto 0);

begin

    ----------------------------------------------------------
    -- update the program counter to access next instruction
    ----------------------------------------------------------
    pc_update : process(clk) begin
        if (rising_edge(clk)) then
            if (pc_wr = '1') then
                pc <= pc_n;
            end if;
        end if;
    end process pc_update;


    ------------------------------------
    -- memory read registers
    ------------------------------------
    memory_access : process(clk) begin
        if (rising_edge(clk)) then
            -- instruction updates
            if (instr_wr) then
                instr <= mem_word;
            end if;

            -- memory data reads
            mem_data <= mem_word;

        end if;
    end process memory_access;


    -------------------------------------------
    -- register_file and alu delay registers 
    -------------------------------------------
    reg_file_reads  : process(clk) begin
        if (rising_edge(clk)) then
            reg_rd1_d1 <= reg_rd1;
            reg_rd2_d1 <= reg_rd2;
            alu_out_d1 <= alu_out;
        end if;
    end process reg_file_reads;

    -- wires and simple muxes
    data_wr  <= reg_rd2_d1;
    pc_n     <= alu_out;
    mem_addr <= alu_out_d1 when (mem_access = '1') else pc;


    u_register_file : register_file
    port map (
        clk         => clk                  ,
        addr_rd1    => instr(25 downto 21)  ,
        addr_rd2    => instr(20 downto 16)  ,
        addr_wr     => instr(20 downto 16)  ,
        data_wr     => mem_data             ,
        wr_enable   => reg_wr               ,

        data_rd1    => reg_rd1              ,
        data_rd2    => reg_rd2
    );

    u_ALU : ALU
    port map (
        a       => src_a    ,
        b       => src_b    ,
        funct   => alu_ctrl ,

        output  => alu_out  ,
        zero    => zero
    );

    -- combinational decision logic to determine the ALU operands
    src_b_mux : process(src_b_ctrl, src_b_ctrl) begin
        -- src_a 2 mux between reg file and pc
        src_a <= reg_rd1_d1 when (src_a_ctrl = '1') else pc;

        -- src_b 4 mux between 4 and sign immediate
        case src_b_ctrl is
            when "00" => src_b <= (others => '0');
            when "01" => src_b <= 32d"4";
            when "10" => src_b <= sign_imm;
            when "11" => src_b <= (others => '0');
        end case;
    end process src_b_mux;

end behave;