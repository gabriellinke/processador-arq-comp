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

        -- PROGRAMA DE VALIDAÇÃO
        -- loop para preencher quantidade especificada de números
        0 => B"01000_110_000100000",    -- LDI R6,32    --   O registrador R6 armazena o maior número da lista, e será utilizado para as 
		1 => B"01000_001_000000000",    -- LDI R1,0     --   comparações dos loops. Este trecho itera sobre os registradores R1 e R7 para
		2 => B"01000_111_000000000",    -- LDI R7,0     --   preencher a lista de 1 até o valor armazenado em R6 (no caso desta validação,
		3 => B"00010_001_111111111",    -- SUBI R1,-1   --   32). R7 armazena o endereço da memória a ser escrita, e R1 armazena o valor que será escrito.
		4 => B"00010_111_111111111",    -- SUBI R7,-1   --   Pseudo-código:
		5 => B"01101_001_000000000",    -- ST R1        --   R6 <- 32
		6 => B"00000_001_110_100110",   -- CP R7,R6     --   R1, R7 <- 0
		7 => B"10111_111111111011",     -- BRLO -5      --   enquanto R7 < R6
                                                        --       R1 <- R1 + 1
                                                        --       R7 <- R7 + 1
                                                        --       RAM[R7] <- R1
                                                        --   fim

        -- loop para remover os não primos
        8 => B"01000_010_000000001",    -- LDI R2,1     --   O registrador R2 manterá armazenado o endereço a ser lido da memória a cada iteração do
		9 => B"01000_111_000000000",    -- LDI R7,0     --   loop, e o R4 será carregado com o valor lido. Seguindo o crivo de eratóstenes, itera-se 
		10 => B"00010_010_111111111",   -- SUBI R2,-1   --   sobre a lista de valores, e caso seja lido 0 em algum endereço, significa que o número é
		11 => B"00000_111_010_100000",  -- ADD R7,R2    --   não primo e já foi removido.
		12 => B"01100_100_000000000",   -- LD R4        --   Pseudo-código:
        13 => B"00000_100_000_100110",  -- CP R4,R0     --   R2 <- 1
        14 => B"10100_000000000100",    -- BREQ 4       --   enquanto R2 < R6:
		15 => B"00000_111_100_100000",  -- ADD R7,R4    --       R2 <- R2 + 1
		16 => B"01101_000_000000000",   -- ST R0        --       R7 <- R2 
		17 => B"00000_111_110_100110",  -- CP R7,R6     --       R4 <- RAM[R7]
		18 => B"10111_111111111100",    -- BRLO -4      --       se R4 = 0:
		19 => B"00000_010_110_100110",  -- CP R2,R6     --       fim         
		20 => B"10111_111111110100",    -- BRLO -12     --       senão:
                                                        --           enquanto R7 < R6:
                                                        --               R7 <- R7 + R4         
                                                        --               RAM[R7] <- 0         
                                                        --           fim
                                                        --       fim
                                                        --   fim 
  
        -- loop para ler a memória do 2 ao 32  
        21 => B"01000_111_000000001",   -- LDI R7,1     --   R3 é utilizado para vizualizar o valor armazenado nos endereços de 2 a 32
		22 => B"00010_111_111111111",   -- SUBI R7,-1   --   Pseudo-código:
		23 => B"01100_011_000000000",   -- LD R3        --   R7 <- 1
		24 => B"00000_111_110_100110",  -- CP R7,R6     --   enquanto R7 < R6      
		25 => B"10111_111111111100",    -- BRLO -4      --       R7 <- R7 + 1
                                                        --       R3 <- RAM[R7]
                                                        --   fim

        -- FIM DO PROGRAMA DE VALIDAÇÃO 
        
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