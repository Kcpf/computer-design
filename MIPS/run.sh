ghdl -a --std=08 src/vhdl/utils/*.vhd
ghdl -a --std=08 src/vhdl/Decoder/*.vhd
ghdl -a --std=08 src/vhdl/CPU/ALU/*.vhd
ghdl -a --std=08 src/vhdl/CPU/*.vhd
ghdl -a --std=08 src/vhdl/*.vhd
ghdl -a --std=08 test/vhdl/*.vhd
ghdl -e --std=08 TopLevel_tb
ghdl -r --std=08 TopLevel_tb --stop-time=100ns --wave=wave.ghw
