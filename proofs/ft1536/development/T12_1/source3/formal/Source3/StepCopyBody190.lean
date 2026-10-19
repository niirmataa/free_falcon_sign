import Source3.MakeFgTailShape190
import Source3.Word32Memory176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- One original fs-to-t1 copy iteration and its two-clause increment, with
   exact pointer walks; no image or transform property is assumed. -/
namespace FT1536.Source3.StepCopyBody190
open C99ArrayReference (State Pointer bindPointer Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open KeygenMakeFgSource (Exec skip)
open Word32Memory176 (element)
open MakeFgTailShape190 (at0 copyBody copyInc)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)

def addr (fs : ArrayPointer) (u0 i slen : Nat) : ArrayPointer :=
  {fs with index := fs.index+u0+i*slen}

def elem (base : ArrayPointer) (i : Nat) : ArrayPointer := {base with index := base.index+i}

theorem elem_eq (base : ArrayPointer) {n : Nat} (i : Fin n) : element base i=elem base i.val := rfl

theorem addr_index (fs : ArrayPointer) (u0 i slen : Nat) :
    (addr fs u0 i slen).index=fs.index+u0+i*slen := rfl

theorem addr_count (fs : ArrayPointer) (u0 i slen : Nat) :
    (addr fs u0 i slen).count=fs.count := rfl

theorem addr_step (fs : ArrayPointer) (u0 slen i : Nat) :
    {addr fs u0 i slen with index := (addr fs u0 i slen).index+slen}=addr fs u0 (i+1) slen :=
  congrArg (fun k : Nat => {addr fs u0 i slen with index := k})
    (show (addr fs u0 i slen).index+slen=fs.index+u0+(i+1)*slen by
      change fs.index + u0 + i * slen + slen = fs.index + u0 + (i + 1) * slen
      rw [Nat.add_mul,Nat.one_mul]
      omega)

def output (s : State) (t1 : ArrayPointer) (i : Nat) (w : BitVec 32) : State :=
  {s with heap := Word32Memory176.write s.heap (elem t1 i) w}

def next (s : State) (fs t1 : ArrayPointer) (u0 slen i : Nat) (w : BitVec 32) : State :=
  bindPointer (FftLocalCells140.put (output s t1 i w) "v".toList (word (i+1)))
    "x".toList (addr fs u0 (i+1) slen)

theorem zero_pointer (s : State) (name : Name) (q : ArrayPointer)
    (binding : s.arrays name=some q) (capacity : q.index≤q.count) : Pointer s name at0 q := by
  refine .add _ _ q q (.uint64 0) binding (.literal .uint64 0) ?_ ?_
  · decide
  · exact .within q 0 capacity

theorem load_value (s : State) (q : ArrayPointer) (w : BitVec 32)
    (binding : s.arrays "x".toList=some q) (capacity : q.index≤q.count) (read : Load32 s.heap q w) :
    C99ModularReference.Eval s (.load32 "x".toList at0) (.uint32 w) :=
  .load32 "x".toList at0 q w (zero_pointer s "x".toList q binding capacity) read

theorem t1_address (s : State) (t1 : ArrayPointer) (i : Nat)
    (bound : i<2^64) (capacity : t1.index+i≤t1.count)
    (binding : s.arrays "t1".toList=some t1) (counter : Cell s "v".toList i) :
    Pointer s "t1".toList MakeFgTailShape190.varV (elem t1 i) := by
  refine .add _ _ t1 _ (.uint64 (word i)) binding (.variable _ _ _ counter) ?_ ?_
  · rw [C99NatWord141.integer i bound]; omega
  · rw [C99NatWord141.integer i bound]
    exact .within t1 i capacity

theorem body_source (s : State) (fs t1 : ArrayPointer) (u0 slen i : Nat) (w : BitVec 32)
    (bound : i<2^64) (fsCapacity : fs.index+u0+i*slen≤fs.count)
    (t1Capacity : t1.index+i<t1.count)
    (t1Binding : s.arrays "t1".toList=some t1)
    (xBinding : s.arrays "x".toList=some (addr fs u0 i slen))
    (counter : Cell s "v".toList i) (read : Load32 s.heap (addr fs u0 i slen) w)
    (t1Allocated : Allocated s.heap (elem t1 i))
    (t1Width : t1.elementBytes=4) (t1Writable : s.heap.writable t1.block=true) :
    Exec copyBody s ⟨output s t1 i w,.normal⟩ := by
  have write : C99MemoryReference.Store32 s.heap (elem t1 i)
      (BitVec.ofInt 32 (C99IntegerReference.Value.integer (.uint32 w)))
      (Word32Memory176.write s.heap (elem t1 i) w) := by
    simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
      using Word32Memory176.source s.heap (elem t1 i) w t1Allocated t1Width t1Writable
  have store : Exec MakeFgTailShape190.copyStore s ⟨output s t1 i w,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (.store32 "t1".toList MakeFgTailShape190.varV
      (.load32 "x".toList at0) s _ (elem t1 i) (.uint32 w)
      (t1_address s t1 i bound (by omega) t1Binding counter)
      (load_value s (addr fs u0 i slen) w xBinding
        (by change fs.index + u0 + i * slen ≤ fs.count; omega) read)
      write))
  have rest : Exec skip (output s t1 i w) ⟨output s t1 i w,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip _)))
  have inner : Exec (.seq MakeFgTailShape190.copyStore skip) s ⟨output s t1 i w,.normal⟩ :=
    .seqNormal _ _ s (output s t1 i w) ⟨output s t1 i w,.normal⟩ store rest
  simpa only [KeygenPublicForwardCall.restore_empty,MakeFgTailShape190.copyBody] using
    (Exec.scope [] [] _ s ⟨output s t1 i w,.normal⟩ inner)

theorem inc_source (s : State) (fs t1 : ArrayPointer) (u0 slen i : Nat) (w : BitVec 32)
    (bound : i<2^64) (slenBound : slen<2^64)
    (fsCapacity : fs.index+u0+i*slen+slen≤fs.count)
    (counter : Cell s "v".toList i) (slenCell : Cell s "slen".toList slen)
    (xBinding : s.arrays "x".toList=some (addr fs u0 i slen)) :
    Exec copyInc (output s t1 i w) ⟨next s fs t1 u0 slen i w,.normal⟩ := by
  have counter' : Cell (output s t1 i w) "v".toList i := by exact counter
  have slenCell' : Cell (output s t1 i w) "slen".toList slen := by exact slenCell
  have xBinding' : (output s t1 i w).arrays "x".toList=some (addr fs u0 i slen) := by exact xBinding
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "v".toList .add (MakeFgTailShape190.num 1))) (output s t1 i w)
      (FftLocalCells140.put (output s t1 i w) "v".toList (word (i+1))) := by
    cases C99LoopScalar141.increment (fun _ => none) (output s t1 i w) "v".toList i bound counter' with
    | base _ _ _ source => exact source
  set mid : State := FftLocalCells140.put (output s t1 i w) "v".toList (word (i+1)) with midEq
  have xAfter : mid.arrays "x".toList=some (addr fs u0 i slen) := by
    rw [midEq]; exact xBinding'
  have slenAfter : Cell mid "slen".toList slen := by
    rw [midEq]
    exact (FftLocalCells140.outside (output s t1 i w) "v".toList "slen".toList
      (word (i+1)) (by decide)).trans slenCell'
  have walked : Pointer mid "x".toList MakeFgTailShape190.varSlen (addr fs u0 (i+1) slen) := by
    refine .add _ _ (addr fs u0 i slen) _ (.uint64 (word slen))
      xAfter (.variable _ _ _ slenAfter) ?_ ?_
    · rw [C99NatWord141.integer slen slenBound]; omega
    · rw [C99NatWord141.integer slen slenBound]
      rw [← addr_step fs u0 slen i]
      refine .within (addr fs u0 i slen) slen ?_
      change fs.index + u0 + i * slen + slen ≤ fs.count
      omega
  have bind : C99ArrayReference.Exec FftLeafPrograms.program
      (.bindPtr "x".toList "x".toList MakeFgTailShape190.varSlen) mid
      (bindPointer mid "x".toList (addr fs u0 (i+1) slen)) :=
    .bindPtr _ _ _ _ _ walked
  have first : C99ModularReference.Exec
      (.base (.scalar (.update "v".toList .add (MakeFgTailShape190.num 1))))
      (output s t1 i w) ⟨mid,.normal⟩ := by
    rw [midEq]
    exact .base _ _ _ update
  have second : C99ModularReference.Exec
      (.base (.bindPtr "x".toList "x".toList MakeFgTailShape190.varSlen)) mid
      ⟨next s fs t1 u0 slen i w,.normal⟩ := by
    refine .base _ _ _ ?_
    rw [midEq]
    exact bind
  have combined : C99ModularReference.Exec MakeFgTailShape190.copyIncCode (output s t1 i w)
      ⟨next s fs t1 u0 slen i w,.normal⟩ :=
    .seqNormal _ _ _ _ _ first second
  exact .level _ _ _ (.modular _ _ _ combined)

end FT1536.Source3.StepCopyBody190
