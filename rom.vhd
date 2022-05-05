library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( 
        clk : in std_logic;
        address : in unsigned(11 downto 0); -- memória de programa:  1Kbyte = 1024bytes = 4096 bits = 2^12
        data : out unsigned(16 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 4095) of unsigned(16 downto 0); -- memória ROM de 1k e com dados de 17 bits (conforme requisitos)
    constant content_rom : mem := (
        -- caso endereco => conteudo
        0 => "00000000000000001",
        1 => "00000000000000010",
        2 => "00000000000000011",
        3 => "00000000000000100",
        4 => "00000000000000101",
        5 => "00000000000000110",
        6 => "00000000000000111",
        7 => "00000000000001000",
        8 => "00000000000001001",
        9 => "00000000000001010",
        10 => "00000000000001011",
        -- abaixo: casos omissos => (zero em todos os bits)
        others => (others=>'0')
    );
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            data <= content_rom(to_integer(address));
        end if;
    end process;
end architecture;