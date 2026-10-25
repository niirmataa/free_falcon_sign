# Layer-195 bodyHeap mis-composition — permanent supplement (owner decision A)

Date: 2026-10-25. Window: R1 suffix 573. Status: SUPPLEMENT / RETAINED
FINDING AS DOCUMENT. This note is the bilateral supplement record of the
owner's decision (A) on the job-570 stepState finding. Original bytes of
job 570 are NOT touched; nothing in this note patches them.

## The retained finding (unchanged wording)

StepNttFirst195.bodyHeap mis-composes StepNttBody195.highHeap at the
OUTPUT words lowWordAt/highWordAt where highHeap expects the butterfly
INPUT words, so its written cells are `lowWord (lowWordAt) …` /
`highWord (lowWordAt) …` instead of the executed words, and the image
does NOT hold at StepNttFirst195.stepState. The job-570 keeps (step_*)
never read the heap and remain valid facts about its own stepState.

## Owner decision (A), 2026-10-25

Layer 195 receives a PERMANENT SUPPLEMENT, not a patch:

1. Original job-570 bytes stay untouched. Verified at this window
   start: `formal/Source3/StepNttBody195.lean` SHA256
   `b39a0b909c6d6a8576b4f3f35b7e7f75ac9d4c26a7e3ee3e28427b32b3b79c0c`,
   `formal/Source3/StepNttFirst195.lean` SHA256
   `928525ec67837476cc6f5dc85062975282950d3b53de4374c8aef3f3cb626ee1`
   (job keygen_publicforward159_570, commit 4874bad1).
2. The corrected layer stands as a BILATERAL supplement: the
   execution-derived equation StepNttBody195.body_state (bodyOut at the
   butterfly INPUT words) with the corrected iteration states
   bodyAt/stepAt of the job-571 layer (StepNttPrologue195 /
   StepNttFirstLoop195) is the operative first-pass layer for all later
   windows, on both sides of the record (source layer and report layer
   cite each other).
3. The bodyHeap finding remains a DOCUMENT (this note plus the retained
   DEFECT NOTEs in the module headers of StepNttMiddle195,
   StepNttWhole195 and StepNttKeep195). It is never silently repaired
   and never re-derived.

## Bilateral pointers

- Record side (this note) -> source side: the operative corrected layer
  is StepNttBody195.body_state + the bodyAt/stepAt states consumed by
  StepNttMiddle195 and later modules.
- Source side -> record side: the DEFECT NOTEs in the module headers of
  StepNttMiddle195 / StepNttWhole195 / StepNttKeep195 name this
  supplement and direct consumers to the corrected states.

## Consumer rule (do not re-derive)

Later windows consume the parse map, per-cell keeps and step engine of
job 570 as pinned; the loop/image work composes at bodyAt/stepAt (job
571). Never rebuild anything on the defective StepNttFirst195.stepState
image. The job-570 keeps (step_*) stay usable as facts about its own
stepState only.

Scope: this is a records decision about the layer-195 evidence chain,
not a claim about the C source, the compiler or the mathematics. The
finding stays listed in the RETAINED register (65 + 58 + 4 + finding).
