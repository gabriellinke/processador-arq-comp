library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
    port(
        in_data_1 : in signed(15 downto 0);
        in_data_2 : in signed(15 downto 0);
        input_sel : in std_logic;
        out_data : out signed(15 downto 0)
    );
end entity;

architecture a_mux of mux is
begin
    out_data <= in_data_1 when input_sel = '0' else in_data_2;
end architecture;
                