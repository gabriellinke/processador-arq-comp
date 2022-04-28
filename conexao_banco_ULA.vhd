library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conexao_banco_ULA is
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

end entity;

architecture a_conexao_banco_ULA of conexao_banco_ULA is
    component mux is
        port(
            in_data_1 : in signed(15 downto 0);
            in_data_2 : in signed(15 downto 0);
            input_sel : in std_logic;
            out_data : out signed(15 downto 0)
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
    component banco_reg16bits is
        port(
            sel_reg_1 : in unsigned(2 downto 0); -- seleção de quais registradores serão lidos
            sel_reg_2 : in unsigned(2 downto 0); -- seleção de quais registradores serão lidos
            sel_reg_write: in unsigned(2 downto 0); -- seleção de qual registrador será escrito
            wr_en : in std_logic;
            clk : in std_logic;
            reset : in std_logic;
            data_in : in signed(15 downto 0); -- valor a ser escrito
            data_out_reg_1 : out signed(15 downto 0); -- barramentos com os dados dos registradores lidos
            data_out_reg_2 : out signed(15 downto 0)-- barramentos com os dados dos registradores lidos
        );
    end component;
    signal out_data, banco_out_1, banco_out_2, mux_out : signed(15 downto 0);
    signal out_greater_equal_or_signal, out_zero : std_logic;
begin
    banco_reg16bits_component : banco_reg16bits port map(
        sel_reg_1=>sel_reg_1_in,
        sel_reg_2=>sel_reg_2_in,
        sel_reg_write=>sel_reg_write_in,
        wr_en=>wr_en_in,
        clk=>clk_in,
        reset=>reset_in,
        data_in=> out_data,
        data_out_reg_1=>banco_out_1,
        data_out_reg_2=>banco_out_2
    );
    mux_component : mux port map(
        in_data_1=>banco_out_2,
        in_data_2=>in_data,
        input_sel=>ULA_src_in,
        out_data=>mux_out
    );
    ULA_component : ULA port map(
        input1=>banco_out_1,
        input2=>mux_out,
        opselect=>opselect_in,
        output1=>out_data,
        output_greater_equal_or_signal=>out_greater_equal_or_signal,
        output_zero=>out_zero
    );
    
    ULA_out_data <= out_data;
    ULA_out_greater_equal_or_signal <= out_greater_equal_or_signal;
    ULA_out_zero <= out_zero;
end architecture;