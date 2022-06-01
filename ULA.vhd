library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(   
        input1, input2 : in unsigned(15 downto 0);

        opselect: in unsigned(1 downto 0);

        output1 : out unsigned(15 downto 0);
        output_carry : out std_logic;
        output_zero : out std_logic
    );
end entity;

----------------------
------ opselect ------
-- 00 sum
-- 01 subtract
-- 10 or
-- 11 and
----------------------
architecture a_ULA of ULA is

    signal in_a_17, in_b_17, soma_17: unsigned(16 downto 0);
    signal carry_soma, carry_subtr: std_logic;
begin
    -- 16 bits output
    output1 <= input1+input2 when opselect="00" else
               input1-input2 when opselect="01" else
               input1 or input2 when opselect="10" else
               input1 and input2 when opselect="11" else
               "0000000000000000";

    -- Output to test if inputs are equal
    output_zero <=  '1' when input1 = input2 else
                    '0';

    in_a_17 <= '0' & input1;
    in_b_17 <= '0' & input2;
    soma_17 <= in_a_17+in_b_17;
    carry_soma <= soma_17(16); -- o carry eh o MSB da soma 17 bits

    -- Apenas funciona se não forem usados números negativos
    carry_subtr <= '0' when input2 <= input1 else
                   '1';

    output_carry <= carry_subtr when opselect="01" else
                    carry_soma;
                
              
end architecture;