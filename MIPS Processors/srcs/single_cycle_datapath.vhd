library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity single_cycle_datapath is
port (
    clk         : in std_logic;
    reset       : in std_logic;
    instr       : in std_logic_vector(31 downto 0);
    mem_data    : in std_logic_vector(31 downto 0);

    alu_ctrl    : in std_logic_vector( 2 downto 0);
    pc_src      : in std_logic;
    mem_to_reg  : in std_logic;
    alu_src     : in std_logic;
    reg_dst     : in std_logic;
    reg_wr      : in std_logic;
    jump        : in std_logic;

    pc          : out std_logic_vector(31 downto 0);
    alu_out     : out std_logic_vector(31 downto 0);
    data_wr     : out std_logic_vector(31 downto 0);
    zero        : out std_logic
);
end single_cycle_datapath;

architecture behave of single_cycle_datapath is

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
        data_rd2    : out std_logic_vector(31 downto 0)
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

    signal sign_imm     : std_logic_vector(31 downto 0);
    signal shifted_imm  : std_logic_vector(31 downto 0);
    signal src_a        : std_logic_vector(31 downto 0);
    signal reg_rd       : std_logic_vector(31 downto 0); -- feeds into a multiplex for src_b
    signal src_b        : std_logic_vector(31 downto 0);
    signal result       : std_logic_vector(31 downto 0);  -- ultimate value written to reg file
    signal reg_wr_addr  : std_logic_vector( 4 downto 0);  -- write address for register file
    signal pc_n         : std_logic_vector(31 downto 0);  -- next value of the program counter
    signal jump_addr    : std_logic_vector(31 downto 0); -- Jump target address

begin

    -- update the program counter at the end of each clock cycle
    pr_pc_update : process (clk)
    begin
        -- resets to specified instruction address value (currently 0x00000000)
        if (reset = '1') then
            pc <= (others => '0');

        elsif (rising_edge(clk)) then
            -- jump type command
            if (jump = '1') then
                pc <= jump_addr;
            
            -- branch type command
            elsif (pc_src = '1') then
                pc <= pc_n + shifted_imm;

            -- common case
            else 
                pc <= pc_n;
            end if;
        end if;
    end process;

    -- pc computations
    pc_n        <= pc + 4;
    shifted_imm <= std_logic_vector(shift_left(signed(sign_imm), 2));
    jump_addr   <= (pc(31 downto 28), instr(25 downto 0), "00");

    -- sign extention of immediate field of the instruction
    sign_imm <= (31 downto 16 => instr(15), 15 downto 0 => instr(15 downto 0));

    -- multiplexes memory parameters so that they can also be used for R-type instructions
    src_b  <= sign_imm when (alu_src = '1')    else data_wr;
    result <= mem_data when (mem_to_reg = '1') else alu_out;

    -- selects correct destination address between R-type and I-type instructions
    reg_wr_addr <= instr(15 downto 11) when (reg_dst = '1') else instr(20 downto 16);

    u_register_file : register_file
    port map (
        clk         => clk                  ,
        addr_rd1    => instr(25 downto 21)  ,
        addr_rd2    => instr(20 downto 16)  ,
        addr_wr     => reg_wr_addr          ,
        data_wr     => result               ,
        wr_enable   => reg_wr               ,

        data_rd1    => src_a                ,
        data_rd2    => data_wr
    );

    u_ALU : ALU
    port map (
        a       => src_a    ,
        b       => src_b    ,
        funct   => alu_ctrl ,

        output  => alu_out  ,
        zero    => zero
    );



end behave;