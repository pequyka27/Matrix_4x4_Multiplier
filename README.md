# 4x4 Matrix Multiplier RTL

A very basic Verilog RTL implementation of a 4x4 matrix multiplier supporting signed-magnitude representation.

## Features
- **Matrix Dimensions:** 4x4
- **Input Data:** 8-bit signed-magnitude (`din`)
- **Output Data:** 17-bit signed-magnitude (`dout`)
- **Control FSM:** `IDLE` -> `LOAD` (32 inputs) -> `CALC` (compute product) -> `OUT` (16 serial outputs)

## Port Interface
- `clk`: System clock
- `rst`: Synchronous active-high reset
- `wrt_en`: Write enable for input loading
- `din` [7:0]: Input data (signed-magnitude)
- `dout` [16:0]: Output data (signed-magnitude)

## Directory Structure
- `rtl/`: RTL design files
- `tb/`: Testbench files
- `sim/`: Simulation files and test inputs (`.hex`)
- `docs/`: Specs and design documentation

## Simulation (Icarus Verilog)
Run the following commands from the `sim/` directory:

1. **Compile:**
   ```bash
   iverilog -o sim.vvp -c filelist.f
   ```
2. **Run:**
   ```bash
   vvp sim.vvp +INPUT=input/min.hex
   ```
3. **View Waveforms:**
   ```bash
   gtkwave wave.vcd
   ```
