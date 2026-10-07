import Source3.KeygenSolverTransforms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenSolverTarget
open C99ArrayReference (State bindValue)
open C99MemoryReference
open C99ProcedureReference (Result)
open C99ModularReference (Stmt Expr Exec Eval)
open KeygenMkgm3Layout (output gm)

def expression : Expr := .call4 "modp_montymul".toList (.scalar (.literal .i32 18433))
  (.scalar (.literal .i32 1)) (KeygenCheckProgram.cell "p") (KeygenCheckProgram.cell "p0i")
def target : Stmt := .assign "r".toList expression
def code : Stmt := .seq target KeygenCheckProgram.code

theorem target_source : C99ModularParser.region 7378 1=some (.seq target (.base .skip)) := by decide

/- The source literals are signed int, whereas the primitive's parameter
   types are uint32_t. The same bound environment executes the same body. -/
theorem literal_arguments (p0i : BitVec 32) (out : C99IntegerReference.Value)
    (source : C99ScalarReference.FunctionExec C99Frontend.noCalls
      (C99Frontend.headerFunction KeygenModpWord.montgomeryCode)
      [.int32 18433,.int32 1,.uint32 KeygenNinv31.prime,.uint32 p0i] out) :
    KeygenModpWord.SourceExec 18433 1 KeygenNinv31.prime p0i out := by
  cases source with
  | call env result parameters body =>
      cases parameters
      rename_i env1 tail1
      cases tail1
      rename_i env2 tail2
      exact .call _ _ result (.cons _ _ _ _ _ _ (.cons _ _ _ _ _ _ tail2)) body

theorem target_expression (before : State) (p0i : BitVec 32) (result : C99IntegerReference.Value)
    (prime : KeygenNttButterflyCalls.U32Slot before "p" KeygenNinv31.prime)
    (inverse : KeygenNttButterflyCalls.U32Slot before "p0i" p0i)
    (source : Eval before expression result) :
    ∃ word, result=.uint32 word ∧ KeygenModpWord.SourceExec 18433 1 KeygenNinv31.prime p0i (.uint32 word) := by
  cases source with
  | call4 name a b c d x y p pinv result first second third fourth call =>
      have hx : x=.int32 18433 := by cases first with | scalar _ _ h => cases h; rfl
      have hy : y=.int32 1 := by cases second with | scalar _ _ h => cases h; rfl
      have hp := KeygenCheckExpression.cell_value before "p" KeygenNinv31.prime p prime third
      have hi := KeygenCheckExpression.cell_value before "p0i" p0i pinv inverse fourth
      subst x y p pinv
      cases call with
      | montgomery args result body =>
          have source := literal_arguments p0i result body
          have equal := KeygenModpWord.source_exact 18433 1 KeygenNinv31.prime p0i result source
          rw [equal] at source
          exact ⟨_,equal,source⟩

theorem target_result (before : State) (out : Result) (p0i : BitVec 32)
    (prime : KeygenNttButterflyCalls.U32Slot before "p" KeygenNinv31.prime)
    (inverse : KeygenNttButterflyCalls.U32Slot before "p0i" p0i)
    (declared : KeygenNttButterflyCalls.U32Declared before "r")
    (source : Exec target before out) :
    ∃ word, out=⟨bindValue before "r".toList .uint32 (.uint32 word),.normal⟩ ∧
      KeygenModpWord.SourceExec 18433 1 KeygenNinv31.prime p0i (.uint32 word) := by
  cases source with
  | assign name expr before ty old v slot ev =>
      obtain ⟨previous,hslot⟩ := declared
      have ht : ty=.uint32 := congrArg Prod.fst (Option.some.inj (slot.symm.trans hslot))
      subst ty
      obtain ⟨word,equal,body⟩ := target_expression before p0i v prime inverse ev
      subst v
      exact ⟨word,rfl,body⟩

theorem checked_images (before : State) (out : Result) (root : ArrayPointer)
    (p0i : BitVec 32) (v : Fin 4 → Geometry.Vec)
    (caller : KeygenSolverNttCalls.Caller before p0i (gm root))
    (bindings : KeygenSolverTransforms.Bindings before root)
    (size : C99CountedWords.Limit before)
    (counter : ∃ old, before.locals "u".toList=some (.uint64,old))
    (declared : KeygenNttButterflyCalls.U32Declared before "r")
    (images : KeygenSolverEquation.Images before.heap (output root) v)
    (bounded : KeygenSolverEquation.Bounds v)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec code before out) (success : out.flow=.returned (some (.int32 1))) :
    KeygenSolverEquation.Equation v := by
  obtain ⟨middle,head,tail⟩ := KeygenNttControl.seq_inv target KeygenCheckProgram.code before out (by decide) source
  obtain ⟨word,equal,body⟩ := target_result before ⟨middle,.normal⟩ p0i caller.prime caller.inverse declared head
  have hm := congrArg Result.state equal
  dsimp only at hm
  subst middle
  obtain ⟨old,counter⟩ := counter
  apply KeygenSolverEquation.exact_of_images (output root) v
    (bindValue before "r".toList .uint32 (.uint32 word)) out p0i word old _ _ images bounded initialization body tail success
  · simpa only [bindValue,C99ScalarReference.set,show "u".toList≠"r".toList by decide,ite_false] using counter
  · constructor
    · exact bindings 0
    · exact bindings 1
    · exact bindings 2
    · exact bindings 3
    · simpa [KeygenNttButterflyCalls.U32Slot,bindValue,C99ScalarReference.set] using caller.prime
    · simpa [KeygenNttButterflyCalls.U32Slot,bindValue,C99ScalarReference.set] using caller.inverse
    · simp [bindValue,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]
    · simpa [C99CountedWords.Limit,bindValue,C99ScalarReference.set] using size

theorem transformed_checked (before transformed : State) (out : Result) (root : ArrayPointer)
    (p0i : BitVec 32) (v : Fin 4 → Geometry.Vec) (width : root.elementBytes=4)
    (caller : KeygenSolverNttCalls.Caller before p0i (gm root))
    (bindings : KeygenSolverTransforms.Bindings before root)
    (size : C99CountedWords.Limit before)
    (counter : ∃ old, before.locals "u".toList=some (.uint64,old))
    (declared : KeygenNttButterflyCalls.U32Declared before "r")
    (inputs : ∀ slot, KeygenResidueVectors.Represents before.heap (output root slot) (v slot))
    (table : KeygenMkgm3Table.Initialized before.heap (gm root))
    (bounded : KeygenSolverEquation.Bounds v)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (transforms : KeygenSolverNttCalls.Exec KeygenSolverNttCalls.code before transformed)
    (validation : Exec code transformed out) (success : out.flow=.returned (some (.int32 1))) :
    KeygenSolverEquation.Equation v := by
  have images := KeygenSolverTransforms.four_images before transformed root p0i v width caller bindings inputs
    table initialization transforms
  obtain ⟨hl,ha,_,_⟩ := KeygenSolverNttCalls.frame _ before transformed transforms
  apply checked_images transformed out root p0i v
    (KeygenSolverNttCalls.caller_preserved _ before transformed p0i (gm root) transforms caller)
    (fun slot => (congrFun ha _).trans (bindings slot)) _ _ _ images.1 bounded initialization validation success
  · simpa only [C99CountedWords.Limit,hl] using size
  · simpa only [hl] using counter
  · simpa only [KeygenNttButterflyCalls.U32Declared,hl] using declared

end FT1536.Source3.KeygenSolverTarget
