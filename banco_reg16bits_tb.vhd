library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg16bits_tb is
end entity;

architecture a_banco_reg16bits_tb of banco_reg16bits_tb is
    component banco_reg16bits is 
        port( 
            sel_reg_1 : in unsigned(2 downto 0); 
            sel_reg_2 : in unsigned(2 downto 0); 
            sel_reg_write: in unsigned(2 downto 0); 
            wr_en : in std_logic;
            clk : in std_logic;
            reset : in std_logic;
            data_in : in signed(15 downto 0); 
            data_out_reg_1 : out signed(15 downto 0); 
            data_out_reg_2 : out signed(15 downto 0)
        );
    end component;

    -- 100 ns é o período que escolhi para o clock
    constant period_time : time := 100 ns;
    signal clk : std_logic;
    signal finished, reset, wr_en : std_logic := '0';
    signal sel_reg_write, sel_reg_1, sel_reg_2 : unsigned(2 downto 0) := "000";
    signal data_out_reg_1, data_out_reg_2, data_in : signed(15 downto 0) := "0000000000000000";
begin
    uut: banco_reg16bits port map(  
        clk => clk,
        reset => reset,
        wr_en => wr_en,
        sel_reg_write => sel_reg_write,
        sel_reg_1 => sel_reg_1,
        sel_reg_2 => sel_reg_2,
        data_out_reg_1 => data_out_reg_1,
        data_out_reg_2 => data_out_reg_2,
        data_in => data_in
    );

    reset_global: process
    begin
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

    process -- sinais dos casos de teste
    begin
        wait for period_time * 2;

        -- Tenta escrever no registrador 0 e fazer leitura do mesmo - é esperado que nada seja escrito
        wr_en <= '1';
        data_in <= "1010101000101010";
        sel_reg_write <= "000";
        sel_reg_1 <= "000";
        sel_reg_2 <= "000";
        wait for period_time;

        -- Tenta escrever no registrador 1 sem write enable - é esperado que nada seja escrito
        data_in <= "0101010100101010";
        wr_en <= '0';
        sel_reg_write <= "001";
        sel_reg_1 <= "001";
        sel_reg_2 <= "001";
        wait for period_time;

        -- Tenta escrever no registrador 2 sem write enable - é esperado que nada seja escrito
        data_in <= "1010111100101010";
        wr_en <= '0';
        sel_reg_write <= "010";
        sel_reg_1 <= "010";
        sel_reg_2 <= "010";
        wait for period_time;

        -- Tenta escrever no registrador 3 sem write enable - é esperado que nada seja escrito
        data_in <= "1001111001000000";
        wr_en <= '0';
        sel_reg_write <= "011";
        sel_reg_1 <= "011";
        sel_reg_2 <= "011";
        wait for period_time;

        -- Tenta escrever no registrador 4 sem write enable - é esperado que nada seja escrito
        data_in <= "1001111001011110";
        wr_en <= '0';
        sel_reg_write <= "100";
        sel_reg_1 <= "100";
        sel_reg_2 <= "100";
        wait for period_time;

        -- Tenta escrever no registrador 5 sem write enable - é esperado que nada seja escrito
        data_in <= "1000000001011110";
        wr_en <= '0';
        sel_reg_write <= "101";
        sel_reg_1 <= "101";
        sel_reg_2 <= "101";
        wait for period_time;        

        -- Tenta escrever no registrador 6 sem write enable - é esperado que nada seja escrito
        data_in <= "1001111001010010";
        wr_en <= '0';
        sel_reg_write <= "110";
        sel_reg_1 <= "110";
        sel_reg_2 <= "110";
        wait for period_time;

        -- Tenta escrever no registrador 7 sem write enable - é esperado que nada seja escrito
        data_in <= "1110100101110010";
        wr_en <= '0';
        sel_reg_write <= "111";
        sel_reg_1 <= "111";
        sel_reg_2 <= "111";
        wait for period_time;       
        
        -- Escreve em todos registradores e faz a leitura
        wr_en <= '1';


        -- Escreve no registrador 1 e mostra o conteúdo dele e do registrador 3
        data_in <= "1111000011110101";
        sel_reg_write <= "001";
        sel_reg_1 <= "001";
        sel_reg_2 <= "011";
        wait for period_time;

        -- Escreve no registrador 1 e mostra o conteúdo dele e do registrador 7
        data_in <= "1010001111110101";
        sel_reg_write <= "001";
        sel_reg_1 <= "111";
        sel_reg_2 <= "001";
        wait for period_time;

        -- Escreve no registrador 2 e mostra o conteúdo dele e do registrador 4
        data_in <= "0011000011110000";
        sel_reg_write <= "010";
        sel_reg_1 <= "010";
        sel_reg_2 <= "100";
        wait for period_time;

        -- Escreve no registrador 2 e mostra o conteúdo dele e do registrador 6
        data_in <= "1010001000010101";
        sel_reg_write <= "010";
        sel_reg_1 <= "110";
        sel_reg_2 <= "010";
        wait for period_time;

        -- Escreve no registrador 3 e mostra o conteúdo dele e do registrador 1
        data_in <= "1001000011110101";
        sel_reg_write <= "011";
        sel_reg_1 <= "011";
        sel_reg_2 <= "001";
        wait for period_time;

        -- Escreve no registrador 3 e mostra o conteúdo dele e do registrador 5
        data_in <= "1010001110101000";
        sel_reg_write <= "011";
        sel_reg_1 <= "101";
        sel_reg_2 <= "011";
        wait for period_time;

        -- Escreve no registrador 4 e mostra o conteúdo dele e do registrador 3
        data_in <= "0011000011111110";
        sel_reg_write <= "100";
        sel_reg_1 <= "100";
        sel_reg_2 <= "011";
        wait for period_time;

        -- Escreve no registrador 4 e mostra o conteúdo dele e do registrador 2
        data_in <= "1010001100010101";
        sel_reg_write <= "100";
        sel_reg_1 <= "010";
        sel_reg_2 <= "100";
        wait for period_time;

        -- Escreve no registrador 5 e mostra o conteúdo dele e do registrador 3
        data_in <= "1001001111110101";
        sel_reg_write <= "101";
        sel_reg_1 <= "101";
        sel_reg_2 <= "011";
        wait for period_time;

        -- Escreve no registrador 5 e mostra o conteúdo dele e do registrador 4
        data_in <= "1010010100001010";
        sel_reg_write <= "101";
        sel_reg_1 <= "100";
        sel_reg_2 <= "101";
        wait for period_time;

        -- Escreve no registrador 6 e mostra o conteúdo dele e do registrador 2
        data_in <= "1001000001110101";
        sel_reg_write <= "110";
        sel_reg_1 <= "110";
        sel_reg_2 <= "010";
        wait for period_time;

        -- Escreve no registrador 6 e mostra o conteúdo dele e do registrador 1
        data_in <= "0010001000111100";
        sel_reg_write <= "110";
        sel_reg_1 <= "001";
        sel_reg_2 <= "110";
        wait for period_time;

        -- Escreve no registrador 7 e mostra o conteúdo dele e do registrador 5
        data_in <= "0011010100010100";
        sel_reg_write <= "111";
        sel_reg_1 <= "111";
        sel_reg_2 <= "101";
        wait for period_time;

        -- Escreve no registrador 7 e mostra o conteúdo dele e do registrador 6
        data_in <= "1000111101010100";
        sel_reg_write <= "111";
        sel_reg_1 <= "110";
        sel_reg_2 <= "111";

        -- Tenta escrever no registrador 0 e mostra o conteúdo dele e do registrador 7
        data_in <= "1010001110101000";
        sel_reg_write <= "000";
        sel_reg_1 <= "000";
        sel_reg_2 <= "111";
        wait for period_time;

        wait;
    end process;
end architecture a_banco_reg16bits_tb;