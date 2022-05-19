library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        reset, clk: in std_logic;
        estado_out: out unsigned(1 downto 0);
        pc_out: out unsigned(11 downto 0);
        instr_out: out unsigned(16 downto 0);
        reg1_out, reg2_out: out signed(15 downto 0);
        ULA_result_out: out signed(15 downto 0);
        ULA_geq_sig_out, ULA_zero_out: out std_logic
    );
end entity;

architecture a_processador of processador is
    component rom is
        port(
            clk: in std_logic;
            address: in signed(11 downto 0);
            data: out signed(16 downto 0) := "00000000000000000"
        );
    end component;

    component un_controle is
        port(
            clk : in std_logic;
            reset : in std_logic;
            instr_in : in signed(16 downto 0);
            rom_read, pc_write, jump_en : out std_logic
        );
    end component;

    component conexao_banco_ULA is
        port(
            sel_reg_1_in : in unsigned(2 downto 0); 
            sel_reg_2_in : in unsigned(2 downto 0); 
            sel_reg_write_in : in unsigned(2 downto 0); 
            in_data : in signed(15 downto 0);
            clk_in : in std_logic;
            wr_en_in : in std_logic;
            reset_in : in std_logic;
            ULA_src_in : in std_logic;
            opselect_in : in unsigned(1 downto 0);
    
            ULA_out_data : out signed(15 downto 0);
            ULA_out_greater_equal_or_signal : out std_logic;
            ULA_out_zero : out std_logic
        );
    end component;

    component pc_control is
        port(
            clk :in std_logic;
            wr_en : in std_logic;
            reset : in std_logic;
            jump_en : in std_logic;
            data_in : in signed(11 downto 0);
            data_out : out signed(11 downto 0)
        ); 
    end component;

    component reg17bits is
        port(
            clk : in std_logic;
            reset : in std_logic;
            wr_en : in std_logic;
            data_in : in signed(16 downto 0);
            data_out : out signed(16 downto 0)
        );
    end component;

    signal rom_read : std_logic := '1';
    signal pc_write : std_logic := '0';
    signal jump_en : std_logic := '0';
    signal pc_out : signed(11 downto 0) := "000000000000";
    signal rom_out : signed(16 downto 0) := "00000000000000000";
    signal instr_reg_out : signed(16 downto 0) := "00000000000000000";

    signal ULA_out_data : signed(15 downto 0) := "0000000000000000";
    signal ULA_out_greater_equal_or_signal, ULA_out_zero: std_logic := '0';
begin
    MEM_ROM: rom port map(
        clk => clk,
        address => pc_out,
        data => rom_out
    );

    PC: pc_control port map(
        clk => clk,
        wr_en => pc_write,
        reset => reset,
        jump_en => jump_en,
        data_in => rom_out(11 downto 0),
        data_out => pc_out
    );

    UC: un_controle port map(
        clk => clk,
        reset => reset,
        instr_in => rom_out,
        rom_read => rom_read,
        pc_write => pc_write,
        jump_en => jump_en
    );

    INSTR_REG: reg17bits port map(
        clk => clk,
        reset => reset,
        wr_en => rom_read, -- Não tenho certeza, mas acredito que seja quando o estado é 00, que é o momento do rom_read = 1
        data_in => rom_out,
        data_out => instr_reg_out
    );

    BANCO_ULA: conexao_banco_ULA port map(
        sel_reg_1_in : in unsigned(2 downto 0); -- vem da instrução
        sel_reg_2_in : in unsigned(2 downto 0); -- vem da instrução
        sel_reg_write_in : in unsigned(2 downto 0); -- vem da instrução
        in_data : in signed(15 downto 0); -- vem da instrução
        clk_in => clk,
        wr_en_in : in std_logic;
        reset_in : in std_logic;
        ULA_src_in : in std_logic;
        opselect_in : in unsigned(1 downto 0); -- vem da instrução

        ULA_out_data => ULA_out_data,
        ULA_out_greater_equal_or_signal => ULA_out_greater_equal_or_signal,
        ULA_out_zero => ULA_out_zero
    );
    
begin
end architecture;