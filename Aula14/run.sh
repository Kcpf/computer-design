ghdl -a --std=08 -frelaxed src/vhdl/*.vhd
ghdl -a --std=08 -frelaxed test/vhdl/*.vhd
ghdl -e --std=08 -frelaxed TopLevel_tb
ghdl -r --std=08 -frelaxed TopLevel_tb --stop-time=100ns --wave=wave.ghw
