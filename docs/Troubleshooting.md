# Troubleshooting

## 1) `Error: incomplete or empty netlist ... no simulations run!`
This happens in batch mode when ngspice cannot see any analysis commands.

Checklist:
- Confirm your file really contains a `.control ... .endc` block and ends with `.end`.
- Avoid running with a shell redirection **and** `-o` at the same time.
  - Use **either**: `ngspice -b -o run.log tb.spice`
  - **or**: `ngspice -b tb.spice > run.log 2>&1`
- Ensure the file has Unix line endings (LF). If you edited on Windows, convert (e.g., `dos2unix`).

## 2) `Warning: redefinition of .subckt ... ignored`
Usually indicates the same model subcircuits were included more than once. In the SG13G2 flows this can happen due to `.spiceinit` + `.lib`.
- If simulations run and results look correct, these warnings are typically harmless.
- If you want to eliminate them, ensure models are included only once (advanced; environment-dependent).

## 3) PULSE / parameter parse errors
If you see errors like `parameter value out of range or the wrong type`:
- Keep numeric expressions inside `.param` and use `{PARAM}` in element definitions.
- Avoid injecting `$&var` expansions directly into element lines (especially with negative numbers).

## 4) Missing model files / `.lib` not found
If `.lib cornerMOSlv.lib ...` fails:
- Your `.spiceinit` is not setting the proper `sourcepath`.
- Verify `~/.spiceinit` exists and includes `setcs sourcepath = ( $sourcepath $PDK_ROOT/... )`.

## 5) SCH works but PEX fails
Most common causes:
- Pin order mismatch between SCH and PEX `.subckt`.
- Different node naming conventions.

Use the `DUT_WRAPPER` to standardize pin order.
