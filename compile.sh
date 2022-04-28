#!/bin/bash

ghdl -a reg16bits.vhd
ghdl -a reg16bits_tb.vhd

ghdl -r reg16bits_tb --wave=result.ghw

gtkwave result.ghw
