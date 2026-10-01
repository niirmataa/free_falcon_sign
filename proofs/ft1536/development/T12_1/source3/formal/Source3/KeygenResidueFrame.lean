import Source3.KeygenResidueRanges

namespace FT1536.Source3.KeygenResidueFrame
open C99MemoryReference
open KeygenResidueTrace (Arrays Writes slots)
open KeygenResidueLoop (Trace)
open KeygenSmallOutput (element)

/- Physical non-aliasing of input coefficient objects and the four output
   arrays. The enclosing allocation/layout must supply this memory fact. -/
def InputSeparate (arrays : Arrays) : Prop :=
  ∀ (input output : Fin 4) (i j : Nat), i<1536 → j<1536 → ∀ byte : Fin 2,
    (element (arrays.input input) i).block≠(element (arrays.output output) j).block ∨
      (element (arrays.input input) i).offset+byte.val<(element (arrays.output output) j).offset ∨
      (element (arrays.output output) j).offset+4≤(element (arrays.input input) i).offset+byte.val

theorem writes_sizes (arrays : Arrays) (i : Nat) (indices : List (Fin 4)) (before after : Memory)
    (source : Writes arrays i indices before after) : after.size=before.size := by
  induction source with
  | done => rfl
  | next slot rest before middle after cell tail ih => exact ih.trans cell.write.2.2.2.1

theorem writes_input_bytes (arrays : Arrays) (separate : InputSeparate arrays)
    (i j : Nat) (indices : List (Fin 4)) (before after : Memory)
    (source : Writes arrays i indices before after) (hi : i<1536) (hj : j<1536)
    (input : Fin 4) (byte : Fin 2) :
    after.bytes (element (arrays.input input) j).block ((element (arrays.input input) j).offset+byte.val)=
      before.bytes (element (arrays.input input) j).block ((element (arrays.input input) j).offset+byte.val) := by
  induction source with
  | done => rfl
  | next slot rest before middle after cell tail ih =>
      exact ih.trans (cell.write.2.2.2.2.2.2 _ _ (separate input slot j i hj hi byte))

theorem writes_input_read (arrays : Arrays) (separate : InputSeparate arrays)
    (i j : Nat) (indices : List (Fin 4)) (before after : Memory)
    (source : Writes arrays i indices before after) (hi : i<1536) (hj : j<1536)
    (input : Fin 4) (word : BitVec 16) (read : C99NarrowReads.Load16 before (element (arrays.input input) j) word) :
    C99NarrowReads.Load16 after (element (arrays.input input) j) word :=
  C99NarrowReads.load16_transport before after _ word read (writes_sizes arrays i indices before after source)
    (writes_input_bytes arrays separate i j indices before after source hi hj input)

theorem trace_sizes (arrays : Arrays) (i : Nat) (before after : Memory) (source : Trace arrays i before after) :
    after.size=before.size := by
  induction source with
  | done => rfl
  | next i before middle after guard writes tail ih => exact ih.trans (writes_sizes arrays i slots before middle writes)

theorem trace_input_bytes (arrays : Arrays) (separate : InputSeparate arrays)
    (i j : Nat) (before after : Memory) (source : Trace arrays i before after)
    (hj : j<1536) (input : Fin 4) (byte : Fin 2) :
    after.bytes (element (arrays.input input) j).block ((element (arrays.input input) j).offset+byte.val)=
      before.bytes (element (arrays.input input) j).block ((element (arrays.input input) j).offset+byte.val) := by
  induction source with
  | done => rfl
  | next i before middle after guard writes tail ih =>
      exact ih.trans (writes_input_bytes arrays separate i j slots before middle writes guard hj input byte)

theorem trace_input_read (arrays : Arrays) (separate : InputSeparate arrays)
    (i j : Nat) (before after : Memory) (source : Trace arrays i before after)
    (hj : j<1536) (input : Fin 4) (word : BitVec 16) :
    C99NarrowReads.Load16 before (element (arrays.input input) j) word ↔
      C99NarrowReads.Load16 after (element (arrays.input input) j) word := by
  constructor
  · intro read
    exact C99NarrowReads.load16_transport before after _ word read (trace_sizes arrays i before after source)
      (trace_input_bytes arrays separate i j before after source hj input)
  · intro read
    exact C99NarrowReads.load16_transport after before _ word read (trace_sizes arrays i before after source).symm
      (fun byte => (trace_input_bytes arrays separate i j before after source hj input byte).symm)

end FT1536.Source3.KeygenResidueFrame
