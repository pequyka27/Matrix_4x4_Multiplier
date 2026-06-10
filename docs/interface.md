# Matrix Multiplier RTL Interface

This file records the expected assignment interface before RTL coding starts.

## Signal Contract

| Signal | Direction | Width | Description |
| --- | --- | --- | --- |
| `clk` | input | 1 | Clock |
| `rst` | input | 1 | Synchronous reset |
| `wrt_en` | input | 1 | Write enable for input loading |
| `din` | input | 8 | Signed-magnitude input value |
| `dout` | output | 17 | Signed-magnitude output value |

Optional implementation signals may be added if needed:

| Signal | Direction | Width | Description |
| --- | --- | --- | --- |
| `busy` | output | 1 | DUT is loading or computing |
| `valid` | output | 1 | `dout` is valid |
| `done` | output | 1 | All 16 outputs have been produced |

## Input Format

Each input value is 8-bit signed-magnitude:

```text
din[7]   = sign
din[6:0] = magnitude
```

The DUT receives 32 values:

- Inputs 0 to 15: matrix A.
- Inputs 16 to 31: matrix B.

## Output Format

Each output value is 17-bit signed-magnitude:

```text
dout[16]   = sign
dout[15:0] = magnitude
```

The 17-bit width is required because one product term can be `127 * 127 = 16129`, and each output sums 4 product terms:

```text
4 * 16129 = 64516
```

64516 fits in 16 magnitude bits, plus 1 sign bit.
