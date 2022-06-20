library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processador_tb is
end entity processador_tb;

architecture a_processador_tb of processador_tb is
    component processador is
        port
        (
            reset, clk: in std_logic;
            estado_out: out unsigned(1 downto 0);
            pc_out: out unsigned(11 downto 0);
            instr_out: out unsigned(16 downto 0);
            reg1_out, reg2_out: out unsigned(15 downto 0);
            ULA_result_out: out unsigned(15 downto 0);
            ULA_out_carry, ULA_out_zero: out std_logic
        );
    end component;

    constant period_time : time := 100 ns;
    signal ULA_out_carry_s, ULA_out_zero_s, clk, reset, finished : std_logic := '0';
    signal estado_out : unsigned(1 downto 0) := "00";
    signal pc_out : unsigned(11 downto 0) := "000000000000";
    signal instr_out : unsigned(16 downto 0) := "00000000000000000";
    signal reg1_out, reg2_out, ULA_result_out : unsigned(15 downto 0) := "0000000000000000";

begin

    uut: processador port map (
        clk => clk,
        reset => reset,
        estado_out => estado_out,
        pc_out => pc_out,
        instr_out => instr_out,
        reg1_out => reg1_out,
        reg2_out => reg2_out,
        ULA_result_out => ULA_result_out,
        ULA_out_carry => ULA_out_carry_s,
        ULA_out_zero => ULA_out_zero_s
    );

    reset_global: process
    begin
        reset <= '1';
        wait for period_time*2; 
        reset <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 150000 ns;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin 
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin

        wait;
    end process;

end architecture ;