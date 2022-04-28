#!/bin/bash

ghdl -a reg16bits.vhd
ghdl -a reg16bits_tb.vhd

ghdl -a banco_reg16bits.vhd
ghdl -a banco_reg16bits_tb.vhd

ghdl -a mux.vhd
ghdl -a conexao_banco_ULA.vhd

ghdl -r banco_reg16bits_tb --wave=result.ghw

gtkwave result.ghw
