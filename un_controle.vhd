library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
    port(
        clk : in std_logic;
        reset : in std_logic;
        instr_in : in signed(16 downto 0);

        rom_read : out std_logic
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

    component rom is
        port( 
            clk : in std_logic;
            address : in unsigned(11 downto 0);
            data : out unsigned(16 downto 0)
        );
    end component;

    component pc_control is
        port( 
            clk :in std_logic;
            wr_en: in std_logic;
            reset: in std_logic;
            data_out: out signed(11 downto 0)
        );
    end component;

    signal jump_en, estado_s, pc_write: std_logic:='0';
    signal opcode: unsigned(4 downto 0) := "00000";
    signal pc_out: signed(11 downto 0) := "000000000000";
    signal rom_out: unsigned(16 downto 0) := "00000000000000000";
begin

    -- process (reset, clk, estado_s)
    -- begin
    --     if rising_edge(clk) then
    --        if jump_en='1' then
    --            jump in the pc_control
    --        end if;
    -- end process;

    MAQ: maquina_estados port map(
        clk=>clk, 
        reset=>reset, 
        estado=>estado_s
    );

    MEM_ROM: rom port map (
        clk => clk, 
        address => pc_out,
        data => rom_out
    );

    PC: pc_control port map (
        clk => clk, 
        wr_en => '1', 
        reset => reset, 
        data_out => pc_out
    );

    opcode <= instr_in(16 downto 12);

    rom_read <= '1' when estado_s = '0' else
                '0';

    pc_write <= '1' when estado_s = '1' else
                '0';

    jump_en <=  '1' when opcode="11111" else
                '0';
    
end architecture a_un_controle;