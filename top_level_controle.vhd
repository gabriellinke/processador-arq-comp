library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_controle is
    port(
        clk, wr_en, reset : in std_logic;
        data_out : out signed(16 downto 0)
    );
end entity;

architecture a_top_level_controle of top_level_controle is
    component rom is
        port( 
            clk : in std_logic;
            address : in signed(11 downto 0); -- memória de programa:  1Kbyte = 1024bytes = 4096 bits = 2^12
            data : out signed(16 downto 0)
        );
    end component;

    component pc_control is
        port(
            clk : in std_logic;
            wr_en : in std_logic;
            reset : in std_logic;
            jump_en : in std_logic;
            data_in : in signed(11 downto 0);
            data_out : out signed(11 downto 0)
        );   
    end component;

    component un_controle is
        port(
            clk : in std_logic;
            reset : in std_logic;
            instr_in : in signed(16 downto 0);
            rom_read, pc_write, jump_en : out std_logic
        );
    end component;
    
    signal rom_read : std_logic := '1';
    signal pc_write : std_logic := '0';
    signal jump_en : std_logic := '0';
    signal pc_out : signed(11 downto 0) := "000000000000";
    signal rom_out : signed(16 downto 0) := "00000000000000000";
begin
    MEM_ROM: rom port map(
        clk => clk,
        address => pc_out,
        data => rom_out
    );

    PC: pc_control port map(
        clk => clk,
        wr_en => pc_write,
        reset => reset,
        jump_en => jump_en,
        data_in => rom_out(11 downto 0),
        data_out => pc_out
    );

    UC: un_controle port map(
        clk => clk,
        reset => reset,
        instr_in => rom_out,
        rom_read => rom_read,
        pc_write => pc_write,
        jump_en => jump_en
    );

    data_out <= rom_out;
end architecture;