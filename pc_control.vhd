library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_control is 
    port(
        clk :in std_logic;
        wr_en: in std_logic;
        reset: in std_logic;
        data_out: out signed(11 downto 0)
    );    
end entity pc_control;

architecture a_pc_control of pc_control is
    component reg12bits
    port(
        clk : in std_logic;
        reset : in std_logic;
        wr_en : in std_logic;
        data_in : in signed(11 downto 0);
        data_out : out signed(11 downto 0)
    );
    end component;
    signal pc_in, pc_out: signed(11 downto 0) := "000000000000";
begin

    process (reset, clk)
    begin
        if reset='1' then
            pc_in<="000000000000";
        elsif rising_edge(clk) then
            pc_in <= pc_out + 1;
        end if;
    end process;

    PC: reg12bits port map(  
        clk => clk,
        reset => reset,
        wr_en => wr_en,
        data_in => pc_in,
        data_out => pc_out
    );

    data_out <= pc_out;

end architecture a_pc_control;