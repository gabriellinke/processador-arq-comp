    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    entity mux_tb is 
    end;

    architecture a_mux_tb of mux_tb is
        component mux
        port(
            in_data_1 : in unsigned(15 downto 0);
            in_data_2 : in unsigned(15 downto 0);
            sel : in std_logic;
            out_data : out unsigned(15 downto 0)
        );
        end component;

        signal sel: std_logic;
        signal in_data_1, in_data_2, out_data: unsigned(15 downto 0);

        begin
			uut: mux port map(
				in_data_1 => in_data_1,
				in_data_2 => in_data_2,
				sel => sel,
				out_data => out_data
			);
            process
            begin
                in_data_1 <= "1010000001010000";
                in_data_2 <= "0000010100001010";
                sel <= '0';
                wait for 50 ns;
                sel <= '1';
                wait;
            end process;
    end architecture a_mux_tb;