import Source3.KeygenSolverNttCalls
import Source3.KeygenSolverEquation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The actual four-call sequence is composed on common heaps. Both earlier
   images and not-yet-transformed converted words survive each later call. -/
namespace FT1536.Source3.KeygenSolverTransforms
open C99MemoryReference
open C99ArrayReference (State)
open KeygenNttWordAlgebra (R value)
open KeygenSmallOutput (element)
open KeygenMkgm3Layout (output gm)
open KeygenSolverNttCalls (Exec Caller)
open KeygenNttTransform (Image)

def Bindings (s : State) (root : ArrayPointer) : Prop :=
  ∀ slot, s.arrays (KeygenResidueTrace.names slot).1.toList=some (output root slot)
def code (indices : List (Fin 4)) : C99ProcedureReference.Stmt :=
  C99ProcedureParser.chain (indices.map (fun slot => KeygenSolverNttCalls.call (KeygenResidueTrace.names slot).1))

theorem four_code : code [0,1,2,3]=KeygenSolverNttCalls.code := by decide

theorem outputs_outside (root : ArrayPointer) (width : root.elementBytes=4)
    (slot other : Fin 4) (different : slot≠other) (j : Nat) (hj : j<1536) :
    KeygenNttFirstValues.Outside (output root slot) (element (output root other) j) := by
  intro i hi
  have ne : slot.val≠other.val := fun h => different (Fin.ext h)
  unfold KeygenNttCells.Separate KeygenMkgm3Layout.DisjointBytes
  simp only [output,element,ArrayPointer.offset,width]
  omega

theorem canonical_value_injective (a b : BitVec 32)
    (ha : KeygenNttButterflyAlgebra.Canonical a) (hb : KeygenNttButterflyAlgebra.Canonical b)
    (equal : value a=value b) : a=b := by
  have residues := (ZMod.natCast_eq_natCast_iff' a.toNat b.toNat 2147355649).mp equal
  change a.toNat<2147355649 at ha
  change b.toNat<2147355649 at hb
  rw [Nat.mod_eq_of_lt ha,Nat.mod_eq_of_lt hb] at residues
  exact BitVec.eq_of_toNat_eq residues

theorem frame_read (before after : Memory) (p q : ArrayPointer) (word : BitVec 32)
    (frame : KeygenNttFirstValues.Frame before after p) (outside : KeygenNttFirstValues.Outside p q)
    (read : Load32 before q word) (canonical : KeygenNttButterflyAlgebra.Canonical word) :
    Load32 after q word := by
  obtain ⟨actual,loaded,range,law⟩ := frame q (value word) outside ⟨word,read,canonical,rfl⟩
  have equal := canonical_value_injective actual word range canonical law
  subst actual
  exact loaded

theorem input_preserved (before after : Memory) (root : ArrayPointer) (width : root.elementBytes=4)
    (slot other : Fin 4) (different : slot≠other) (v : Geometry.Vec)
    (frame : KeygenNttFirstValues.Frame before after (output root slot))
    (input : KeygenResidueVectors.Represents before (output root other) v) :
    KeygenResidueVectors.Represents after (output root other) v := by
  intro i
  obtain ⟨a,ra,ca,va⟩ := (input i).1
  obtain ⟨b,rb,cb,vb⟩ := (input i).2
  exact ⟨⟨a,frame_read before after _ _ a frame
    (outputs_outside root width slot other different i.val (by have := i.isLt; omega)) ra ca,ca,va⟩,
    ⟨b,frame_read before after _ _ b frame
      (outputs_outside root width slot other different (i.val+768) (by have := i.isLt; omega)) rb cb,cb,vb⟩⟩

theorem image_preserved (before after : Memory) (root : ArrayPointer) (width : root.elementBytes=4)
    (slot other : Fin 4) (different : slot≠other) (v : Geometry.Vec)
    (frame : KeygenNttFirstValues.Frame before after (output root slot))
    (image : Image before (output root other) v) : Image after (output root other) v := by
  intro i
  exact frame _ _ (outputs_outside root width slot other different i.val i.isLt) (image i)

theorem sequence_images (indices : List (Fin 4)) (before after : State)
    (root : ArrayPointer) (p0i : BitVec 32) (v : Fin 4 → Geometry.Vec)
    (width : root.elementBytes=4) (unique : indices.Nodup)
    (caller : Caller before p0i (gm root)) (bindings : Bindings before root)
    (inputs : ∀ slot∈indices, KeygenResidueVectors.Represents before.heap (output root slot) (v slot))
    (previous : ∀ slot, slot∉indices → Image before.heap (output root slot) (v slot))
    (table : KeygenMkgm3Table.Initialized before.heap (gm root))
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (code indices) before after) :
    KeygenSolverEquation.Images after.heap (output root) v ∧ KeygenMkgm3Table.Initialized after.heap (gm root) := by
  induction indices generalizing before with
  | nil =>
      cases source
      exact ⟨fun slot => previous slot (by simp),table⟩
  | cons slot rest ih =>
      have nodup := List.nodup_cons.mp unique
      cases source with
      | seq first second before middle after head tail =>
          have result := KeygenSolverNttCalls.call_contract (KeygenResidueTrace.names slot).1 before middle
            (output root slot) (gm root) (v slot) p0i caller (bindings slot) width width
            (KeygenMkgm3Layout.output_gm_separation root width slot) (inputs slot (by simp)) table initialization head
          have locals := KeygenSolverNttCalls.frame _ before middle head
          apply ih middle nodup.2 (KeygenSolverNttCalls.caller_preserved _ before middle p0i (gm root) head caller)
            (fun other => (congrFun locals.2.1 _).trans (bindings other)) _ _ result.2.1 tail
          · intro other member
            have different : slot≠other := by intro equal; subst other; exact nodup.1 member
            exact input_preserved before.heap middle.heap root width slot other different (v other) result.2.2
              (inputs other (List.mem_cons_of_mem _ member))
          · intro other outside
            by_cases equal : other=slot
            · subst other; exact result.1
            · exact image_preserved before.heap middle.heap root width slot other (Ne.symm equal) (v other)
                result.2.2 (previous other (by simpa only [List.mem_cons,not_or] using And.intro equal outside))

theorem four_images (before after : State) (root : ArrayPointer) (p0i : BitVec 32)
    (v : Fin 4 → Geometry.Vec) (width : root.elementBytes=4)
    (caller : Caller before p0i (gm root)) (bindings : Bindings before root)
    (inputs : ∀ slot, KeygenResidueVectors.Represents before.heap (output root slot) (v slot))
    (table : KeygenMkgm3Table.Initialized before.heap (gm root))
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec KeygenSolverNttCalls.code before after) :
    KeygenSolverEquation.Images after.heap (output root) v ∧ KeygenMkgm3Table.Initialized after.heap (gm root) := by
  apply sequence_images [0,1,2,3] before after root p0i v width (by decide) caller bindings
    (fun slot _ => inputs slot) _ table initialization
    (by rw [four_code]; exact source)
  intro slot outside
  fin_cases slot <;> simp at outside

end FT1536.Source3.KeygenSolverTransforms
