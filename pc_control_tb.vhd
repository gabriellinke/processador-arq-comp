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
            data_in: in signed(15 downto 0);
            data_out: out signed(15 downto 0)
        );    
    end component pc_control;

    -- 100 ns é o período que escolhi para o clock
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk : std_logic;
    signal data_in : signed(15 downto 0) := "0000000000000000";
    signal data_out : signed(15 downto 0);

begin
    uut: pc_control port map (clk => clk, wr_en => '1', data_in => data_in, data_out => data_out);

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

    process -- sinais dos casos de teste
    begin
        data_in <="0000000000000000";
        wait for 50 ns;
        wait;
    end process;

end architecture a_pc_control_tb;