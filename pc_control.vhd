library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_control is 
    port(
        clk :in std_logic;
        wr_en: in std_logic;
        data_in: in signed(15 downto 0);
        data_out: out signed(15 downto 0)
    );    
end entity pc_control;


architecture a_pc_control of pc_control is
    component reg16bits
    port(
        clk : in std_logic;
            reset : in std_logic;
            wr_en : in std_logic;
            data_in : in signed(15 downto 0);
            data_out : out signed(15 downto 0)
            );
    end component;
    signal resultado_incremento: signed(15 downto 0) := data_in;
begin
    PC: reg16bits port map(  
        clk => clk,
        reset => '0', -- acho que não precisa ter reset no pc
        wr_en => wr_en,
        data_in => resultado_incremento,
        data_out => data_out
    );

    resultado_incremento <=   resultado_incremento + 1 when wr_en = '1' and rising_edge(clk) else
                   resultado_incremento;

end architecture a_pc_control;