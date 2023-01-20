test:
	verilator -Wall --cc --exe --build --trace --trace-depth 10 tests/testbench.cpp src/RGB2YCbCr.v