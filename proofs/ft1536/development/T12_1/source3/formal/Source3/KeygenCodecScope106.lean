import Source3.KeygenPublicValues106

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecScope106
open KeygenCodecSyntax
open KeygenCodecValues
open KeygenCodecAtoms106 (Clean)

def Allowed (name : Name) : Prop :=
  name ≠ "out".toList ∧ name ≠ "NULL".toList ∧ name ≠ "x".toList ∧ name ≠ "buf".toList

theorem declared_allowed (before : Locals) (name : Name) (ty : C99IntegerReference.Ty)
    (old : Option C99IntegerReference.Value) (clean : Clean before)
    (declared : before.scalars name = some (ty,old)) : Allowed name := by
  simp only [Clean, Allowed] at *
  grind

theorem set_allowed (before : Locals) (name : Name) (ty : C99IntegerReference.Ty)
    (value : Option C99IntegerReference.Value) (clean : Clean before) (allowed : Allowed name) :
    Clean (localSet before name ty value) := by
  simp only [Clean, Allowed, localSet, C99ScalarReference.set] at *
  split_ifs <;> grind

theorem assign_clean (before after : Locals) (name : Name) (ty : C99IntegerReference.Ty)
    (old value : Option C99IntegerReference.Value) (start : Clean before) (next : Clean after)
    (declared : before.scalars name = some (ty,old)) : Clean (localSet after name ty value) :=
  set_allowed after name ty value next (declared_allowed before name ty old start declared)

def declarationsChecked (objects : List Object) : Bool := objects.all fun o =>
  decide (o.name ≠ "out".toList ∧ o.name ≠ "NULL".toList ∧ o.name ≠ "x".toList)

theorem declarations (objects : List Object) (before after : Locals)
    (checked : declarationsChecked objects = true) (start : Clean before)
    (source : declareLocals objects before = some after) : Clean after := by
  induction objects generalizing before after with
  | nil => cases source; exact start
  | cons obj rest ih =>
      obtain ⟨head, tail⟩ := Bool.and_eq_true_iff.mp checked
      have names := of_decide_eq_true head
      simp only [declareLocals] at source
      split at source
      · cases source
      · split at source
        · split at source
          · exact ih _ _ tail start source
          · cases source
        · rename_i notBuf
          cases ht : scalarTy obj.type with
          | none => simp only [ht] at source; cases source
          | some ty =>
              simp only [ht] at source
              exact ih _ _ tail (set_allowed before obj.name ty none start ⟨names.1,names.2.1,names.2.2,notBuf⟩) source

theorem scope (code : Stmt) (before after : State) (outer : Clean before.locals) (inner : Clean after.locals) :
    Clean (KeygenCodecExecution.scopeExit code before after).locals := by
  simp only [KeygenCodecExecution.scopeExit, Clean] at *
  split_ifs <;> grind

/-- This checked fragment excludes terminal private codec calls. Both
    concrete private leaf bodies and the full public encoder satisfy it. -/
def checkedCode : Stmt → Bool
  | .declare objects => declarationsChecked objects
  | .seq a b | .branch _ a b => checkedCode a && checkedCode b
  | .scope body | .whileLoop _ body => checkedCode body
  | .switch _ a b c => checkedCode a && checkedCode b && checkedCode c
  | .loop initial _ increment body => checkedCode initial && (checkedCode body && checkedCode increment)
  | .ret (.call _ _) => false
  | .skip | .write _ _ _ | .increment _ | .evaluate _ | .ret _ | .breakLoop | .continueLoop => true

theorem none_checked : checkedCode KeygenCodecNoneBinding.code = true := by decide +kernel

theorem static_checked : checkedCode KeygenCodecStaticBinding.code = true := by decide +kernel

theorem public_checked : checkedCode KeygenPublicEncodeBinding077.code = true := by decide +kernel

theorem store_byte (before : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer)
    (word : BitVec 8) (a b : C99MemoryReference.Memory)
    (first : KeygenCodecExecution.StoreByte before p word a)
    (second : KeygenCodecExecution.StoreByte before p word b) : a = b :=
  C99HeapDeterminism089.store8 before p word a b first second

end FT1536.Source3.KeygenCodecScope106
