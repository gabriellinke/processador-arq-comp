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

    component ULA is
        port(   
            input1, input2 : in signed(15 downto 0);
            opselect: in unsigned(1 downto 0);
            output1 : out signed(15 downto 0);
            output_greater_equal_or_signal : out std_logic;
            output_zero : out std_logic
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
    
begin
end architecture;