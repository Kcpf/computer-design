ghdl -a --std=08 src/*.vhd
ghdl -a --std=08 test/*.vhd
ghdl -e --std=08 Atv2_tb
ghdl -r --std=08 Atv2_tb --stop-time=100ns --wave=wave2.ghw
