library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity pipleined_datapath is
port (
    clk         : in std_logic;
    reset       : in std_logic;
    instr       : in std_logic_vector(31 downto 0);
    mem_data    : in std_logic_vector(31 downto 0);

    alu_ctrl    : in std_logic_vector( 2 downto 0);
    branch      : in std_logic;
    mem_to_reg  : in std_logic;
    alu_src     : in std_logic;
    reg_dst     : in std_logic;
    reg_wr      : in std_logic;
    --jump        : in std_logic; //TODO: to be added later

    pc          : out std_logic_vector(31 downto 0);
    alu_out     : out std_logic_vector(31 downto 0);
    data_wr     : out std_logic_vector(31 downto 0);
);
end pipleined_datapath;

architecture behave of pipleined_datapath is

    ---------------------------------------------------------------------------
    -- 32 word register file, 2 read ports and 1 write port
    ---------------------------------------------------------------------------
    component register_file_sync is
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
    end component register_file_sync;

    ---------------------------------------------------------------------------
    -- command and ALU decoder set up for the instructions: add, subtract, 
    -- and, or, slt, and not, and or not
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
    -- internal signals/wires

    signal pc_n         : std_logic_vector(31 downto 0); -- next pc
    signal pc_n_D       : std_logic_vector(31 downto 0);
    signal pc_n_E       : std_logic_vector(31 downto 0);
    signal pc_br        : std_logic_vector(31 downto 0); -- branch pc
    signal pc_br_M      : std_logic_vector(31 downto 0);

    signal instr_D      : std_logic_vector(31 downto 0);

    signal r_addr       : std_logic_vector( 4 downto 0); -- r type reg wr addr
    signal r_addr_E     : std_logic_vector( 4 downto 0);
    signal i_addr       : std_logic_vector( 4 downto 0); -- i type reg wr addr
    signal i_addr_E     : std_logic_vector( 4 downto 0);

    signal sign_imm     : std_logic_vector(31 downto 0);
    signal sign_imm_E   : std_logic_vector(31 downto 0);

    -- ************************************************************************
    -- control signals/wires

    signal alu_ctrl_E       : std_logic_vector( 2 downto 0);
    signal mem_to_reg_E     : std_logic;
    signal alu_src_E        : std_logic;
    signal reg_dst_E        : std_logic;
    signal reg_wr_E         : std_logic;
    signal branch_E         : std_logic;

    signal mem_to_reg_M     : std_logic;
    signal reg_wr_M         : std_logic;
    signal branch_M         : std_logic;

    signal mem_to_reg_W     : std_logic;
    signal reg_wr_W         : std_logic;

    signal zero             : std_logic;
    signal zero_M           : std_logic;
    signal pc_src           : std_logic;

begin
    ---------------------------------------------------------------------------------
    -- The pipelined processor is split into 5 stages: fetch, decode, execute and
    -- writeback. Signals propogating between these stages will be denoted with a
    -- _F, _D, _E, _M, or _W if they propogated away from their original stage.
    -- Exeternal memory is accessed during the fetch and memory stages. The register
    -- file is accessed during the decode and writeback stages. The ALU is accessed
    -- during the execute stage.
    ---------------------------------------------------------------------------------

    -- FETCH
    ---------------------------------------------------------------------------------
    pc_n <= pc + 4; 

    -- updates the pc with either next instr or a branch or jump
    pc_update_pr : process (clk) begin
        if (reset = '1') then
            pc <= (others => '0');
        
        elsif(rising_edge(clk)) then
            -- branch
            if (pc_src = '1') then
                pc <= pc_br_M;

            -- regular increment
            else
            pc <= pc_n;
            end if;
        end if;

    end process pc_update_pr;

    fetch_decode_reg : process (clk) begin
        if (rising_edge(clk)) then
            instr_D <= instr;
            pc_n_D  <= pc_n;
        end if;
    end process fetch_decode_reg;

    -- DECODE
    ---------------------------------------------------------------------------------
    sign_imm <= (31 downto 16 => instr_D(15), 15 downto 0 => instr_D(15 downto 0));

    decode_execute_reg : process (clk) begin
        if (rising_edge(clk)) then

            -- control
            alu_ctrl_E       <= alu_ctrl;
            mem_to_reg_E     <= mem_to_reg;
            alu_src_E        <= alu_src;
            reg_dst_E        <= reg_dst;
            reg_wr_E         <= reg_wr;
            branch_E         <= branch;
        end if;
    end process decode_execute_reg;

    -- EXECUTE
    ---------------------------------------------------------------------------------
    execute_memory_reg : process (clk) begin
        if (rising_edge(clk)) then
            
            -- control
            reg_wr_M         <= reg_wr_E;
            mem_to_reg_M     <= mem_to_reg_E;
            branch_M         <= branch_E;
        end if;
    end process execute_memory_reg;

    -- MEMORY
    ---------------------------------------------------------------------------------
    pc_src <= branch_M and zero_M;

    memory_writeback_reg : process (clk) begin
        if (rising_edge(clk)) then
            -- control
            reg_wr_W         <= reg_wr_M;
            mem_to_reg_W     <= mem_to_reg_M;
        end if;
    end process memory_writeback_reg;

    -- WRITEBACK
    ---------------------------------------------------------------------------------

    -- Submodules
    ---------------------------------------------------------------------------------
    u_register_file_sync : register_file_sync
    port map (
        clk         => clk                  ,
        addr_rd1    => instr_D(25 downto 21)  ,
        addr_rd2    => instr_D(20 downto 16)  ,
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