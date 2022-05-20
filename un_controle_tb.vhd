library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle_tb is
end entity;

architecture a_un_controle_tb of un_controle_tb is
    component un_controle is
        port(
        clk : in std_logic;
        reset : in std_logic;
        instr_in : in unsigned(16 downto 0);

        rom_read : out std_logic;
        pc_write : out std_logic;
        jump_en : out std_logic

        );
    end component;

    constant period_time : time := 100 ns;
    signal finished, clk, reset, rom_read, pc_write, jump_en : std_logic := '0';
    signal instr_in : unsigned(16 downto 0) := "00000000000000000";

begin
    uut: un_controle port map(clk => clk, reset => reset, instr_in => instr_in, rom_read => rom_read, pc_write => pc_write, jump_en => jump_en);

    reset_global: process
    begin
        reset <= '1';
        wait for period_time * 2; -- espera 2 clocks, pra garantir
        reset <= '0';
        wait;
    end process reset_global;

    sim_time_proc: process
    begin
    wait for 500 ns; 
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
        wait for period_time*2;

        -- jump fetch/decode
        instr_in <= "11111000000000000";
        wait for period_time;

        -- no jump fetch/decode
        instr_in <= "00000000000000000";
        wait;
    end process;
end architecture a_un_controle_tb;