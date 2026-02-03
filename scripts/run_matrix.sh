#!/usr/bin/env bash
set -euo pipefail
TB="tb_diamond_inverter.spice"

# Run all corners as separate executions (safe with ngspice)
for CORNER in 0 1 2; do
  echo "Running CORNER_IDX=$CORNER"
  cp "$TB" /tmp/tb_run.spice
  # edit in-place: set CORNER_IDX
  sed -i "s/^\.param CORNER_IDX.*/.param CORNER_IDX  = ${CORNER}/" /tmp/tb_run.spice
  ngspice -b -o "run_corner${CORNER}.log" /tmp/tb_run.spice
  mkdir -p "results_corner${CORNER}"
  cp -r results/* "results_corner${CORNER}/"
  rm -rf results
  echo "Done CORNER_IDX=$CORNER"
  echo
done
