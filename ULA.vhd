library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(   input1, input2 : in signed(15 downto 0);

            opselect: in unsigned(1 downto 0);

            output1 : out signed(15 downto 0);
            output_greater_equal_or_signal : out std_logic;
            output_zero : out std_logic
    );
end entity;

----------------------
------ opselect ------
-- 00 sum
-- 01 subtract
-- 10 greater or equal
-- 11 and
----------------------
architecture a_ULA of ULA is
begin
    -- 16 bits output
    output1 <= input1+input2 when opselect="00" else
               input1-input2 when opselect="01" else
               input1 and input2 when opselect="11" else
               "0000000000000000";

    -- Output for 'greater or equal' operation or signal in a 'subtraction' operation
    output_greater_equal_or_signal <= '1' when opselect="01" and input1 > input2 else
               '1' when opselect="10" and input1 >= input2 else
               '0';

    -- Output to test if inputs are equal
    output_zero <=  '1' when input1 = input2 else
                    '0';
              
end architecture;