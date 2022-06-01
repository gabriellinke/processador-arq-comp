library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_control is 
    port(
        clk :in std_logic;
        wr_en : in std_logic;
        reset : in std_logic;
        select_jump_type : in std_logic; -- Quando 0 - Direct Jump. Quando 1 - Relative Jump
        jump_en : in std_logic;
        data_in : in unsigned(11 downto 0);
        data_out : out unsigned(11 downto 0)
    );    
end entity pc_control;

architecture a_pc_control of pc_control is
    component reg12bits is
        port(
            clk : in std_logic;
            reset : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(11 downto 0);
            data_out : out unsigned(11 downto 0)
        );
    end component;

    signal pc_in, pc_out, direct_jump_address, relative_jump_address: unsigned(11 downto 0) := "000000000000";
begin

    PC: reg12bits port map(  
        clk => clk,
        reset => reset,
        wr_en => wr_en,
        data_in => pc_in,
        data_out => pc_out
    );

    pc_in <= "000000000000" when reset='1' else
             direct_jump_address when jump_en = '1' and select_jump_type = '0' else 
             relative_jump_address when jump_en = '1' and select_jump_type = '1' else
             pc_out + 1;

    data_out <= pc_out;
    direct_jump_address <= data_in;
    relative_jump_address <= pc_out + 1 + data_in;

end architecture a_pc_control;