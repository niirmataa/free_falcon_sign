import Source3.KeygenNttLoopSupport
import Source3.KeygenResidueVectors

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The solver-check workspace is four 1536-word coefficient arrays followed
   by a 1024-word gm table. The inverse table temporarily occupies ft.
   The enclosing caller supplies its legal scratch allocation and separate
   coefficient objects; neither table contents nor conversion results are
   part of that memory premise. -/
namespace FT1536.Source3.KeygenMkgm3Layout
open C99MemoryReference
open C99ArrayReference (State)
open C99ModularReference (Stmt Exec)
open C99ProcedureReference (Result)
open KeygenSmallOutput (element)

def gm (root : ArrayPointer) : ArrayPointer := element root 6144
def igm (root : ArrayPointer) : ArrayPointer := root
def output (root : ArrayPointer) (slot : Fin 4) : ArrayPointer := element root (1536*slot.val)
def scratchWords : Nat := 7168
def scratchBytes : Nat := 28672

def Legal (heap : Memory) (root : ArrayPointer) : Prop :=
  root.elementBytes=4 ∧ root.base%4=0 ∧ root.index+scratchWords≤root.count ∧
  root.base+4*root.count≤heap.size root.block ∧ heap.size root.block<2^64 ∧
  heap.writable root.block=true

def DisjointBytes (p : ArrayPointer) (pn : Nat) (q : ArrayPointer) (qn : Nat) : Prop :=
  p.block≠q.block ∨ p.offset+pn≤q.offset ∨ q.offset+qn≤p.offset

def aliasCode : Stmt := C99ModularReference.chainOf [
  .base (.bindPtr "gt".toList "ft".toList (.var "n".toList)),
  .base (.bindPtr "Ft".toList "gt".toList (.var "n".toList)),
  .base (.bindPtr "Gt".toList "Ft".toList (.var "n".toList)),
  .base (.bindPtr "gm".toList "Gt".toList (.var "n".toList))]

def pointerNames : List B20.C.Name := ["ft","gt","Ft","Gt","gm"].map String.toList
theorem alias_source : C99ModularParser.regionContext pointerNames 7354 4=some aliasCode := by decide
theorem temporary_inverse_source : Pinned.keygenLines[7362]?=
    some "\t\tmodp_mkgm3(gm, ft, logn, 1, primes[0].g, p, p0i);\n" := by decide
theorem bytes_required : scratchWords*4=scratchBytes := rfl
theorem inverse_alias (root : ArrayPointer) : igm root=output root 0 := by
  simp [igm,output,element]

def bindAlias (s : State) (dst : String) (p : ArrayPointer) : State :=
  C99ArrayReference.bindPointer s dst.toList p
def ready (s : State) (root : ArrayPointer) : State :=
  bindAlias (bindAlias (bindAlias (bindAlias s "gt" (element root 1536))
    "Ft" (element root 3072)) "Gt" (element root 4608)) "gm" (gm root)

theorem alias_step (s : State) (dst src : String) (p : ArrayPointer) (result : Result)
    (binding : s.arrays src.toList=some p) (size : KeygenNttLoopSupport.USlot s "n" 1536)
    (source : Exec (.base (.bindPtr dst.toList src.toList (.var "n".toList))) s result) :
    result=⟨bindAlias s dst (element p 1536),.normal⟩ := by
  obtain ⟨q,address,he⟩ := KeygenNttLoopSupport.bindPtr_result _ _ _ s result source
  obtain ⟨v,ev,hq⟩ := KeygenNttLoopSupport.pointer_root s src.toList _ p q binding address
  have hv := KeygenNttLoopSupport.variable_u64 s "n" 1536 v size ev
  subst v
  rw [KeygenNttLoopSupport.u64_toNat 1536 (by decide)] at hq
  rw [he,hq]
  rfl

theorem alias_result (s : State) (root : ArrayPointer) (result : Result)
    (binding : s.arrays "ft".toList=some root) (size : KeygenNttLoopSupport.USlot s "n" 1536)
    (source : Exec aliasCode s result) : result=⟨ready s root,.normal⟩ := by
  have h1 := C99ModularReference.continuation _ _ s (bindAlias s "gt" (element root 1536)) result
    (fun r h => alias_step s "gt" "ft" root r binding size h) source
  have h2 := C99ModularReference.continuation _ _ _
    (bindAlias (bindAlias s "gt" (element root 1536)) "Ft" (element root 3072)) result
    (fun r h => by
      have hx := alias_step (bindAlias s "gt" (element root 1536)) "Ft" "gt"
        (element root 1536) r (by simp [bindAlias,C99ArrayReference.bindPointer]) size h
      simpa only [element,Nat.add_assoc] using hx) h1
  have h3 := C99ModularReference.continuation _ _ _
    (bindAlias (bindAlias (bindAlias s "gt" (element root 1536)) "Ft" (element root 3072))
      "Gt" (element root 4608)) result
    (fun r h => by
      have hx := alias_step (bindAlias (bindAlias s "gt" (element root 1536)) "Ft" (element root 3072))
        "Gt" "Ft" (element root 3072) r
        (by simp [bindAlias,C99ArrayReference.bindPointer]) size h
      simpa only [element,Nat.add_assoc] using hx) h2
  have h4 := C99ModularReference.continuation _ _ _ (ready s root) result
    (fun r h => by
      have hx := alias_step
        (bindAlias (bindAlias (bindAlias s "gt" (element root 1536)) "Ft" (element root 3072))
          "Gt" (element root 4608)) "gm" "Gt" (element root 4608) r
        (by simp [bindAlias,C99ArrayReference.bindPointer]) size h
      simpa only [ready,gm,element,Nat.add_assoc] using hx) h3
  exact C99ModularReference.skip_result _ result h4

theorem ready_layout (s : State) (root : ArrayPointer)
    (binding : s.arrays "ft".toList=some root) :
    (ready s root).heap=s.heap ∧ (ready s root).arrays "gm".toList=some (gm root) ∧
    ∀ slot : Fin 4, (ready s root).arrays (KeygenResidueTrace.names slot).1.toList=some (output root slot) := by
  refine ⟨rfl,?_,?_⟩
  · simp [ready,bindAlias,C99ArrayReference.bindPointer]
  · intro slot
    fin_cases slot <;>
      simp [ready,bindAlias,C99ArrayReference.bindPointer,KeygenResidueTrace.names,output,element]
    exact binding

theorem allocated_cell (heap : Memory) (root : ArrayPointer) (legal : Legal heap root)
    (j : Nat) (hj : j<scratchWords) : Allocated heap (element root j) := by
  obtain ⟨width,align,count,size,fit,_⟩ := legal
  simp only [Allocated,element,width]
  exact ⟨by decide,align,by omega,size,fit⟩

theorem gm_allocated (heap : Memory) (root : ArrayPointer) (legal : Legal heap root)
    (j : Nat) (hj : j<1024) : Allocated heap (element (gm root) j) := by
  have he : element (gm root) j=element root (6144+j) := by
    simp [gm,element,Nat.add_assoc]
  rw [he]
  exact allocated_cell heap root legal (6144+j) (by dsimp [scratchWords]; omega)

theorem output_allocated (heap : Memory) (root : ArrayPointer) (legal : Legal heap root)
    (slot : Fin 4) (j : Nat) (hj : j<1536) : Allocated heap (element (output root slot) j) := by
  have he : element (output root slot) j=element root (1536*slot.val+j) := by
    simp [output,element,Nat.add_assoc]
  rw [he]
  exact allocated_cell heap root legal _ (by have := slot.isLt; dsimp [scratchWords]; omega)

theorem table_separation (root : ArrayPointer) (width : root.elementBytes=4) :
    DisjointBytes (gm root) 4096 (igm root) 4096 := by
  right; right
  simp only [gm,igm,element,ArrayPointer.offset,width]
  omega

theorem output_gm_separation (root : ArrayPointer) (width : root.elementBytes=4) (slot : Fin 4) :
    DisjointBytes (output root slot) 6144 (gm root) 4096 := by
  right; left
  simp only [output,gm,element,ArrayPointer.offset,width]
  have := slot.isLt
  omega

theorem input_separation (arrays : KeygenResidueTrace.Arrays) (root : ArrayPointer)
    (layout : KeygenResidueRanges.Layout arrays root)
    (separate : ∀ slot, DisjointBytes (arrays.input slot) 3072 root scratchBytes)
    (widths : ∀ slot, (arrays.input slot).elementBytes=2) :
    KeygenResidueFrame.InputSeparate arrays := by
  intro input out i j hi hj byte
  have hs := separate input
  rw [layout.2 out]
  simp only [DisjointBytes,element,ArrayPointer.offset,scratchBytes] at hs ⊢
  rw [layout.1,widths input] at *
  have hb := byte.isLt
  have ho := out.isLt
  omega

theorem gm_store_separation (arrays : KeygenResidueTrace.Arrays) (root : ArrayPointer)
    (layout : KeygenResidueRanges.Layout arrays root) (slot : Fin 4)
    (i j : Nat) (hi : i<1536) (hj : j<1024) (byte : Fin 4) :
    (element (gm root) j).block≠(element (arrays.output slot) i).block ∨
      (element (gm root) j).offset+byte.val<(element (arrays.output slot) i).offset ∨
      (element (arrays.output slot) i).offset+4≤(element (gm root) j).offset+byte.val := by
  rw [layout.2 slot]
  simp only [gm,element,ArrayPointer.offset,layout.1]
  have hs := slot.isLt
  omega

theorem writes_preserve_gm (arrays : KeygenResidueTrace.Arrays) (root : ArrayPointer)
    (layout : KeygenResidueRanges.Layout arrays root) (i j : Nat) (hi : i<1536) (hj : j<1024)
    (indices : List (Fin 4)) (before after : Memory)
    (source : KeygenResidueTrace.Writes arrays i indices before after) (word : BitVec 32)
    (read : Load32 before (element (gm root) j) word) :
    Load32 after (element (gm root) j) word := by
  induction source with
  | done => exact read
  | next slot rest before middle after cell tail ih =>
      apply ih
      exact Gate00Memory.load32_transport before middle _ word read cell.write.2.2.2.1
        (fun byte => cell.write.2.2.2.2.2.2 _ _
          (gm_store_separation arrays root layout slot i j hi hj byte))

theorem trace_preserves_gm (arrays : KeygenResidueTrace.Arrays) (root : ArrayPointer)
    (layout : KeygenResidueRanges.Layout arrays root) (i j : Nat) (hj : j<1024)
    (before after : Memory) (source : KeygenResidueLoop.Trace arrays i before after)
    (word : BitVec 32) (read : Load32 before (element (gm root) j) word) :
    Load32 after (element (gm root) j) word := by
  induction source with
  | done => exact read
  | next i before middle after guard writes tail ih =>
      exact ih (writes_preserve_gm arrays root layout i j guard hj _ before middle writes word read)

theorem overwrite_preserves (arrays : KeygenResidueTrace.Arrays) (root : ArrayPointer)
    (layout : KeygenResidueRanges.Layout arrays root)
    (separate : KeygenResidueFrame.InputSeparate arrays)
    (before : State) (old : Option C99IntegerReference.Value) (result : Result)
    (counter : before.locals "u".toList=some (.uint64,old))
    (inputs : KeygenResidueTrace.Inputs arrays before)
    (source : Exec KeygenResidueProgram.code before result) :
    (∀ j<1024, ∀ word, Load32 before.heap (element (gm root) j) word →
      Load32 result.state.heap (element (gm root) j) word) ∧
    (∀ slot j, j<1536 → ∀ byte : Fin 2,
      result.state.heap.bytes (element (arrays.input slot) j).block
          ((element (arrays.input slot) j).offset+byte.val)=
        before.heap.bytes (element (arrays.input slot) j).block
          ((element (arrays.input slot) j).offset+byte.val)) ∧
    (∀ slot j, j<1536 → ∃ word,
      Load32 result.state.heap (element (arrays.output slot) j) word ∧
      word.toNat<KeygenNinv31.prime.toNat) := by
  have trace := (KeygenResidueLoop.source_trace arrays before old result counter inputs source).2.2.2
  exact ⟨fun j hj word read => trace_preserves_gm arrays root layout 0 j hj _ _ trace word read,
    fun slot j hj byte => KeygenResidueFrame.trace_input_bytes arrays separate 0 j _ _ trace hj slot byte,
    fun slot j hj => KeygenResidueRanges.trace_range arrays root layout 0 _ _ trace slot j (Nat.zero_le j) hj⟩

end FT1536.Source3.KeygenMkgm3Layout
