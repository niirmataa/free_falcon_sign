import Source3.ShakeBlockRename090

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeEncodeRename090
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99BlockRename090

theorem declaration (r : Renaming) (program : C99ArrayReference.Program) (name : Name) (before after : State)
    (source : C99ArrayReference.Exec program (.declarePtr name) before after) :
    C99ArrayReference.Exec program (.declarePtr name) (state r before) (state r after) := by
  cases source
  rw [C99StateRename090.declarePointer]
  exact .declarePtr _ _

theorem assignment (r : Renaming) (program : C99ArrayReference.Program) (dst src : Name)
    (index : CLogic.Expr) (before after : State)
    (source : C99ArrayReference.Exec program (.bindPtr dst src index) before after) :
    C99ArrayReference.Exec program (.bindPtr dst src index) (state r before) (state r after) := by
  cases source with
  | bindPtr before dst src index p address =>
      rw [C99StateRename090.bindPointer]
      exact .bindPtr (state r before) dst src index (ptr r p)
        (C99StateRename090.pointer r before src index p address)

theorem execution (r : Renaming) (code : List ShakeEncode.Instruction) (before after : State)
    (source : ShakeEncode.Exec code before after) :
    ShakeEncode.Exec code (state r before) (state r after) := by
  induction source with
  | done before => exact .done (state r before)
  | next instruction tail before written after p v address evaluated write rest ih =>
      exact .next instruction tail (state r before) (heap r written) (state r after) (ptr r p) v
        (C99StateRename090.pointer r before "buf".toList instruction.index p address)
        (C99StateRename090.scalar r before instruction.value v evaluated)
        (store8 r before.heap written p _ write) ih

theorem entry (r : Renaming) (before : State) (p : ArrayPointer) (v : Value) :
    state r (ShakeEncode.entry before p v) = ShakeEncode.entry (state r before) (ptr r p) v := by
  apply C99StateRename090.ext <;> try rfl
  funext name
  by_cases out : name = ['o','u','t'] <;> simp [state, ShakeEncode.entry, out]

theorem invoke (r : Renaming) (before after : State) (p : ArrayPointer) (v : Value)
    (source : ShakeEncode.Invoke before p v after) :
    ShakeEncode.Invoke (state r before) (ptr r p) v (state r after) := by
  cases source with
  | run declared ready after decl assign body =>
      have decl' := declaration r FftLeafPrograms.program "buf".toList (ShakeEncode.entry before p v) declared decl
      rw [entry] at decl'
      have assign' := assignment r FftLeafPrograms.program "buf".toList "out".toList
        C99ProcedureParser.zero declared ready assign
      exact .run (state r declared) (state r ready) (state r after) decl' assign'
        (execution r ShakeEncode.code ready after body)

end FT1536.Source3.ShakeEncodeRename090
