# Open Analog - DIAMOND Testbench (SCH + PEX) for IHP SG13G2

A **regression-style ngspice testbench template** for a CMOS inverter in the **IHP SG13G2** technology, designed to run in **two modes**:

- **SCH**: schematic netlist (fast, idealized)
- **PEX**: post-layout extracted netlist (realistic)

It runs **DC + TRAN + AC** at a small **PVT matrix**, saves **per-point waveforms**, and generates a single **machine-readable CSV summary** for automated checking.

---


## Design philosophy

- **Dual mode**: SCH and PEX controlled by one switch (`SIM_MODE`).
- **Wrapper shielding**: stable top-level pin order via `DUT_WRAPPER`.
- **One-corner-per-run**: reproducibility over convenience (use `scripts/run_matrix.sh`).
- **Full data persistence**: keep per-point `.raw` traces, plus one aggregated CSV.

## What you get

## Repository layout

```text
.
├─ tb_diamond_inverter.spice        # main testbench
├─ inverter_tutorial/
│  ├─ xschem/inverter.spice         # example SCH netlist
│  └─ pex/inverter.spice            # example PEX netlist
├─ scripts/
│  └─ run_matrix.sh                 # 1 corner per run (recommended)
├─ docs/
│  ├─ Quickstart.pdf
│  ├─ Customize.md
│  └─ Troubleshooting.md
├─ sample_results/                  # example outputs
├─ CHANGELOG.md
└─ LICENSE.txt
```



- `tb_diamond_inverter.spice`  
  Main DIAMOND testbench (dual mode, pass/fail, CSV + waveforms).
- `inverter_tutorial/`  
  Example DUT netlists (SCH + PEX) used as a working reference.
- `docs/`  
  Quickstart and troubleshooting material.
- `sample_results/`  
  Example outputs to sanity-check your environment.
- `scripts/run_matrix.sh`  
  Convenience wrapper for batch runs (Linux/macOS/WSL).

---

## Requirements

- **ngspice 45** (this repository targets ngspice-45 behavior)
- **IHP Open PDK (SG13G2)** installed and discoverable by ngspice
- A working **.spiceinit** that sets `setcs sourcepath` so this resolves:
  - `.lib cornerMOSlv.lib mos_tt|mos_ss|mos_ff`

> Notes  
> - This repo does **not** bundle the PDK. You must install/configure it separately.  
> - If your environment uses Docker, ensure the PDK path is mounted into the container and that `.spiceinit` is present in `$HOME`.

---

## Quick start

### 1) Configure mode + corner

Open `tb_diamond_inverter.spice` and set:

- `SIM_MODE`:
  - `0` = SCH
  - `1` = PEX
- `CORNER_IDX`:
  - `0` = TT
  - `1` = SS
  - `2` = FF

Example:
```spice
.param SIM_MODE   = 0
.param CORNER_IDX = 0
```

### 2) Run ngspice

From the repository root:
```bash
mkdir -p results
ngspice -b -o run_diamond.log tb_diamond_inverter.spice
```

### 3) Inspect outputs

After a successful run, you should see:

- `results/summary.csv`  
  One line per PVT point with extracted metrics + `PASS` flag.
- `results/run_trace.log`  
  Lightweight progress trace (useful for debugging).
- `results/vtc_*_*.raw`, `results/tran_*_*.raw`, `results/ac_*_*.raw`  
  Per-point waveforms/frequency responses (filenames include mode, corner, VDD and temperature).

---


### Batch corners safely (recommended)

ngspice can behave poorly if you try to reload different `.lib` corners inside a single interactive session.
To keep the run reproducible, this repo includes a small wrapper that runs **one corner per ngspice execution**:

```bash
bash scripts/run_matrix.sh
```

This produces:
- `run_corner0.log`, `run_corner1.log`, `run_corner2.log`
- `results_corner0/`, `results_corner1/`, `results_corner2/` (each contains its own `summary.csv` and `.raw` files)


## What the testbench measures

### DC (VTC)
- **VOH** = `MAX(Vout)`
- **VOL** = `MIN(Vout)`
- **VSW** = `Vin` where `Vout = VDD/2`
- **VIL/VIH** = `Vin` where `dVout/dVin = -1` (first and second crossing)

### Transient (timing)
- **trise**: 10% -> 90% on `Vout`
- **tfall**: 90% -> 10% on `Vout`
- **tPHL/tPLH**: input 50% crossing to output 50% crossing

### AC (small-signal)
- **A0_dB**: maximum `vdb(Vout)`
- **UGF_Hz**: frequency where `vdb(Vout) = 0 dB` (first crossing)
- **BW3dB_Hz**: where `vdb(Vout) = A0_dB - 3 dB` (first crossing)

---

## Pass/fail policy

Each PVT point sets `PASS = 1` initially and flips to `0` if any check fails.

You can tune the limits directly in the `.control` block:
- `trise_lim`, `tfall_lim`, `tphl_lim`, `tplh_lim`
- `voh_lim = 0.9*VDD`, `vol_lim = 0.1*VDD`

This makes the testbench usable as a **smoke test**, **regression gate**, or **CI check** (once you add a runner).

---

## Dual-mode architecture (why it is robust)

### 1) Include selector (SCH vs PEX)

The DUT include switches using `SIM_MODE`:
```spice
.if (SIM_MODE == 0)
  .include ./inverter_tutorial/xschem/inverter.spice
.else
  .include ./inverter_tutorial/pex/inverter.spice
.endif
```

### 2) Wrapper shielding (pin consistency)

The DUT is instantiated through a wrapper subcircuit (`DUT_WRAPPER`) so you can keep **one pin order** at the top level even if SCH/PEX netlists differ.

If you plug your own inverter, you typically only need to:
1) replace the included netlists, and  
2) adjust the internal instantiation inside `DUT_WRAPPER` if your `.subckt` pin order differs.

---

## Customization

Common edits (top of `tb_diamond_inverter.spice`):

- `VDD_NOM` / `VDD`
- `CLOAD`
- PULSE timing: `TD TR TF PW PER`
- PVT points:
  - `tlist = ( -40 27 125 )`
  - `vlist = ( 0.95 1.0 1.05 )`

See:
- `docs/Customize.md`
- `docs/Troubleshooting.md`

---

## Troubleshooting (fast checklist)

If `.lib cornerMOSlv.lib ...` fails:
- Your `.spiceinit` / `setcs sourcepath` is not loaded, or
- The PDK path is not mounted/visible inside your environment.

If you see subckt redefinition warnings:
- Ensure your DUT netlist does not re-include model libraries already loaded by the testbench.
- Warnings are often harmless, but you should make the inclusion graph clean for CI stability.

If outputs are missing:
- Check `results/run_trace.log` to find the last stage reached.
- Confirm `shell mkdir -p results` works in your environment (Windows users usually run via WSL or a container).

---

## Versioning

See `CHANGELOG.md` for changes and compatibility notes.

---

## License

MIT. See `LICENSE.txt`.

---

## Disclaimer

This is an **independent** educational/engineering artifact. It is **not affiliated with or endorsed by IHP**.  
You are responsible for complying with the licensing terms of the PDK and any third-party models you use.

