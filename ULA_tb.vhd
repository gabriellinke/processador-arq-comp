library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end entity;

architecture a_ULA_tb of ULA_tb is
    component ULA
        port(   input1, input2 : in signed(15 downto 0);
                opselect : in unsigned(1 downto 0);
                output1 : out signed(15 downto 0);
                output_greater_equal_or_signal : out std_logic;
                output_zero : out std_logic
            );
    end component;
    
    signal input1, input2, output1 : signed(15 downto 0) := "0000000000000000";
    signal opselect : unsigned(1 downto 0) := "00";
    signal output_greater_equal_or_signal, output_zero : std_logic := '0';
    ----------------------
    ------ opselect ------
    -- 00 sum
    -- 01 subtract
    -- 10 greater or equal
    -- 11 and
    ----------------------
begin
    uut: ULA port map(  
        input1 => input1,
        input2 => input2,
        opselect => opselect,
        output1 => output1,
        output_greater_equal_or_signal => output_greater_equal_or_signal,
        output_zero => output_zero
    );
    process
    begin
    -------------------------------------------------
    ------------------ Sum tests --------------------
        -- Sum with 0 with 0
        input1 <= "0000000000000000";
        input2 <= "0000000000000000";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with 0
        input1 <= "0000000000000000";
        input2 <= "0000000001110001";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with 1
        input1 <= "0000000000000001";
        input2 <= "0000000001110001";
        opselect <= "00";
        wait for 50 ns;
        -- Sum 1 with 1
        input1 <= "0000000000000001";
        input2 <= "0000000000000001";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with 0
        input1 <= "0001110001110001";
        input2 <= "0000000000000000";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with 1
        input1 <= "0001110001110010";
        input2 <= "0000000000000001";
        opselect <= "00";
        wait for 50 ns;
        -- Sum -1 with -1
        input1 <= "1111111111111111";
        input2 <= "1111111111111111";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with -1
        input1 <= "0001111101110010";
        input2 <= "1111111111111111";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with -1
        input1 <= "1110010011001001";
        input2 <= "1111111111111111";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with both positives
        input1 <= "0000000000000100";
        input2 <= "0000000101110011";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with both positives
        input1 <= "0100000000000000";
        input2 <= "0000011101011101";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with both positives
        input1 <= "0000100010001000";
        input2 <= "0000000101110011";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with positive and negative
        input1 <= "1111111111111010";
        input2 <= "0011011010010000";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with positive and negative
        input1 <= "0011011010010100";
        input2 <= "1111000000000000";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with positive and negative
        input1 <= "1110111011000011";
        input2 <= "0011011010000000";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with both negatives
        input1 <= "1111111111111111";
        input2 <= "1111111111111111";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with both negatives
        input1 <= "1111111111111011";
        input2 <= "1111111111111111";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with both negatives
        input1 <= "1110111011000011";
        input2 <= "1111111111111101";
        opselect <= "00";
        wait for 50 ns;
        -- Sum with both negatives
        input1 <= "1111111110101010";
        input2 <= "1100111111111101";
        opselect <= "00";
        wait for 50 ns;
    -------------------------------------------------
    --------------- Subtraction tests ---------------
        -- Subtraction with 0
        input1 <= "0001111111111111";
        input2 <= "0000000000000000";
        opselect <= "01";
        wait for 50 ns;
        -- Subtraction with 1
        input1 <= "0001111111111111";
        input2 <= "0000000000000001";
        opselect <= "01";
        wait for 50 ns;
        -- Subtraction with 10
        input1 <= "0001111111111111";
        input2 <= "0000000000001010";
        opselect <= "01";
        wait for 50 ns;
        -- Subtraction with -1
        input1 <= "0001111111111111";
        input2 <= "1111111111111111";
        opselect <= "01";
        wait for 50 ns;
        -- Subtraction with -5
        input1 <= "0001111111111111";
        input2 <= "1111111111111011";
        opselect <= "01";
        wait for 50 ns;
        -- Both positive, input1 > input2
        input1 <= "0001111111111111";
        input2 <= "0000000000011110";
        opselect <= "01";
        wait for 50 ns;
        -- Both positive, input1 < input2
        input1 <= "0000000000011110";
        input2 <= "0001111111111111";
        opselect <= "01";
        wait for 50 ns;
        -- Both negative, input1 > input2
        input1 <= "1111110001100100";
        input2 <= "1101110100111001";
        opselect <= "01";
        wait for 50 ns;
        -- Both negative, input1 < input2
        input1 <= "1101110100111001";
        input2 <= "1111110001100100";
        opselect <= "01";
        wait for 50 ns;
        -- input1 positive, input2 negative
        input1 <= "0001111111111111";
        input2 <= "1111110001100100";
        opselect <= "01";
        wait for 50 ns;
        -- input1 negative, input2 positive
        input1 <= "1001010001100100";
        input2 <= "0000000000011110";
        opselect <= "01";
        wait for 50 ns;
        -- input1 = input2
        input1 <= "0001110111001001";
        input2 <= "0001110111001001";
        opselect <= "01";
        wait for 50 ns;
    -------------------------------------------------
    ------------ Greater or equal tests -------------
        -- input1 > input2
        input1 <= "0000011000100010";
        input2 <= "0000000011001100";
        opselect <= "10";
        wait for 50 ns;
        -- input1 < input2
        input1 <= "0000000011001100";
        input2 <= "0000011000100010";
        opselect <= "10";
        wait for 50 ns;
        -- input1 = input2
        input1 <= "0000011000100010";
        input2 <= "0000011000100010";
        opselect <= "10";
        wait for 50 ns;
        -- input1 > input2 (negative)
        input1 <= "1111100111001111";
        input2 <= "1110011000100010";
        opselect <= "10";
        wait for 50 ns;
    -------------------------------------------------
    ------------ And tests --------------------------
        -- input2 and 0
        input1 <= "0000000000000000";
        input2 <= "0000110011001100";
        opselect <= "11";
        wait for 50 ns;
        -- input2 and 1
        input1 <= "1111111111111111";
        input2 <= "0000110011001100";
        opselect <= "11";
        wait for 50 ns;
        -- Test 0 and 0, 1 and 1, 0 and 1, 1 and 0
        input1 <= "0000111100001011";
        input2 <= "0000111101100100";
        opselect <= "11";
        wait for 50 ns;
        -- Test 0 and 0, 1 and 1, 0 and 1, 1 and 0
        input1 <= "1000011110110111";
        input2 <= "1000011111010000";
        opselect <= "11";
    -------------------------------------------------
        wait;
    end process;
end architecture;