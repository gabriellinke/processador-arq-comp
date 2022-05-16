library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados is
    port( 
        clk : in std_logic;
        reset : in std_logic;
        estado : out std_logic
    );
end entity;

architecture a_maquina_estados of maquina_estados is
    signal estado_s: std_logic := '0';
begin
    process(clk,reset) -- acionado se houver mudança em clk, rst ou wr_en
    begin
        if reset='1' then
            estado_s <= '0';
        elsif rising_edge(clk) then
            estado_s <= not estado_s;
        end if;
    end process;

    estado <= estado_s; -- conexao direta, fora do processo
end architecture;