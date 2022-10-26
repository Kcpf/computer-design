ghdl -a --std=08 src/clock/*.vhd
ghdl -a --std=08 src/cpu/*.vhd
ghdl -a --std=08 src/io/*.vhd
ghdl -a --std=08 src/utils/*.vhd
ghdl -a --std=08 src/*.vhd
ghdl -a --std=08 test/*.vhd
ghdl -e --std=08 TopLevel_tb
ghdl -r --std=08 TopLevel_tb --stop-time=100ns --wave=wave2.ghw
