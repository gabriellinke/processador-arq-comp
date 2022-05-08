#!/bin/bash

ghdl -a reg16bits.vhd
ghdl -a reg16bits_tb.vhd


ghdl -a reg12bits.vhd
ghdl -a reg12bits_tb.vhd

ghdl -a banco_reg16bits.vhd
ghdl -a banco_reg16bits_tb.vhd

ghdl -a ULA.vhd
ghdl -a ULA_tb.vhd

ghdl -a mux.vhd
ghdl -a mux_tb.vhd

ghdl -a conexao_banco_ULA.vhd
ghdl -a conexao_banco_ULA_tb.vhd

ghdl -a rom.vhd
ghdl -a rom_tb.vhd

ghdl -a maquina_estados.vhd
ghdl -a maquina_estados_tb.vhd

ghdl -a pc_control.vhd
ghdl -a pc_control_tb.vhd

ghdl -a un_controle.vhd
ghdl -a un_controle_tb.vhd

ghdl -a top_level_controle.vhd
ghdl -a top_level_controle_tb.vhd

ghdl -r top_level_controle_tb --wave=result.ghw

gtkwave result.ghw
