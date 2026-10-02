# INCIDENT 2026-10-02 — double-launch of the T5-pointwise window

Facts (all verified):
- The same prompt (`PROMPT_T5_POINTWISE.md`) was launched TWICE. At the
  first window's start `formal/T5Pointwise.lean` did not exist (verified
  `ls` + `git status` by that window).
- Window A (first writer) produced ~530 lines (prod_bounds_fin /
  factorChain_sandwich_fin, TowerRoad/MachineOpRoad/WrapCoordRoad/
  BoxFactorRoad, massSandwich_not_pointwise counterexamples, plug
  attemptWeights_of_pointwiseRoads). Its compile errors were purely
  mechanical (4 known items).
- Window B (second launch) OVERWROTE the file at 20:16:54 with a parallel
  project (815 lines, 42700 B: TowerRowRoad/RowFactors/road_fit_3072_rows/
  additiveError_no_machineStage/PointwiseStageRoad) and is still active
  (build log 20:19, mixed interleaved output from both compiles sharing
  .build/check_lib/T5Pointwise.log).
- Window A stopped per stop-and-report and did not touch anything.

Preservation (coordinator, 20:29):
- Window B's on-disk version snapshotted verbatim to
  `T5Pointwise.windowB-2016.lean` (sha256
  `cdca63cd83e79f65fbb7a04483ac5ed112d3e60aab2356c585e6056c9a57d22a`),
  mixed log snapshotted to `T5Pointwise.windowB-mixed.log`.
- Window A's version lives in its session (recoverable by that window).

Ruling (owner-delegated, coordinator-recorded):
1. Window B is stopped by the owner (only the owner stops workers).
2. Window A takes over the task: restores its version at the canonical
   path, finishes to 0/0 + axiom audit, and ports window B's unique
   results (`rowwise_fullBudget_busts`, `additiveError_no_machineStage`,
   `road_fit_3072_rows`) where cheap; otherwise cites them from the
   snapshot in the work note. The snapshot is NEVER deleted.
3. Lesson: before launching a window, check the target file/W for an
   active executor. Double-launch is the known two-windows incident.

Status: IN_PROGRESS / WORKING_NOT_FROZEN; one executor on this W from
the ruling onward.
