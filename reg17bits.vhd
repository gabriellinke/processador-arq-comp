library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg17bits is
    port( 
        clk : in std_logic;
        reset : in std_logic;
        wr_en : in std_logic;
        data_in : in unsigned(16 downto 0);
        data_out : out unsigned(16 downto 0)
    );
end entity;

architecture a_reg17bits of reg17bits is
    signal registro: unsigned(16 downto 0);
begin
    process(clk,reset,wr_en) -- acionado se houver mudança em clk, rst ou wr_en
    begin
        if reset='1' then
            registro <= "00000000000000000";
        elsif wr_en='1' then
            if rising_edge(clk) then
                registro <= data_in;
            end if;
        end if;
    end process;

    data_out <= registro; -- conexao direta, fora do processo
end architecture;