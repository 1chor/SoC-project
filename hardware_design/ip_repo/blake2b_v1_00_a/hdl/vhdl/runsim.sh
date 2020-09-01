ghdl -s --std=08 blake2.vhd blake2b_wrapper.vhd user_logic.vhd tb.vhd
ghdl -a --std=08 blake2.vhd blake2b_wrapper.vhd user_logic.vhd tb.vhd
ghdl -e --std=08 tb

echo "START SIMULATION"
ghdl -r --std=08 tb --wave=wave.ghw
