library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados_tb is
end entity;

architecture a_maquina_estados_tb of maquina_estados_tb is
    component maquina_estados is
        port(
            clk : in std_logic;
            reset : in std_logic;
            estado : out std_logic
        );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk, reset, estado : std_logic;
begin
    uut: maquina_estados port map(
        clk => clk,
        reset => reset,
        estado => estado
    );

    reset_global: process
    begin
        reset <= '1';
        wait for period_time * 2; -- espera 2 clocks, pra garantir
        reset <= '0';
        wait for period_time * 14; 
        reset <= '1';
        wait for period_time * 2; -- espera 2 clocks, pra garantir
        reset <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us; 
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
        clk <= '0';
        wait for period_time/2;
        clk <= '1';
        wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;
end architecture a_maquina_estados_tb;
