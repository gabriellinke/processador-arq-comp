library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bits_tb is
end entity;

architecture a_reg16bits_tb of reg16bits_tb is
    component reg16bits is 
        port( 
            clk : in std_logic;
            reset : in std_logic;
            wr_en : in std_logic;
            data_in : in signed(15 downto 0);
            data_out : out signed(15 downto 0)
        );
    end component;

    -- 100 ns é o período que escolhi para o clock
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk, reset, wr_en : std_logic;
    signal data_in, data_out : signed(15 downto 0);
begin
    uut: reg16bits port map(  
        clk => clk,
        reset => reset,
        wr_en => wr_en,
        data_in => data_in,
        data_out => data_out
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
        wait for 2 us; 
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

    process -- sinais dos casos de teste (p.ex.)
    begin
        wait for period_time * 2;
        wr_en <= '0';
        data_in <= "1111111111111111";
        wait for period_time;
        wr_en <= '1';
        data_in <= "1000110111111111";
        wait for period_time * 5;
        data_in <= "1000111100101010";
        wait for period_time * 2;
        wr_en <= '0';
        data_in <= "1111111111111111";
        wait for period_time;
        wr_en <= '1';
        wait for period_time;
        wr_en <= '1';
        data_in <= "1111000011110000";
        wait for period_time;
        wr_en <= '0';
        wait;
    end process;
end architecture a_reg16bits_tb;