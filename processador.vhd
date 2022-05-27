library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        reset, clk: in std_logic;
        estado_out: out unsigned(1 downto 0);
        pc_out: out unsigned(11 downto 0);
        instr_out: out unsigned(16 downto 0);
        reg1_out, reg2_out: out unsigned(15 downto 0);
        ULA_result_out: out unsigned(15 downto 0);
        ULA_carry_out, ULA_zero_out: out std_logic
    );
end entity;

architecture a_processador of processador is
    component rom is
        port(
            clk: in std_logic;
            address: in unsigned(11 downto 0);
            data: out unsigned(16 downto 0) := "00000000000000000"
        );
    end component;

    component un_controle is
        port(
            clk : in std_logic;
            reset : in std_logic;
            instr_in : in unsigned(16 downto 0);
            estado_out : out unsigned(1 downto 0);
            ULA_opselect : out unsigned(1 downto 0);
            sel_reg_1_in, sel_reg_2_in, sel_reg_write_in : out unsigned(2 downto 0);
            rom_read, pc_write, jump_en, exec, ULA_src : out std_logic
        );
    end component;

    component conexao_banco_ULA is
        port(
            sel_reg_1_in : in unsigned(2 downto 0); 
            sel_reg_2_in : in unsigned(2 downto 0); 
            sel_reg_write_in : in unsigned(2 downto 0); 
            in_data : in unsigned(15 downto 0);
            clk_in : in std_logic;
            wr_en_in : in std_logic;
            reset_in : in std_logic;
            ULA_src_in : in std_logic;
            opselect_in : in unsigned(1 downto 0);
    
            reg_1_out, reg_2_out : out unsigned(15 downto 0);
            ULA_out_data : out unsigned(15 downto 0);
            ULA_out_carry : out std_logic;
            ULA_out_zero : out std_logic
        );
    end component;

    component pc_control is
        port(
            clk :in std_logic;
            wr_en : in std_logic;
            reset : in std_logic;
            jump_en : in std_logic;
            data_in : in unsigned(11 downto 0);
            data_out : out unsigned(11 downto 0)
        ); 
    end component;

    component reg17bits is
        port(
            clk : in std_logic;
            reset : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(16 downto 0);
            data_out : out unsigned(16 downto 0)
        );
    end component;

    signal reg1_out_s, reg2_out_s : unsigned(15 downto 0) := "0000000000000000";
    signal rom_read : std_logic := '1';
    signal pc_write, jump_en, exec : std_logic := '0';
    signal pc_out_s : unsigned(11 downto 0) := "000000000000";
    signal rom_out : unsigned(16 downto 0) := "00000000000000000";
    signal instr_reg_out : unsigned(16 downto 0) := "00000000000000000";
    signal ULA_opselect_s, estado: unsigned(1 downto 0) := "00";
    signal ULA_out_data, extended_signal : unsigned(15 downto 0) := "0000000000000000";
    signal ULA_src, ULA_out_carry, ULA_out_zero: std_logic := '0';
    signal sel_reg_1_in_s, sel_reg_2_in_s, sel_reg_write_in_s : unsigned(2 downto 0) := "000";

begin
    MEM_ROM: rom port map(
        clk => clk,
        address => pc_out_s,
        data => rom_out
    );

    PC: pc_control port map(
        clk => clk,
        wr_en => pc_write,
        reset => reset,
        jump_en => jump_en,
        data_in => rom_out(11 downto 0),
        data_out => pc_out_s
    );

    UC: un_controle port map(
        clk => clk,
        reset => reset,
        instr_in => instr_reg_out,
        estado_out => estado,
        rom_read => rom_read,
        pc_write => pc_write,
        jump_en => jump_en,
        exec => exec,
        ULA_src => ULA_src,
        ULA_opselect => ULA_opselect_s,
        sel_reg_1_in => sel_reg_1_in_s, 
        sel_reg_2_in => sel_reg_2_in_s, 
        sel_reg_write_in => sel_reg_write_in_s
    );

    INSTR_REG: reg17bits port map(
        clk => clk,
        reset => reset,
        wr_en => rom_read,
        data_in => rom_out,
        data_out => instr_reg_out
    );

    BANCO_ULA: conexao_banco_ULA port map(
        sel_reg_1_in => sel_reg_1_in_s,
        sel_reg_2_in => sel_reg_2_in_s, 
        sel_reg_write_in => sel_reg_write_in_s, 
        in_data => extended_signal,
        clk_in => clk,
        wr_en_in => exec,
        reset_in => reset,
        ULA_src_in => ULA_src,
        opselect_in => ULA_opselect_s, 
        reg_1_out => reg1_out_s,
        reg_2_out => reg2_out_s,
        ULA_out_data => ULA_out_data,
        ULA_out_carry => ULA_out_carry,
        ULA_out_zero => ULA_out_zero
    );
    
    estado_out <= estado;
    pc_out <= pc_out_s;
    instr_out <= instr_reg_out;
    reg1_out <= reg1_out_s;
    reg2_out <= reg2_out_s;
    ULA_result_out <= ULA_out_data;
    ULA_carry_out <= ULA_out_carry;
    ULA_zero_out <= ULA_out_zero;
    extended_signal <= instr_reg_out(8) & instr_reg_out(8) & instr_reg_out(8) & instr_reg_out(8) & instr_reg_out(8) & instr_reg_out(8) & instr_reg_out(8) & instr_reg_out(8 downto 0);
end architecture;