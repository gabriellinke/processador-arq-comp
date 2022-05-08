library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_controle_tb is
end entity;

architecture a_top_level_controle_tb of top_level_controle_tb is
    component top_level_controle is
        port(
            clk, wr_en, reset : in std_logic;
            data_out : out signed(16 downto 0)
        );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk_s, reset_S : std_logic;
    signal data_out_s : signed(16 downto 0);
begin
    uut: top_level_controle port map(
        clk=>clk_s,
        wr_en=>'1',
        reset=>reset_s,
        data_out=>data_out_s
    );

    sim_time_proc: process
    begin
        wait for 10 us; 
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
        clk_s <= '0';
        wait for period_time/2;
        clk_s <= '1';
        wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    reset_global: process
    begin
        reset_s <= '1';
        wait for period_time * 2; -- espera 2 clocks, pra garantir
        reset_s <= '0';
        wait;
    end process;

end architecture;