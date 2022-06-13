library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
    port(
        clk : in std_logic;
        reset : in std_logic;
        instr_in : in unsigned(16 downto 0);
        estado_out : out unsigned(1 downto 0);
        ULA_opselect : out unsigned(1 downto 0);
        sel_reg_1_in, sel_reg_2_in, sel_reg_write_in : out unsigned(2 downto 0);
        rom_read, pc_write, jump_en, ram_read, ram_write, select_jump_type, exec, ULA_src : out std_logic;
        ULA_out_carry, ULA_out_zero: in std_logic
    );
end entity;

architecture a_un_controle of un_controle is 
    component maquina_estados is
        port(
            clk : in std_logic;
            reset : in std_logic;
            estado : out unsigned(1 downto 0)
        );
    end component;

    component flip_flop is
        port(
            clk : in std_logic;
            reset : in std_logic;
            wr_en : in std_logic;
            data_in : in std_logic;
            data_out : out std_logic
        );
    end component;

    signal estado_s: unsigned(1 downto 0) := "00";
    signal opcode: unsigned(4 downto 0) := "00000";
    signal func: unsigned(5 downto 0) := "000000";
    signal ff_z_data_in, ff_z_data_out, ff_c_data_in, ff_c_data_out, op_de_ula, ram_read_s: std_logic := '0';
    signal write_enable_ff_z, write_enable_ff_c: std_logic := '1';
    
begin
    MAQ: maquina_estados port map(
        clk=>clk, 
        reset=>reset, 
        estado=>estado_s
    );

    FF_Z: flip_flop port map(
        clk => clk,
        reset => reset,
        wr_en => write_enable_ff_z,
        data_in => ff_z_data_in,
        data_out => ff_z_data_out
    );

    FF_C: flip_flop port map(
        clk => clk,
        reset => reset,
        wr_en => write_enable_ff_c,
        data_in => ff_c_data_in,
        data_out => ff_c_data_out
    );

    opcode <= instr_in(16 downto 12);
    func <= instr_in(5 downto 0);

    rom_read <= '1' when estado_s = "00" else '0';

    pc_write <= '1' when estado_s = "01" else '0';

    exec <= '1' when estado_s = "10" 
                and not (func = "100110" and opcode = "00000") -- CP - não quero que escreva quando fizer CP, quero apenas atualizar o FF_Z e FF_C 
                and opcode /= "00110" -- CPI - não quero que escreva quando fizer CPI, quero apenas atualizar o FF_Z e FF_C 
                else '0'; 

    ram_write <= '1' when opcode = "01101" else '0'; -- ST
    ram_read_s <= '1' when opcode = "01100" else '0'; -- LD
    ram_read <= ram_read_s;

    ULA_src <= '1' when opcode = "01000" -- LDI
                   or   opcode = "00010" --SUBI
                   or   opcode = "00110" --CPI
                   or   opcode = "01100" --LD
                   else '0';

    ULA_opselect <= "00" when opcode = "00000" and func = "100000" else -- ADD
                    "00" when opcode = "00000" and func = "100001" else -- MOV
                    "01" when opcode = "00000" and func = "100010" else -- SUB
                    "01" when opcode = "00000" and func = "100110" else -- CP
                    "01" when opcode = "00110" else -- CPI
                    "00" when opcode = "01000" else -- LDI
                    "01" when opcode = "00010" else -- SUBI
                    "00" when opcode = "01100" else --LD
                    "11";

    sel_reg_1_in <= "000" when opcode = "01000" else -- LDI
                    "000" when opcode = "01100" else -- LD
                    "000" when opcode = "00000" and func = "100001" else -- MOV
                    instr_in(11 downto 9); 

    sel_reg_2_in <= "111" when ram_read_s = '1' else instr_in(8 downto 6); 
    sel_reg_write_in <= instr_in(11 downto 9); 

    jump_en <=  '1' when opcode = "11111" else -- Direct Jump
                '1' when opcode = "10000" else -- Relative Jump
                '1' when opcode = "10100" and ff_z_data_out = '1' else -- BREQ
                '1' when opcode = "10101" and ff_z_data_out = '0' else -- BRNE
                '1' when opcode = "10110" and ff_c_data_out = '0' else -- BRSH
                '1' when opcode = "10111" and ff_c_data_out = '1' else -- BRLO
                '0';
                
    select_jump_type <= '0' when opcode= "11111" else '1'; -- Quando 0 - Direct Jump. Quando 1 - Relative Jump

    estado_out <= estado_s;

    -- Acho que tirando o JMP, todas as outras são operações de ULA.
    op_de_ula <= '0' when opcode="11111" else '1';
    write_enable_ff_z <= '1' when op_de_ula = '1' else '0';
    write_enable_ff_c <= '1' when op_de_ula = '1' else '0';

    ff_z_data_in <= ULA_out_zero;
    ff_c_data_in <= ULA_out_carry;

end architecture a_un_controle;