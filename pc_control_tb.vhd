library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pc_control_tb is
end entity pc_control_tb;

architecture a_pc_control_tb of pc_control_tb is
    component pc_control
        port(
            clk :in std_logic;
            wr_en: in std_logic;
            reset: in std_logic;
            data_out: out signed(11 downto 0)
        );    
    end component pc_control;

    -- 100 ns é o período que escolhi para o clock
    constant period_time : time := 100 ns;
    signal finished, reset : std_logic := '0';
    signal clk : std_logic;
    signal wr_en : std_logic := '1';
    signal data_in, data_out : signed(11 downto 0) := "000000000000";

begin
    controller: pc_control port map (clk => clk, wr_en => wr_en, reset => reset, data_out => data_out);

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

    reset_global: process
    begin
        reset <= '1';
        wait for period_time * 2;
        reset <= '0';
        wait;
    end process;

    process -- sinais dos casos de teste
    begin
        wait for period_time *5 ;
        wait;
    end process;

end architecture a_pc_control_tb;