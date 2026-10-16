import Source3.KeygenPublicTableSeed
import Source3.PublicLeafSource157
import Source3.PublicDivisionSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Constructive execution of the generator prologue: the three declarations,
   the actual mq_montymul g initialization, the k=logn assignment, the
   post-increment square loop and the mq_div_18433 inverse store. No root
   property, table image or evaluation is assumed; a suffix execution is an
   explicit continuation. -/
namespace FT1536.Source3.PublicGenerateHead159
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicTableAtoms (Slot var literal mont divide)
open KeygenPublicTableSeed

theorem mul_call (x y : BitVec 32) (a b q q0i : Value)
    (ha : KeygenPublicArguments.U32 a x) (hb : KeygenPublicArguments.U32 b y)
    (hq : KeygenPublicArguments.U32 q (18433#32)) (hq0i : KeygenPublicArguments.U32 q0i (18431#32)) :
    KeygenPublicScalar.Call (KeygenPublicScalar.name .mul) [a,b,q,q0i]
      (.uint32 (KeygenPublicLeafWords.montgomery x y 18433#32 18431#32)) :=
  KeygenPublicArguments.call_leaf_conversion .mul (by decide)
    [.uint32 x,.uint32 y,.uint32 (18433#32),.uint32 (18431#32)] [a,b,q,q0i] _
    (.cons _ _ _ _ _ _ _ ((KeygenPublicArguments.u32_self x).trans ha.symm)
      (.cons _ _ _ _ _ _ _ ((KeygenPublicArguments.u32_self y).trans hb.symm)
        (.cons _ _ _ _ _ _ _ ((KeygenPublicArguments.u32_self (18433#32)).trans hq.symm)
          (.cons _ _ _ _ _ _ _ ((KeygenPublicArguments.u32_self (18431#32)).trans hq0i.symm) .nil))))
    (PublicLeafSource157.mul x y 18433#32 18431#32)

theorem u32_arg (n : Nat) : KeygenPublicArguments.U32 (C99IntegerReference.convert .int32 n)
    (BitVec.ofNat 32 n) := KeygenPublicArguments.u32_literal n

theorem scalar_lit (s : State) (n : Nat) :
    KeygenPublicWord.scalar s (.literal .i32 n) (C99IntegerReference.convert .int32 n) :=
  C99ScalarReference.Eval.literal .int32 n

theorem eval_lit (s : State) (n : Nat) :
    KeygenPublicWord.Eval [] s (KeygenPublicTableAtoms.literal n) (C99IntegerReference.convert .int32 n) :=
  KeygenPublicWord.Eval.scalar (.literal .i32 n) _ (scalar_lit s n)

theorem eval_var (s : State) (n : String) (w : BitVec 32) (slot : Slot s n w) :
    KeygenPublicWord.Eval [] s (KeygenPublicTableAtoms.var n) (.uint32 w) :=
  KeygenPublicWord.Eval.scalar (.var n.toList) (.uint32 w)
    (C99ScalarReference.Eval.variable n.toList .uint32 (.uint32 w) slot)

theorem g_eval (s : State) :
    KeygenPublicWord.Eval [] s (mont (literal 25) (literal 4564)) (.uint32 convertedWord) :=
  KeygenPublicWord.Eval.call4 (KeygenPublicScalar.name .mul) (literal 25) (literal 4564)
    (KeygenPublicTableAtoms.literal 18433) (KeygenPublicTableAtoms.literal 18431)
    (C99IntegerReference.convert .int32 25) (C99IntegerReference.convert .int32 4564)
    (C99IntegerReference.convert .int32 18433) (C99IntegerReference.convert .int32 18431)
    (.uint32 (KeygenPublicLeafWords.montgomery 25#32 4564#32 18433#32 18431#32))
    (eval_lit s 25) (eval_lit s 4564) (eval_lit s 18433) (eval_lit s 18431)
    (mul_call 25#32 4564#32 _ _ _ _ (u32_arg 25) (u32_arg 4564)
      (u32_arg 18433) (u32_arg 18431))

theorem square_eval (s : State) (g : Slot s "g" convertedWord) :
    KeygenPublicWord.Eval [] s (mont (var "g") (var "g")) (.uint32 rootWord) :=
  KeygenPublicWord.Eval.call4 (KeygenPublicScalar.name .mul) (var "g") (var "g")
    (KeygenPublicTableAtoms.literal 18433) (KeygenPublicTableAtoms.literal 18431)
    (.uint32 convertedWord) (.uint32 convertedWord)
    (C99IntegerReference.convert .int32 18433) (C99IntegerReference.convert .int32 18431)
    (.uint32 (KeygenPublicLeafWords.montgomery convertedWord convertedWord 18433#32 18431#32))
    (eval_var s "g" convertedWord g) (eval_var s "g" convertedWord g)
    (eval_lit s 18433) (eval_lit s 18431)
    (mul_call convertedWord convertedWord (.uint32 convertedWord) (.uint32 convertedWord) _ _
      (KeygenPublicArguments.u32_self convertedWord) (KeygenPublicArguments.u32_self convertedWord)
      (u32_arg 18433) (u32_arg 18431))

theorem ig_eval (s : State) (g : Slot s "g" rootWord) :
    KeygenPublicWord.Eval [] s (divide (literal 4564) (var "g")) (.uint32 inverseWord) :=
  KeygenPublicWord.Eval.call2 (KeygenPublicScalar.name .divT) (literal 4564) (var "g")
    (C99IntegerReference.convert .int32 4564) (.uint32 rootWord)
    (.uint32 (KeygenPublicDivisionWords.division 4564#32 rootWord))
    (eval_lit s 4564) (eval_var s "g" rootWord g)
    (PublicDivisionSource157.source (.i32 4564#32) (.u32 rootWord))

theorem logn_eval (s : State) (profile : Slot s "logn" 10) :
    KeygenPublicWord.Eval [] s (var "logn") (.uint32 10) :=
  eval_var s "logn" 10 profile

theorem k_guard (s : State) (k : Slot s "k" 10) :
    KeygenPublicWord.Eval [] s (.cmp .lt (var "k") (literal 11)) (.int32 1) :=
  .cmp .lt _ _ _ _ _
    (.scalar _ _ (.variable _ _ _ k))
    (.scalar _ _ (.literal .int32 11))
    (.step .lt (.uint32 10) (.int32 11) .uint32 rfl (.uint32 10) (.uint32 11) rfl rfl)

theorem k_guard_false (s : State) (k : Slot s "k" 11) :
    KeygenPublicWord.Eval [] s (.cmp .lt (var "k") (literal 11)) (.int32 0) :=
  .cmp .lt _ _ _ _ _
    (.scalar _ _ (.variable _ _ _ k))
    (.scalar _ _ (.literal .int32 11))
    (.step .lt (.uint32 11) (.int32 11) .uint32 rfl (.uint32 11) (.uint32 11) rfl rfl)

theorem one_nonzero : (C99IntegerReference.Value.int32 1).integer≠0 := by decide
theorem zero_zero : (C99IntegerReference.Value.int32 0).integer=0 := by decide

theorem increment_exec (s : State) (w : BitVec 32)
    (slot : s.locals "k".toList=some (.uint32,some (.uint32 w))) :
    Exec KeygenPublicSource.program [] increment s
      ⟨C99ArrayReference.bindValue s "k".toList .uint32 (.uint32 (w+1#32)),.normal⟩ :=
  .scalar _ _ _
    (.assign s.locals "k".toList _ .uint32 (some (.uint32 w)) (.uint32 (w+1#32)) slot
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ slot) (.literal .int32 1)
        (.step .plus (.uint32 w) (.int32 1) .uint32 rfl (.uint32 w) (.uint32 1)
          (KeygenPublicArguments.u32_self w).symm rfl
          (by intro impossible; cases impossible))))

theorem loopFalse_helper (s : State) (k : Slot (squared s) "k" 11) :
    Exec KeygenPublicSource.program [] loop (squared s) ⟨squared s,.normal⟩ :=
  .loopFalse _ _ _ _ (.int32 0) (k_guard_false (squared s) k) zero_zero

theorem square_exec (s : State) (g : Slot (beforeSquare s) "g" convertedWord) :
    Exec KeygenPublicSource.program [] square (beforeSquare s) ⟨squared s,.normal⟩ :=
  .scope [] [] _ _ _
    (.seqNormal _ _ _ (C99ArrayReference.bindValue (beforeSquare s) "g".toList .uint32
        (.uint32 (KeygenPublicDivisionAlgebra.multiply convertedWord convertedWord))) _
      (.assign "g".toList _ _ .uint32 (some (.uint32 convertedWord)) (.uint32 rootWord)
        g (square_eval (beforeSquare s) g))
      (.skip _))

theorem loop_exec (s : State) : Exec KeygenPublicSource.program [] loop (setup s) ⟨squared s,.normal⟩ :=
  have kSetup : Slot (setup s) "k" 10 := (setup_slots s).2
  have gBefore : Slot (beforeSquare s) "g" convertedWord := (square_slots s).1
  have kSquared : Slot (squared s) "k" 11 := (squared_slots s).2
  have first : Exec KeygenPublicSource.program [] (.seq increment square) (setup s) ⟨squared s,.normal⟩ :=
    .seqNormal _ _ _ (beforeSquare s) _
      (increment_exec (setup s) 10 kSetup) (square_exec s gBefore)
  .loopNormal (.cmp .lt (var "k") (literal 11)) (.seq increment square) .skip
    (setup s) (squared s) (squared s) ⟨squared s,.normal⟩
    (.int32 1) (k_guard (setup s) kSetup) one_nonzero first (.skip _) (loopFalse_helper s kSquared)

theorem post_exec (s : State) : Exec KeygenPublicSource.program [] postLoop (setup s) ⟨completed s,.normal⟩ :=
  .seqNormal _ _ _ (squared s) _ (loop_exec s)
    (increment_exec (squared s) 11 (squared_slots s).2)

theorem head_source (s : State) (out : Result) (profile : Slot s "logn" 10)
    (rest : Exec KeygenPublicSource.program [] suffix (ready s) out) :
    Exec KeygenPublicSource.program [] (KeygenPublicSource.code .generate) s out := by
  rw [KeygenPublicTableSeed.source_complete]
  have declU : Exec KeygenPublicSource.program [] (.scalar (.declare .u64 ["u".toList])) s
      ⟨declaredU s,.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint64 ["u".toList] s.locals)
  have declK : Exec KeygenPublicSource.program [] (.scalar (.declare .u32 ["k".toList])) (declaredU s)
      ⟨declaredK s,.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32 ["k".toList]
      (declaredU s).locals)
  have declL : Exec KeygenPublicSource.program [] (.scalar (.declare .u32 (locals.map String.toList)))
      (declaredK s) ⟨declared s,.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32
      (locals.map String.toList) (declaredK s).locals)
  have gStep : Exec KeygenPublicSource.program [] (.assign "g".toList (mont (literal 25) (literal 4564)))
      (declared s) ⟨converted s,.normal⟩ :=
    .assign "g".toList _ _ .uint32 none (.uint32 convertedWord) (declared_g s) (g_eval (declared s))
  have kStep : Exec KeygenPublicSource.program [] (.assign "k".toList (var "logn")) (converted s)
      ⟨setup s,.normal⟩ :=
    .assign "k".toList _ _ .uint32 none (.uint32 10) (converted_k_declared s)
      (logn_eval (converted s) (converted_profile s profile))
  have igStep : Exec KeygenPublicSource.program [] (.assign "ig".toList (divide (literal 4564) (var "g")))
      (completed s) ⟨ready s,.normal⟩ :=
    .assign "ig".toList _ _ .uint32 none (.uint32 inverseWord) (completed_ig_declared s)
      (ig_eval (completed s) (completed_g s))
  exact .seqNormal _ _ _ (declaredU s) _ declU
    (.seqNormal _ _ _ (declaredK s) _ declK
      (.seqNormal _ _ _ (declared s) _ declL
        (.seqNormal _ _ _ (converted s) _ gStep
          (.seqNormal _ _ _ (setup s) _ kStep
            (.seqNormal _ _ _ (completed s) _ (post_exec s)
              (.seqNormal _ _ _ (ready s) _ igStep rest))))))

end FT1536.Source3.PublicGenerateHead159
