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
    type mem is array (0 to 4095) of unsigned(16 downto 0); -- memória ROM de 1k e com dados de 17 bits (conforme requisitos) - acredito está errado
    constant content_rom : mem := (
        -- caso endereco => conteudo
        0 => B"01000_011_000000101",    -- LDI R3 000000101
        1 => B"01000_100_000001000",    -- LDI R4 000001000
        2 => B"00000_011_100_100000",   -- ADD R3 R4
        3 => B"00000_101_011_100001",   -- MOV R5 R3
        4 => B"00010_101_000000001",    -- SUBI R1 000000001
        5 => B"11111_000000010100",     -- JMP para 20
        20 => B"00000_011_101_100001",  -- MOV R3 R5
        21 => B"11111_000000000010",    -- JMP para 2

        -- PROGRAMA PARA TESTAR AS INSTRUCOES
        -- 0 => B"01000_001_000000100", -- LDI 001 000000100
        -- 1 => B"01000_001_010000000", -- LDI 001 010000000
        -- 2 => B"01000_010_000000001", -- LDI 010 000000001
        -- 3 => B"00010_001_000000001", --SUBI 001 000000001
        -- 4 => B"00010_010_000000100", --SUBI 010 000000100
        -- 5 => B"00000_001_000_100000", -- ADD 001 000
        -- 6 => B"01000_111_000001100", -- LDI 111 000001100
        -- 7 => B"01000_110_010010001", -- LDI 110 010010001
        -- 8 => B"00000_111_110_100000", -- ADD 111 110
        -- 9 => B"00000_111_110_100010", -- SUB 111 110
        -- 10 => B"00000_111_001_100001", -- MOV 111 001
        -- 11 => B"00000_110_010_100001", -- MOV 110 001
        -- 12 => B"00000_111_000_100000", -- ADD 111 000
        -- 13 => B"00000_110_000_100000", -- ADD 110 000
        -- 14 => B"11111_000000000000", -- jump para 0

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