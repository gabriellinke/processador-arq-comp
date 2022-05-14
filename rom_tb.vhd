library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom_tb is
end entity rom_tb;

architecture a_rom_tb of rom_tb is
    component rom
        port( 
            clk : in std_logic;
            address : in unsigned(11 downto 0);
            data : out unsigned(16 downto 0)
        );
    end component;

    -- 100 ns é o período que escolhi para o clock
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk : std_logic;
    signal address : unsigned(11 downto 0) := "000000000000";
    signal data : unsigned(16 downto 0) := "00000000000000000";

begin
    uut: rom port map (clk => clk, address => address, data => data);

    sim_time_proc: process
    begin
        wait for 3 us; 
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
        while finished /= '1' loop
            wait for period_time;
        address <= address + "000000000001";
        end loop;
        wait;
    end process;

end architecture a_rom_tb;