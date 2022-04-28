library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg16bits is
    port( 
        sel_reg_1 : in unsigned(2 downto 0); -- seleção de quais registradores serão lidos
        sel_reg_2 : in unsigned(2 downto 0); -- seleção de quais registradores serão lidos
        sel_reg_write: in unsigned(2 downto 0); -- seleção de qual registrador será escrito
        wr_en : in std_logic;
        clk : in std_logic;
        reset : in std_logic;
        data_in : in unsigned(15 downto 0); -- valor a ser escrito
        data_out_reg_1 : out unsigned(15 downto 0); -- barramentos com os dados dos registradores lidos
        data_out_reg_2 : out unsigned(15 downto 0) -- barramentos com os dados dos registradores lidos
    );
end entity;

architecture a_banco_reg16bits of banco_reg16bits is
    component reg16bits is 
        port( 
            clk : in std_logic;
            reset : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7 : std_logic :='0';
    signal data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7 : unsigned(15 downto 0);
    constant wr_en0 : std_logic:='0';

begin

    reg0: reg16bit port map(clk=>clk, reset=>reset, wr_en=>wr_en0, data_in=>data_in, data_out=>data_out0);
    reg1: reg16bit port map(clk=>clk, reset=>reset, wr_en=>wr_en1, data_in=>data_in, data_out=>data_out1);
    reg2: reg16bit port map(clk=>clk, reset=>reset, wr_en=>wr_en2, data_in=>data_in, data_out=>data_out2);
    reg3: reg16bit port map(clk=>clk, reset=>reset, wr_en=>wr_en3, data_in=>data_in, data_out=>data_out3);
    reg4: reg16bit port map(clk=>clk, reset=>reset, wr_en=>wr_en4, data_in=>data_in, data_out=>data_out4);
    reg5: reg16bit port map(clk=>clk, reset=>reset, wr_en=>wr_en5, data_in=>data_in, data_out=>data_out5);
    reg6: reg16bit port map(clk=>clk, reset=>reset, wr_en=>wr_en6, data_in=>data_in, data_out=>data_out6);
    reg7: reg16bit port map(clk=>clk, reset=>reset, wr_en=>wr_en7, data_in=>data_in, data_out=>data_out7);

    wr_en1<='1' when sel_reg_write = "001" else '0';
    wr_en2<='1' when sel_reg_write = "010" else '0';
    wr_en3<='1' when sel_reg_write = "011" else '0';
    wr_en4<='1' when sel_reg_write = "100" else '0';
    wr_en5<='1' when sel_reg_write = "101" else '0';
    wr_en6<='1' when sel_reg_write = "110" else '0';
    wr_en7<='1' when sel_reg_write = "111" else '0';

    data_out_reg_1 <=   data_out0 when sel_reg_1 ="000" else
                        data_out1 when sel_reg_1 ="001" else
                        data_out2 when sel_reg_1 ="010" else
                        data_out3 when sel_reg_1 ="011" else
                        data_out4 when sel_reg_1 ="100" else
                        data_out5 when sel_reg_1 ="101" else
                        data_out6 when sel_reg_1 ="110" else
                        data_out7 when sel_reg_1 ="111" else
                        "0000000000000000"

    data_out_reg_2 <=   data_out0 when sel_reg_2 ="000" else
                        data_out1 when sel_reg_2 ="001" else
                        data_out2 when sel_reg_2 ="010" else
                        data_out3 when sel_reg_2 ="011" else
                        data_out4 when sel_reg_2 ="100" else
                        data_out5 when sel_reg_2 ="101" else
                        data_out6 when sel_reg_2 ="110" else
                        data_out7 when sel_reg_2 ="111" else
                        "0000000000000000"

end architecture a_banco_reg16bits;