# Customizing for your own DUT

## Minimal changes
1. Replace the `.include` paths under **DUT INCLUDE & WRAPPER**.
2. Update the wrapper to match your DUT pin order.

Example wrapper pattern:
- Your standard interface: `VDD VIN VOUT VSS`
- Your DUT signature: `.subckt mycell VDD OUT IN VSS`

Then:
```
.subckt DUT_WRAPPER VDD VIN VOUT VSS
  XU_CORE VDD VOUT VIN VSS mycell
.ends
```

## What to tune
- `CLOAD`
- timing limits (`trise_lim`, `tfall_lim`, ...)
- sweep sets: `tlist`, `vlist`
- DC thresholds: currently defined as 10/50/90% of VDD

## Pass/Fail definition (operational)
Decide what PASS means **for your use case**:
- absolute limits vs VDD-relative limits
- typical vs worst-case
- whether AC metrics matter for a digital cell
