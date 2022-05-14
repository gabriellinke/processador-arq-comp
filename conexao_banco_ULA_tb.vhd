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

            ULA_out_data : out signed(15 downto 0);
            ULA_out_greater_equal_or_signal : out std_logic;
            ULA_out_zero : out std_logic
        );
    end component;
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk_in, wr_en_in, reset_in, ULA_src_in, ULA_out_greater_equal_or_signal, ULA_out_zero: std_logic := '0';
    signal opselect_in : unsigned(1 downto 0) := "00";
    signal sel_reg_1_in, sel_reg_2_in, sel_reg_write_in : unsigned(2 downto 0) := "000";
    signal in_data, ULA_out_data : signed(15 downto 0) := "0000000000000000";
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
        ULA_out_data=>ULA_out_data,
        ULA_out_greater_equal_or_signal=>ULA_out_greater_equal_or_signal,
        ULA_out_zero=>ULA_out_zero
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
        wait for 3 us; 
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

        -- Tenta gravar no registrador 0 a soma do valor armazenado no registrador 0 com o valor de in_data
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "000";
        in_data <= "1111111111111111";
        ULA_src_in <= '1';
        opselect_in <= "00";
        wait for period_time;

        -- Grava no registrador 1 a soma do valor armazenado no registrador 0 com o valor de in_data
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "001";
        in_data <= "0000000000000001";
        ULA_src_in <= '1';
        opselect_in <= "00";
        wait for period_time;

        -- Grava no registrador 2 a soma do valor armazenado no registrador 0 com o valor de in_data
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "010";
        in_data <= "0000000000000010";
        ULA_src_in <= '1';
        opselect_in <= "00";
        wait for period_time;

        -- Grava no registrador 3 a soma do valor armazenado no registrador 0 com o valor de in_data
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "011";
        in_data <= "0000000000000011";
        ULA_src_in <= '1';
        opselect_in <= "00";
        wait for period_time;
        
        -- Grava no registrador 4 a soma do valor armazenado no registrador 0 com o valor de in_data
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "100";
        in_data <= "0000000000000100";
        ULA_src_in <= '1';
        opselect_in <= "00";
        wait for period_time;

        -- Grava no registrador 5 a soma do valor armazenado no registrador 0 com o valor de in_data
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "101";
        in_data <= "0000000000000101";
        ULA_src_in <= '1';
        opselect_in <= "00";
        wait for period_time;

        -- Grava no registrador 6 a soma do valor armazenado no registrador 0 com o valor de in_data
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "110";
        in_data <= "0000000000000110";
        ULA_src_in <= '1';
        opselect_in <= "00";
        wait for period_time;

        -- Grava no registrador 7 a soma do valor armazenado no registrador 0 com o valor de in_data
        wr_en_in <= '1';
        sel_reg_1_in <= "000";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "111";
        in_data <= "0000000000000111";
        ULA_src_in <= '1';
        opselect_in <= "00";
        wait for period_time;

        -- Grava no resgistrador 1 a diferença entre os valores armazenados no registrador 7 e no registrador 2
        wr_en_in <= '1';
        sel_reg_1_in <= "111";
        sel_reg_2_in <= "010";
        sel_reg_write_in <= "001";
        in_data <= "0000000000000000";
        ULA_src_in <= '0';
        opselect_in <= "01";
        wait for period_time;

        -- Grava no resgistrador 1 a diferença entre os valores armazenados no registrador 6 e no registrador 3
        wr_en_in <= '1';
        sel_reg_1_in <= "110";
        sel_reg_2_in <= "011";
        sel_reg_write_in <= "001";
        in_data <= "0000000000000000";
        ULA_src_in <= '0';
        opselect_in <= "01";
        wait for period_time;

        -- Grava no resgistrador 1 a diferença entre os valores armazenados no registrador 5 e no registrador 4
        wr_en_in <= '1';
        sel_reg_1_in <= "101";
        sel_reg_2_in <= "100";
        sel_reg_write_in <= "001";
        in_data <= "0000000000000000";
        ULA_src_in <= '0';
        opselect_in <= "01";
        wait for period_time;

        -- Grava no resgistrador 1 a diferença entre os valores armazenados no registrador 4 e no registrador 5
        wr_en_in <= '1';
        sel_reg_1_in <= "100";
        sel_reg_2_in <= "101";
        sel_reg_write_in <= "001";
        in_data <= "0000000000000000";
        ULA_src_in <= '0';
        opselect_in <= "01";
        wait for period_time;

        -- Grava no resgistrador 1 a diferença entre os valores armazenados no registrador 3 e no registrador 6
        wr_en_in <= '1';
        sel_reg_1_in <= "011";
        sel_reg_2_in <= "110";
        sel_reg_write_in <= "001";
        in_data <= "0000000000000000";
        ULA_src_in <= '0';
        opselect_in <= "01";
        wait for period_time;

        -- Grava no resgistrador 1 a diferença entre os valores armazenados no registrador 2 e no registrador 7
        wr_en_in <= '1';
        sel_reg_1_in <= "010";
        sel_reg_2_in <= "111";
        sel_reg_write_in <= "001";
        in_data <= "0000000000000000";
        ULA_src_in <= '0';
        opselect_in <= "01";
        wait for period_time;

        -- retorna se o valor armazenado no registrador 1 é maior ou igual ao valor de in_data
        wr_en_in <= '0';
        sel_reg_1_in <= "001";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "000";
        in_data <= "0000000000000011";
        ULA_src_in <= '1';
        opselect_in <= "10";
        wait for period_time;

        -- retorna se o valor armazenado no registrador 2 é maior ou igual ao valor de in_data
        wr_en_in <= '0';
        sel_reg_1_in <= "011";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "000";
        in_data <= "0000000000000011";
        ULA_src_in <= '1';
        opselect_in <= "10";
        wait for period_time;

        -- retorna se o valor armazenado no registrador 7 é maior ou igual ao valor de in_data
        wr_en_in <= '0';
        sel_reg_1_in <= "111";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "000";
        in_data <= "0000000000000011";
        ULA_src_in <= '1';
        opselect_in <= "10";
        wait for period_time;

        -- Grava no registrador 1 o resultado da operação "and" entre os valores armazenados nos registradores 1 e 5
        wr_en_in <= '1';
        sel_reg_1_in <= "001";
        sel_reg_2_in <= "101";
        sel_reg_write_in <= "001";
        in_data <= "0000000000000000";
        ULA_src_in <= '0';
        opselect_in <= "11";
        wait for period_time;
        
        -- Grava no registrador 0 o resultado da operação "and" entre os valores armazenados nos registradores 1 e 1
        wr_en_in <= '1';
        sel_reg_1_in <= "001";
        sel_reg_2_in <= "001";
        sel_reg_write_in <= "001";
        in_data <= "0000000000000000";
        ULA_src_in <= '0';
        opselect_in <= "11";
        wait for period_time;  
        
        -- Grava no registrador 1 o resultado da operação "and" entre o valor armazenado no registrador 1 e o valor de in_data
        wr_en_in <= '1';
        sel_reg_1_in <= "001";
        sel_reg_2_in <= "000";
        sel_reg_write_in <= "001";
        in_data <= "1110000000000000";
        ULA_src_in <= '1';
        opselect_in <= "11";
        wait for period_time;        
    
        wait;
    end process;
end architecture;