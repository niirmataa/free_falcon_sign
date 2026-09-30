#!/usr/bin/env bash
# C_TASK_3_REFINE — seryjny (serial!) build konsumentow Run2 + FT1536 z pinowanych
# kopii run2_src do wlasnego build/. Kazdy krok strzezony (wolne okno) + log.
set -u
T=~/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/C_TASK_3_REFINE
cd "$T" || exit 1
MODS=(
  run2_src/FT1536/Basic.lean
  run2_src/FT1536/Geometry.lean
  run2_src/FT1536/ROM.lean
  run2_src/FT1536/Relation.lean
  run2_src/Run2/StableLeafAlgebra.lean
  run2_src/Run2/StableLeafSchedule.lean
  run2_src/Run2/NTRUBasis.lean
  run2_src/Run2/CoefficientQuotient.lean
  run2_src/Run2/QuotientOperations.lean
  run2_src/Run2/ActualNTRUFiber.lean
  run2_src/Run2/A2Theta.lean
  run2_src/Run2/T5ThetaNumeric.lean
  run2_src/Run2/ShiftedGaussian.lean
  run2_src/Run2/TriangularGaussian.lean
  run2_src/Run2/T5ScalarMass.lean
  run2_src/Run2/KeygenLeafGate.lean
)
for src in "${MODS[@]}"; do
  rel="${src#run2_src/}"
  out="build/${rel%.lean}.olean"
  echo "=== $src"
  bash run_guarded.sh "$src" "$out" 900 3600 || { echo "FAIL $src"; exit 1; }
done
echo "DEPS_BUILD_DONE"
