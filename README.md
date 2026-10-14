# 32-bit Parameterized Adder/Subtractor RTL

## Overview
A synthesizable, parameterized Verilog RTL design that performs 32-bit unsigned addition and subtraction using a shared arithmetic datapath. Subtraction is implemented using two’s-complement arithmetic.

## Features
- Parameterized datapath width (`WIDTH`, default: 32 bits)
- Addition and subtraction using a single adder
- Conditional bitwise inversion of operand B
- Carry-in control for two’s-complement subtraction
- Combinational RTL design
- Self-checking testbench with functional test cases
- Simulation and verification using Verilator

## Architecture

The design uses the following equation:

**Addition (`sub = 0`)**

`result = A + B`

**Subtraction (`sub = 1`)**

`result = A + (~B) + 1 = A - B`

The operand B is conditionally inverted using:

```verilog
assign B_mod = B ^ {WIDTH{sub}};
```

When `sub = 0`, B remains unchanged. When `sub = 1`, every bit of B is inverted. The `sub` signal also acts as the carry-in to complete two’s-complement subtraction.

The arithmetic operation is implemented using:

```verilog
assign {carry_out, result} =
       {1'b0, A} + {1'b0, B_mod} + carry_in;
```

The result is WIDTH bits wide, while `carry_out` provides the carry from the extended unsigned addition.

## Module Interface

| Signal | Direction | Description |
|---|---|---|
| `A` | Input | First WIDTH-bit operand |
| `B` | Input | Second WIDTH-bit operand |
| `sub` | Input | 0 = addition, 1 = subtraction |
| `result` | Output | WIDTH-bit arithmetic result |
| `carry_out` | Output | Unsigned carry-out |
| `WIDTH` | Parameter | Datapath width; default is 32 |

## Repository Structure

```text
verilog-32bit-adder-subtractor/
+-- add_subtracter.v
+-- tb_add_subtracter.v
+-- README.md
```

## Verification

The testbench checks the following cases:

- Addition: 10 + 5 = 15
- Subtraction: 10 - 5 = 5
- Negative subtraction result: 5 - 10 = -5 (represented in 32-bit two’s complement)
- Unsigned overflow: `0xFFFFFFFF + 1 = 0`
- Zero subtraction: 0 - 0 = 0
- Signed-boundary bit pattern: `0x7FFFFFFF + 1 = 0x80000000`

The testbench compares the DUT output against expected values and reports failures when mismatches occur.

**Verification status:** The functional testbench compiled and passed using Verilator.

## Running the Simulation

Install Verilator if it is not already available, then run these commands from the project directory:

```bash
verilator --binary --timing -Wall -Wno-fatal \
  --top-module tb_adder_subtracter \
  add_subtracter.v tb_add_subtracter.v
```

Execute the generated simulation:

```bash
./obj_dir/Vtb_adder_subtracter
```

The testbench prints individual test results and reports `ALL TESTS PASSED` when all included checks succeed.

## Skills Demonstrated

- Verilog RTL design and module parameterization
- Combinational logic design
- Bitwise operations and conditional control
- Two’s-complement arithmetic
- Shared arithmetic datapath design
- Testbench development and functional verification
- RTL simulation and debugging with Verilator

## Future Improvements

- Add randomized and boundary-focused test cases
- Verify carry-out and unsigned borrow interpretation
- Add signed-overflow detection
- Run synthesis and inspect the inferred hardware

## Limitations

This project has been functionally simulated. FPGA implementation, physical synthesis, timing closure, and hardware testing have not been claimed.

