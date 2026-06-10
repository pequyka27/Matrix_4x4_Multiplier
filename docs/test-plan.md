# Test Plan - Matrix Multiplier RTL

## Objective

Verify that the DUT correctly loads two 4x4 signed-magnitude matrices and outputs their 4x4 product in signed-magnitude format.

## Directed Tests

| Test | A | B | Purpose |
| --- | --- | --- | --- |
| `zero_zero` | all 0 | all 0 | reset and zero result sanity |
| `identity_positive` | identity | positive matrix | output should equal B |
| `positive_identity` | positive matrix | identity | output should equal A |
| `single_negative` | one negative value | positive matrix | sign handling |
| `mixed_sign` | mixed signs | mixed signs | dot-product sign correctness |
| `max_magnitude` | 127 values | 127 values | output width stress |
| `reset_mid_load` | partial matrix | any | reset returns DUT to IDLE |
| `back_to_back` | two full operations | two full operations | no stale state between runs |

## Scoreboard Rule

The testbench should compute expected values using independent integer math:

```text
expected[i][j] = sum(A[i][k] * B[k][j]) for k = 0..3
```

Then convert the expected signed integer back to signed-magnitude before comparing against `dout`.

## Exit Criteria

- All directed tests pass.
- Testbench prints a clear summary: total tests, passed tests, failed tests.
- Any mismatch prints output index, expected value, and actual value.
- Waveform is only used for debug, not for final pass/fail.
