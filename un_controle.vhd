library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
    port(
        clk : in std_logic;
        reset : in std_logic;
        instr_in : in unsigned(16 downto 0);
        estado_out : out unsigned(1 downto 0);
        rom_read, pc_write, jump_en, exec, ULA_src : out std_logic
    );
end entity;

architecture a_un_controle of un_controle is 
    component maquina_estados is
        port(
            clk : in std_logic;
            reset : in std_logic;
            estado : out unsigned(1 downto 0)
        );
    end component;

    signal estado_s: unsigned(1 downto 0) := "00";
    signal opcode: unsigned(4 downto 0) := "00000";
    
begin
    MAQ: maquina_estados port map(
        clk=>clk, 
        reset=>reset, 
        estado=>estado_s
    );

    opcode <= instr_in(16 downto 12);

    rom_read <= '1' when estado_s = "00" else '0';

    pc_write <= '1' when estado_s = "01" else '0';

    exec <= '1' when estado_s = "10" else '0';

    ULA_src <= '1' when opcode = "01000" or opcode = "00010" else '0';

    jump_en <= '1' when opcode= "11111" else '0';

    estado_out <= estado_s;
    
end architecture a_un_controle;