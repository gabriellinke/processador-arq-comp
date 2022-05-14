library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
    port(
        clk : in std_logic;
        reset : in std_logic;
        instr_in : in signed(16 downto 0);

        rom_read, pc_write, jump_en : out std_logic
    );
end entity;

architecture a_un_controle of un_controle is 
    component maquina_estados is
        port(
            clk : in std_logic;
            reset : in std_logic;
            estado : out std_logic
        );
    end component;

    signal estado_s: std_logic := '0';
    signal opcode: signed(4 downto 0) := "00000";
begin
    MAQ: maquina_estados port map(
        clk=>clk, 
        reset=>reset, 
        estado=>estado_s
    );

    opcode <= instr_in(16 downto 12);

    rom_read <= '1' when estado_s = '0' else
                '0';

    pc_write <= '1' when estado_s = '1' else
                '0';

    jump_en <=  '1' when opcode="11111" else
                '0';
    
end architecture a_un_controle;