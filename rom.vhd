library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( 
        clk : in std_logic;
        address : in unsigned(11 downto 0); -- memória de programa:  1Kbyte = 1024bytes = 4096 bits = 2^12
        data : out unsigned(16 downto 0) := "00000000000000000"
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 4095) of unsigned(16 downto 0); -- memória ROM de 1k e com dados de 17 bits (conforme requisitos)
    constant content_rom : mem := (
        -- caso endereco => conteudo
        0 => B"01000_001_000000100", -- LDI 001 000000010
        1 => B"01000_010_000000001", -- LDI 010 000000001
        2 => B"00010_001_000000001", --SUBI 001 000000001
        3 => B"00010_100_000101001", --SUBI 001 000000001
        4 => B"00000_001_100_100000", -- ADD 001 000

        -- 0 => "11111000000000111", -- jump para 7
        -- 1 => "00001010110110000",
        -- 2 => "00000000000011111",
        -- 3 => "11111000000000101", -- jump para 5
        -- 4 => "11111000000001000", -- jump para 8
        -- 5 => "00000000001111110",
        -- 6 => "11111000000000100", -- jump para 4
        -- 7 => "11111000000000001", -- jump para 1
        -- 8 => "00000001100001001",
        -- 9 => "11100000000001010",
        -- 10 => "00011000000001011",
        -- 11 => B"00010_001_000000001", --SUBI 001 000000001
        -- 12 => B"00010_001_000000100", --SUBI 001 000000100
        -- 13 => B"00010_010_000000010", --SUBI 010 000000010
        -- 14 => B"00000_001_010_100000", -- ADD 001 010
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