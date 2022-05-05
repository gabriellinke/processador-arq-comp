library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
    port(
        clk : in std_logic;
        reset : in std_logic;
        instr_in : in unsigned(16 downto 0);

        rom_read : out std_logic;
        pc_write : out std_logic;
        jump_en : out std_logic

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

    signal estado_s: std_logic;
    signal opcode: unsigned(3 downto 0);
begin

    maq: maquina_estados port map(clk=>clk, reset=>reset, estado=>estado_s);
    
    opcode <= instr_in(16 downto 13);

    rom_read <= '1' when estado_s = '0' else
                '0';

    pc_write <= '1' when estado_s = '1' else
                '0';

    jump_en <=  '1' when opcode="1111" else
                '0';   
    
end architecture a_un_controle;