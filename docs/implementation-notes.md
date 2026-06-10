# Implementation Notes

## Suggested FSM

```text
IDLE
  Wait for the first write.

LOAD
  Store 32 sequential signed-magnitude inputs.

CALC
  Compute matrix product values.

OUT
  Stream 16 signed-magnitude outputs.
```

## Internal Representation

Recommended flow:

1. Convert signed-magnitude input to internal signed integer.
2. Store A and B internally.
3. Compute signed dot product.
4. Convert signed result back to signed-magnitude output.

This avoids repeated sign handling in every datapath expression.

## Coding Rules

- Use nonblocking assignments in sequential `always @(posedge clk)` blocks.
- Use blocking assignments in combinational `always @(*)` blocks.
- Keep FSM state register and next-state logic separate.
- Give every combinational output a default assignment.
- Make reset behavior explicit.

## First Implementation Target

Do not optimize first. A simple correct design is better:

- Store all 32 inputs.
- Compute one output at a time.
- Produce 16 outputs sequentially.

Optimization can happen after the directed tests pass.
