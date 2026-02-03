# Open Analog – DIAMOND Testbench (FREE)

This package is a **robust ngspice-45 regression-style testbench** for an inverter, supporting **dual mode**:
- **SCH** (schematic netlist) and
- **PEX** (post-layout netlist).

It produces a machine-readable CSV (`results/summary.csv`) plus `.raw` waveforms per PVT point.

## What you get
- `tb_diamond_inverter.spice` – main testbench (dual mode SCH/PEX)
- `inverter_tutorial/` – example inverter netlists (SCH + PEX)
- `docs/` – quickstart + troubleshooting
- `sample_results/` – small example outputs (for sanity check)

## Prerequisites (assumed)
- **ngspice 45**
- **IHP SG13G2 PDK installed** and your environment loads a working `.spiceinit` that sets `setcs sourcepath` (so `.lib cornerMOSlv.lib ...` resolves).

## Quick start
1. Choose mode + corner at the top of `tb_diamond_inverter.spice`:
   - `SIM_MODE = 0` (SCH) or `1` (PEX)
   - `CORNER_IDX = 0/1/2` (TT/SS/FF)
2. Run:
   - `ngspice -b -o run_gold.log tb_diamond_inverter.spice`
3. Check outputs:
   - `results/summary.csv`
   - `results/run_trace.log`
   - `results/*.raw`

## Important design constraint
This testbench intentionally uses **one CORNER per execution** (corner selection happens at netlist parse time). If you need a full corner sweep, do **multiple runs** and merge CSVs.

## Next steps
See `docs/Quickstart.pdf` and `docs/Troubleshooting.md`.
