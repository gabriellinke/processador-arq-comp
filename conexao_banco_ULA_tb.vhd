library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conexao_banco_ULA_tb is
end entity;

architecture a_conexao_banco_ULA_tb of conexao_banco_ULA_tb is 
    component conexao_banco_ULA is
        port(
            sel_reg_1_in : in unsigned(2 downto 0); 
            sel_reg_2_in : in unsigned(2 downto 0); 
            sel_reg_write_in : in unsigned(2 downto 0); 
            in_data : in signed(15 downto 0);
            clk_in : in std_logic;
            wr_en_in : in std_logic;
            reset_in : in std_logic;
            ULA_src_in : in std_logic;
            opselect_in : in unsigned(1 downto 0);

            out_data : out signed(15 downto 0);
            out_greater_equal_or_signal : out std_logic;
            out_zero : out std_logic
        );
    end component;
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk_in, wr_en_in, reset_in, ULA_src_in, out_greater_equal_or_signal, out_zero: std_logic;
    signal opselect_in : unsigned(1 downto 0);
    signal sel_reg_1_in, sel_reg_2_in, sel_reg_write_in : unsigned(2 downto 0);
    signal in_data, out_data : signed(15 downto 0);
begin
    uut : conexao_banco_ula port map(
        sel_reg_1_in=>sel_reg_1_in,
        sel_reg_2_in=>sel_reg_2_in,
        sel_reg_write_in=>sel_reg_write_in,
        in_data=>in_data,
        clk_in=>clk_in,
        wr_en_in=>wr_en_in,
        reset_in=>reset_in,
        ULA_src_in=>ULA_src_in,
        opselect_in=>opselect_in,
        out_data=>out_data,
        out_greater_equal_or_signal=>out_greater_equal_or_signal,
        out_zero=>out_zero
    );

    reset_global: process
    begin
        reset_in <= '1';
        wait for period_time * 2; -- espera 2 clocks, pra garantir
        reset_in <= '0';
        wait;
    end process reset_global;

    sim_time_proc: process
    begin
        wait for 10 us; 
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
        clk_in <= '0';
        wait for period_time/2;
        clk_in <= '1';
        wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process -- sinais dos casos de teste
    begin
        wait for period_time * 2;

        -- 
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "111";
        sel_reg_write_in <= "010";
        in_data <= "0000100000011010";
        ULA_src_in <= '1';
        opselect_in <= "00";
        wait for period_time;

        -- 
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "111";
        sel_reg_write_in <= "010";
        in_data <= "0000100011111010";
        ULA_src_in <= '0';
        opselect_in <= "00";
        wait for period_time;

        --
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "111";
        sel_reg_write_in <= "010";
        in_data <= "0000101110111010";
        ULA_src_in <= '1';
        opselect_in <= "00";
        wait for period_time;

        --
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "111";
        sel_reg_write_in <= "010";
        in_data <= "0000100000011010";
        ULA_src_in <= '0';
        opselect_in <= "00";
        wait for period_time;

        wait;
    end process;
end architecture;