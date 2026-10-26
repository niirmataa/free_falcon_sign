import Source3.ZintReduceLoop209

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintReduceWhole209
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32 set64)
open C99NatWord141 (word)
open ZintModSignedWord194 (xName uName dlenName)
open ZintReduceLoop209 (Fixed fold)
open KeygenWordExec (Exec)

def t1 (s : State) := C99DeclarationStatements.effect .u32 [xName] s
 def t2 (s : State) := C99DeclarationStatements.effect .u64 [uName] (t1 s)
 def t3 (s : State) := set32 (t2 s) "x" 0
 def start (s : State) (n : Nat) := set64 (t3 s) "u" (word n)
 def wrapped (s : State) := set64 s "u" (0#64-1#64)
 def resultWord (W : Nat → BitVec 32) (n : Nat) (p pi r2 : BitVec 32) := fold W p pi r2 n 0

theorem before3 (s : State) (name : Name) (nu : name≠uName) (nx : name≠xName) : (t3 s).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep (t2 s) xName .uint32 (.uint32 0) name nx).trans
    ((ZintSubWord194.effect_one_other .u64 uName name (t1 s) nu).trans (ZintSubWord194.effect_one_other .u32 xName name s nx))

theorem start_locals (s : State) (n : Nat) (name : Name) (nu : name≠uName) (nx : name≠xName) :
    (start s n).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep (t3 s) uName .uint64 (.uint64 (word n)) name nu).trans (before3 s name nu nx)

theorem initial_fixed (s : State) (pd : ArrayPointer) (n : Nat) (W : Nat → BitVec 32) (p pi r2 : BitVec 32)
    (fixed : Fixed s pd n W p pi r2) : Fixed (start s n) pd n W p pi r2 := by
  have hl:=start_locals s n
  exact ⟨fixed.nBound,fixed.dBinding,(hl dlenName (by decide) (by decide)).trans fixed.lenCell,
    (hl "p".toList (by decide) (by decide)).trans fixed.pCell,(hl "p0i".toList (by decide) (by decide)).trans fixed.iCell,
    (hl "R2".toList (by decide) (by decide)).trans fixed.rCell,fixed.capacity,fixed.data⟩

theorem append_source (s : State) (n : Nat) (len : Cell s dlenName n) (out : C99ProcedureReference.Result)
    (rest : Exec (.seq (.seq ZintModSignedWord194.leafLoop ZintModSignedWord194.leafDecU)
      (.seq ZintModSignedWord194.leafRetX ZintModSignedWord194.wskip)) (start s n) out) :
    Exec (KeygenZintLeaves.code .reduce) s out := by
  have h1 : Exec ZintModSignedWord194.leafDeclX s ⟨t1 s,.normal⟩ := ZintSubWord194.declare_run .u32 [xName] s
  have h2 : Exec ZintModSignedWord194.leafDeclU (t1 s) ⟨t2 s,.normal⟩ := ZintSubWord194.declare_run .u64 [uName] (t1 s)
  have h3 : Exec ZintModSignedWord194.leafSetX0 (t2 s) ⟨t3 s,.normal⟩ :=
    .assign _ _ _ .uint32 none (.int32 0) rfl (WordAtoms205.literal _ 0)
  have udecl : (t3 s).locals uName=some (.uint64,none) :=
    (CrtState205.keep32 (t2 s) "x" "u" 0 (by decide)).trans (ZintSubWord194.effect_one_cell .u64 uName (t1 s))
  have len3 : Cell (t3 s) dlenName n := (before3 s dlenName (by decide) (by decide)).trans len
  have h4 : Exec ZintModSignedWord194.leafSetU1 (t3 s) ⟨start s n,.normal⟩ :=
    WordAtoms205.assign64 _ "u" none _ (word n) udecl (CrtState205.expr64 _ "dlen" (word n) len3)
  rw [ZintModSignedWord194.reduce_shape]
  exact .seqNormal _ _ _ _ _ h1 (.seqNormal _ _ _ _ _ h2 (.seqNormal _ _ _ _ _ h3 (.seqNormal _ _ _ _ _ h4 rest)))

theorem source (s : State) (pd : ArrayPointer) (n : Nat) (W : Nat → BitVec 32) (p pi r2 : BitVec 32)
    (fixed : Fixed s pd n W p pi r2) :
    ∃ out : C99ProcedureReference.Result, Exec (KeygenZintLeaves.code .reduce) s out ∧
      out.flow=.returned (some (.uint32 (resultWord W n p pi r2))) ∧ out.state.heap=s.heap ∧ out.state.arrays=s.arrays ∧
      (∀ name : Name, name≠uName → name≠xName → out.state.locals name=s.locals name) := by
  have uc : Cell (start s n) uName n := CrtState205.cell64 _ _ _
  have xc : Slot (start s n) "x" 0 :=
    (CrtState205.keep64 (t3 s) "u" "x" (word n) (by decide)).trans (CrtState205.cell32 _ _ _)
  obtain ⟨last,loopRun,_,lastU,lastX,heap,arrays,locals⟩:=ZintReduceLoop209.source n (start s n) pd n W p pi r2 0
    (initial_fixed s pd n W p pi r2 fixed) (Nat.le_refl n) uc xc
  have decrement : Exec ZintModSignedWord194.leafDecU last ⟨wrapped last,.normal⟩ :=
    ZintSubWord194.update_run last uName .sub (.literal .i32 1) .uint64 (.uint64 0) (.int32 1) (.uint64 (0#64-1#64))
      lastU (.literal .int32 1) ZintNormWord194.dec_zero
  have retCell : Slot (wrapped last) "x" (resultWord W n p pi r2) :=
    (CrtState205.keep64 last "u" "x" (0#64-1#64) (by decide)).trans lastX
  have ret : Exec ZintModSignedWord194.leafRetX (wrapped last)
      ⟨wrapped last,.returned (some (.uint32 (resultWord W n p pi r2)))⟩ :=
    .ret _ _ _ (CrtState205.expr32 _ "x" _ retCell)
  have rest : Exec (.seq (.seq ZintModSignedWord194.leafLoop ZintModSignedWord194.leafDecU)
      (.seq ZintModSignedWord194.leafRetX ZintModSignedWord194.wskip)) (start s n)
      ⟨wrapped last,.returned (some (.uint32 (resultWord W n p pi r2)))⟩ :=
    .seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ loopRun decrement) (.seqExit _ _ _ _ ret (by intro h; cases h))
  refine ⟨⟨wrapped last,.returned (some (.uint32 (resultWord W n p pi r2)))⟩,append_source s n fixed.lenCell _ rest,rfl,heap,arrays,?_⟩
  intro name nu nx
  exact (SelectedStepAddPrime195.locals_keep last uName .uint64 (.uint64 (0#64-1#64)) name nu).trans
    ((locals name nu nx).trans (start_locals s n name nu nx))

end FT1536.Source3.ZintReduceWhole209
