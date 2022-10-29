ghdl -a --std=08 -frelaxed src/*.vhd
ghdl -a --std=08 -frelaxed test/*.vhd
ghdl -e --std=08 -frelaxed TopLevel_tb
ghdl -r --std=08 -frelaxed TopLevel_tb --stop-time=100ns --wave=wave.ghw
