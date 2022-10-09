ghdl -a --std=08 src/*.vhd
ghdl -a --std=08 test/*.vhd
ghdl -e --std=08 Atv1_tb
ghdl -r --std=08 Atv1_tb --stop-time=1000ns --wave=wave2.ghw
